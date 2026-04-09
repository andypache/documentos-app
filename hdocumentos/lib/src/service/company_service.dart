import 'dart:convert';

// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/share/preference.dart';

class CompanyService extends ChangeNotifier {
  static const _cacheKey = 'catalogs';
  static const _storage = FlutterSecureStorage();

  /// Retorna los catálogos del sistema.
  /// Primero intenta desde caché local; si no existe, los obtiene del API
  /// y los persiste para futuras llamadas.
  ///
  /// Si [forceRefresh] es true, elimina la caché local y envía el header
  /// `X-Refresh-Cache: true` para que el backend invalide su propia caché.
  Future<CatalogModelList?> getCatalogs(
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    // Capturar el contexto antes de cualquier await para evitar
    // el warning use_build_context_synchronously y el bug de contexto desmontado.
    // getFetch maneja internamente el caso !context.mounted.
    final extraHeaders = forceRefresh ? _refreshCacheHeader : null;

    if (forceRefresh) await _storage.delete(key: _cacheKey);

    final cached = await _readFromCache();
    if (cached != null) return cached;

    return await _fetchFromApi(
      context,
      extraHeaders: extraHeaders,
    );
  }

  static const Map<String, String> _refreshCacheHeader = {
    'X-Refresh-Cache': 'true',
  };

  // ─── Caché ────────────────────────────────────────────────────────────────

  Future<CatalogModelList?> _readFromCache() async {
    try {
      final raw = await _storage.read(key: _cacheKey);
      if (raw == null || raw.isEmpty) return null;
      return CatalogModelList.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Caché corrupto — ignorar y recargar desde API
      await _storage.delete(key: _cacheKey);
      return null;
    }
  }

  Future<void> _writeToCache(Map<String, dynamic> data) async {
    await _storage.write(key: _cacheKey, value: jsonEncode(data));
  }

  // ─── API ──────────────────────────────────────────────────────────────────

  Future<CatalogModelList?> _fetchFromApi(
    BuildContext context, {
    Map<String, String>? extraHeaders,
  }) async {
    final response = await getFetch(
      context: context,
      url: apiDataCatalog,
      params: {},
      extraHeaders: extraHeaders,
    );

    if (response.statusHttp != 200) {
      NotificationService.showSnackbarError(response.message);
      return null;
    }

    return _parseResponse(response);
  }

  Future<CatalogModelList?> _parseResponse(
      ServiceResponseModel response) async {
    final l10n = NotificationService.l10n;
    try {
      final responseModel = response.createDataResponse();
      final data = responseModel.response;

      if (data is! Map<String, dynamic> || data.isEmpty) {
        NotificationService.showSnackbarError(
            l10n!.invalidDataFormatForCatalogs);
        return null;
      }

      await _writeToCache(data);
      return CatalogModelList.fromJson(data);
    } catch (_) {
      NotificationService.showSnackbarError(l10n!.invalidDataFormatForCatalogs);
      return null;
    }
  }

  /// Invalida el caché para forzar recarga desde API en la próxima llamada.
  static Future<void> clearCache() async {
    await _storage.delete(key: _cacheKey);
  }

  // ─── Compañía ─────────────────────────────────────────────────────────────

  /// Obtiene la compañía por defecto desde el API.
  /// Retorna null si no existe (404) o si ocurre un error.
  ///
  /// Si [forceRefresh] es true, envía `X-Refresh-Cache: true` para que
  /// el backend invalide su caché antes de responder.
  Future<CompanyModel?> getCompany(
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    final username = Preferences.userSession.username;
    if (username.isEmpty) return null;

    final response = await getFetch(
      context: context,
      url: apiCompanyDefault,
      params: {'username': username},
      extraHeaders: forceRefresh ? _refreshCacheHeader : null,
    );

    if (response.statusHttp == 404) return null;

    if (response.statusHttp != 200) {
      NotificationService.showSnackbarError(response.message);
      return null;
    }

    try {
      final data = response.createDataResponse().response;
      if (data is! Map<String, dynamic>) return null;
      return CompanyModel.fromJson(data);
    } catch (_) {
      NotificationService.showSnackbarError(
          NotificationService.l10n?.companyDataProcessError ??
              'Error al procesar los datos de la compañía');
      return null;
    }
  }

  Future<CompanyModel> createCompany(
      BuildContext context, CompanyModel companyModel) {
    return postFetch(
      context: context,
      url: apiCompanyCreate,
      body: companyModel.toJson(),
    ).then((response) async {
      if (response.statusHttp != 201) {
        throw Exception(await _parseResponseError(response));
      }
      final data = response.createDataResponse().response;
      if (data is! Map<String, dynamic>) {
        throw Exception(NotificationService.l10n?.companyCreatedInvalidFormat ??
            'Formato de datos inválido para la compañía creada');
      }
      return CompanyModel.fromJson(data);
    });
  }

  // ─── Últimas ventas ───────────────────────────────────────────────────────

  /// Obtiene el listado de últimas ventas del endpoint `bills/last-sales`.
  /// Retorna null si ocurre un error o si el contexto fue desmontado.
  /// Retorna lista vacía si la respuesta es 200 pero no hay registros.
  Future<List<LastSaleModel>?> getLastSales(BuildContext context) async {
    final response = await getFetch(
      context: context,
      url: apiLastSales,
      params: {},
    );

    if (response.statusHttp == 404) return [];

    if (response.statusHttp != 200) {
      NotificationService.showSnackbarError(response.message);
      return null;
    }

    try {
      final data = response.createDataResponse().response;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(LastSaleModel.fromJson)
            .toList();
      }
      // El backend puede envolver la lista en { "data": [...] }
      if (data is Map<String, dynamic>) {
        final list = data['data'] ?? data['content'] ?? data['items'];
        if (list is List) {
          return list
              .whereType<Map<String, dynamic>>()
              .map(LastSaleModel.fromJson)
              .toList();
        }
      }
      return [];
    } catch (_) {
      NotificationService.showSnackbarError(
          NotificationService.l10n?.companyDataProcessError ??
              'Error al procesar las últimas ventas');
      return null;
    }
  }

  Future<String> _parseResponseError(ServiceResponseModel response) async {
    try {
      final responseModel = response.createDataResponse();
      final data = responseModel.response;
      if (data is Map<String, dynamic> && data.containsKey('error')) {
        return data['error'] as String;
      }
    } catch (_) {
      // Ignorar errores de parsing y retornar mensaje genérico
    }
    return NotificationService.l10n?.companyDataProcessError ??
        'Error al procesar la operación de compañía';
  }
}
