import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:provider/provider.dart';

// ─── Instancias globales ──────────────────────────────────────────────────────
const _storage = FlutterSecureStorage();
// ignore: deprecated_member_use
const storage = _storage; // alias público para compatibilidad
AuthService authService = AuthService();

// ─── Fachada pública ──────────────────────────────────────────────────────────

/// Realiza una petición GET autenticada.
/// Maneja refresco de token automático ante 401.
Future<ServiceResponseModel> getFetch({
  required BuildContext context,
  required String url,
  required Map<String, dynamic> params,
}) async {
  final result = await _HttpClient.get(url: url, params: params);
  if (!context.mounted) return result;
  return await _TokenRefreshHandler.handle(
        context: context,
        result: result,
        url: url,
        body: params,
      ) ??
      result;
}

/// Realiza una petición POST autenticada.
/// Maneja refresco de token automático ante 401.
Future<ServiceResponseModel> postFetch({
  required BuildContext context,
  required String url,
  required Object body,
}) async {
  final result = await _HttpClient.post(url: url, body: body);
  if (!context.mounted) return result;
  return await _TokenRefreshHandler.handle(
        context: context,
        result: result,
        url: url,
        body: body,
      ) ??
      result;
}

/// Realiza una petición POST con form-data (sin token Bearer).
/// Usado para autenticación OAuth.
Future<ServiceResponseModel> postFormFetch({
  required String url,
  required dynamic body,
  required Map<String, String> header,
}) async {
  return await _HttpClient.postForm(url: url, body: body, header: header);
}

/// Parsea la respuesta HTTP a [ServiceResponseModel].
ServiceResponseModel getResponse(http.Response response) {
  final data = json.decode(response.body);
  return ServiceResponseModel.fromJson(response.statusCode, data);
}

// ─── Cliente HTTP ─────────────────────────────────────────────────────────────

/// Responsabilidad: construir headers y ejecutar llamadas HTTP.
class _HttpClient {
  static const int _errorStatus = 509;

  /// Construye los headers de autorización con el token almacenado.
  static Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: 'access_token') ?? '';
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Construye la URI con query parameters para peticiones GET.
  static Uri _buildUri(String url, Map<String, dynamic> params) {
    if (params.isEmpty) return Uri.parse(url);
    return Uri.parse(url).replace(
      queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  /// Respuesta de error general para fallos de comunicación.
  static ServiceResponseModel _errorResponse() {
    return ServiceResponseModel(
      statusHttp: _errorStatus,
      status: '-1',
      message: generalError,
      body: ResponseModel.createEmpty(),
    );
  }

  /// Ejecuta GET autenticado.
  static Future<ServiceResponseModel> get({
    required String url,
    required Map<String, dynamic> params,
  }) async {
    try {
      final uri = _buildUri(url, params);
      final headers = await _authHeaders();
      final response = await http.get(uri, headers: headers);
      return getResponse(response);
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
      return _errorResponse();
    }
  }

  /// Ejecuta POST autenticado con body JSON.
  static Future<ServiceResponseModel> post({
    required String url,
    required Object body,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return getResponse(response);
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
      return _errorResponse();
    }
  }

  /// Ejecuta POST con form-data (OAuth).
  static Future<ServiceResponseModel> postForm({
    required String url,
    required dynamic body,
    required Map<String, String> header,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: body,
      );
      return getResponse(response);
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
      return _errorResponse();
    }
  }
}

// ─── Manejador de refresco de token ──────────────────────────────────────────

/// Responsabilidad: renovar el token ante 401 y reintentar la petición,
/// o redirigir al login si no es posible renovar.
class _TokenRefreshHandler {
  /// Evalúa el resultado y actúa ante un 401.
  /// Retorna la respuesta del reintento, o null si no hubo 401.
  static Future<ServiceResponseModel?> handle({
    required BuildContext context,
    required ServiceResponseModel result,
    required String url,
    required Object body,
  }) async {
    if (result.statusHttp != 401) return null;

    if (!Preferences.keepSession) {
      await _logout(context);
      return null;
    }

    return await _refreshAndRetry(
      context: context,
      url: url,
      body: body,
    );
  }

  /// Renueva el access token usando el refresh token y reintenta la petición.
  static Future<ServiceResponseModel?> _refreshAndRetry({
    required BuildContext context,
    required String url,
    required Object body,
  }) async {
    final refreshToken = await _storage.read(key: 'refresh_token') ?? '';
    final refreshResult = await AuthService.refreshLogin(
      Preferences.userSession.username,
      refreshToken,
    );
    await authService.createSession(refreshResult);

    if (!context.mounted) return null;

    if (refreshResult.statusHttp != 200) {
      await _logout(context);
      return null;
    }

    // Reintentar con el nuevo token según el tipo de petición
    return body is Map<String, dynamic>
        ? await _HttpClient.get(url: url, params: body)
        : await _HttpClient.post(url: url, body: body);
  }

  /// Cierra la sesión y redirige al login.
  static Future<void> _logout(BuildContext context) async {
    await authService.logout();
    if (context.mounted) {
      context.read<AppInitProvider>().reset();
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
