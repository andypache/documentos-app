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
AuthService authService = AuthService();

// ─── Fachada pública ──────────────────────────────────────────────────────────

/// Realiza una petición GET autenticada.
/// Maneja refresco de token automático ante 401.
/// [extraHeaders] permite inyectar cabeceras adicionales (ej: X-Refresh-Cache).
Future<ServiceResponseModel> getFetch({
  required BuildContext context,
  required String url,
  required Map<String, dynamic> params,
  Map<String, String>? extraHeaders,
}) async {
  final result = await _HttpClient.get(
      url: url, params: params, extraHeaders: extraHeaders);
  if (!context.mounted) return result;
  return await _TokenRefreshHandler.handle(
        context: context,
        result: result,
        url: url,
        body: params,
        method: _HttpMethod.get,
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

/// Realiza una petición PUT autenticada.
/// Maneja refresco de token automático ante 401.
Future<ServiceResponseModel> putFetch({
  required BuildContext context,
  required String url,
  required Object body,
}) async {
  final result = await _HttpClient.put(url: url, body: body);
  if (!context.mounted) return result;
  return await _TokenRefreshHandler.handle(
        context: context,
        result: result,
        url: url,
        body: body,
        method: _HttpMethod.put,
      ) ??
      result;
}

/// Realiza una petición PATCH autenticada.
/// Maneja refresco de token automático ante 401.
Future<ServiceResponseModel> patchFetch({
  required BuildContext context,
  required String url,
  required Object body,
}) async {
  final result = await _HttpClient.patch(url: url, body: body);
  if (!context.mounted) return result;
  return await _TokenRefreshHandler.handle(
        context: context,
        result: result,
        url: url,
        body: body,
        method: _HttpMethod.patch,
      ) ??
      result;
}

/// Realiza una petición DELETE autenticada.
Future<ServiceResponseModel> deleteFetch({
  required BuildContext context,
  required String url,
}) async {
  final result = await _HttpClient.delete(url: url);
  if (!context.mounted) return result;
  return await _TokenRefreshHandler.handle(
        context: context,
        result: result,
        url: url,
        body: {},
        method: _HttpMethod.delete,
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

Object getError(ServiceResponseModel response) {
  // 1. Campo error directo del modelo (OAuth / errores de autenticación)
  if (response.error != null &&
      response.error!.isNotEmpty &&
      response.error != 'null') {
    return response.error!;
  }

  // 2. Mensaje directo del modelo
  if (response.message.isNotEmpty && response.message != 'null') {
    return response.message;
  }

  // 3. Anidado en body['response']['error']
  try {
    final bodyError = response.body?['response']?['error'];
    if (bodyError != null &&
        bodyError.toString().isNotEmpty &&
        bodyError.toString() != 'null') {
      return bodyError.toString();
    }

    // 4. Anidado en body['response']['message']
    final bodyMessage = response.body?['response']?['message'];
    if (bodyMessage != null &&
        bodyMessage.toString().isNotEmpty &&
        bodyMessage.toString() != 'null') {
      return bodyMessage.toString();
    }

    // 5. Directo en body['message']
    final rootMessage = response.body?['message'];
    if (rootMessage != null &&
        rootMessage.toString().isNotEmpty &&
        rootMessage.toString() != 'null') {
      return rootMessage.toString();
    }
  } catch (_) {
    // body con formato inesperado → caer al fallback
  }

  // 6. Fallback genérico
  return NotificationService.l10n?.saveError ??
      'Error al ejecutar la operación, por favor intente más tarde.';
}
// ─── Cliente HTTP ─────────────────────────────────────────────────────────────

/// Responsabilidad: construir headers y ejecutar llamadas HTTP.
class _HttpClient {
  static const int _errorStatus = 509;
  static const Duration _timeout = Duration(seconds: 15);

  /// Construye los headers de autorización con el token almacenado.
  /// Incluye [Accept-Language] con el idioma seleccionado por el usuario.
  static Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: 'access_token') ?? '';
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptLanguageHeader: Preferences.language,
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
  /// [extraHeaders] se fusionan sobre los headers de autorización.
  static Future<ServiceResponseModel> get({
    required String url,
    required Map<String, dynamic> params,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      final uri = _buildUri(url, params);
      final headers = await _authHeaders();
      if (extraHeaders != null) headers.addAll(extraHeaders);
      final response = await http.get(uri, headers: headers).timeout(_timeout);
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
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      return getResponse(response);
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
      return _errorResponse();
    }
  }

  /// Ejecuta PUT autenticado con body JSON.
  static Future<ServiceResponseModel> put({
    required String url,
    required Object body,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .put(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      return getResponse(response);
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
      return _errorResponse();
    }
  }

  /// Ejecuta PATCH autenticado con body JSON.
  static Future<ServiceResponseModel> patch({
    required String url,
    required Object body,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .patch(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      return getResponse(response);
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
      return _errorResponse();
    }
  }

  /// Ejecuta DELETE autenticado sin body.
  static Future<ServiceResponseModel> delete({
    required String url,
  }) async {
    try {
      final headers = await _authHeaders();
      final response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(_timeout);
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
      final response = await http
          .post(
            Uri.parse(url),
            headers: header,
            body: body,
          )
          .timeout(_timeout);
      return getResponse(response);
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
      return _errorResponse();
    }
  }
}

// ─── Tipo de petición HTTP ───────────────────────────────────────────────────

enum _HttpMethod { get, post, put, patch, delete }

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
    _HttpMethod method = _HttpMethod.post,
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
      method: method,
    );
  }

  /// Renueva el access token usando el refresh token y reintenta la petición.
  static Future<ServiceResponseModel?> _refreshAndRetry({
    required BuildContext context,
    required String url,
    required Object body,
    _HttpMethod method = _HttpMethod.post,
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
    if (method == _HttpMethod.get && body is Map<String, dynamic>) {
      return await _HttpClient.get(url: url, params: body);
    } else if (method == _HttpMethod.put) {
      return await _HttpClient.put(url: url, body: body);
    } else if (method == _HttpMethod.patch) {
      return await _HttpClient.patch(url: url, body: body);
    } else if (method == _HttpMethod.delete) {
      return await _HttpClient.delete(url: url);
    } else {
      return await _HttpClient.post(url: url, body: body);
    }
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
