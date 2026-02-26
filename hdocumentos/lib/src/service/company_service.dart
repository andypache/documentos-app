import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/constant/constant.dart';

class CompanyService extends ChangeNotifier {
  static const _cacheKey = 'catalogs';
  final _storage = const FlutterSecureStorage();

  /// Retorna los catálogos del sistema.
  /// Primero intenta desde caché local; si no existe, los obtiene del API
  /// y los persiste para futuras llamadas.
  Future<CatalogModelList?> getCatalogs(BuildContext context) async {
    final cached = await _readFromCache();
    if (cached != null) return cached;

    if (!context.mounted) return null;
    return await _fetchFromApi(context);
  }

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

  Future<CatalogModelList?> _fetchFromApi(BuildContext context) async {
    final response =
        await getFetch(context: context, url: apiDataCatalog, params: {});

    if (response.statusHttp != 200) {
      NotificationService.showSnackbarError(response.message);
      return null;
    }

    return _parseResponse(response);
  }

  CatalogModelList? _parseResponse(ServiceResponseModel response) {
    final l10n = NotificationService.l10n;
    try {
      final responseModel = response.createDataResponse();
      final data = responseModel.response;
      print(data.runtimeType);

      if (data is! Map<String, dynamic> || data.isEmpty) {
        NotificationService.showSnackbarError(
            l10n!.invalidDataFormatForCatalogs);
        return null;
      }

      _writeToCache(data);
      return CatalogModelList.fromJson(data);
    } catch (_) {
      NotificationService.showSnackbarError(l10n!.invalidDataFormatForCatalogs);
      return null;
    }
  }

  /// Invalida el caché para forzar recarga desde API en la próxima llamada.
  Future<void> clearCache() async {
    await _storage.delete(key: _cacheKey);
  }
}
