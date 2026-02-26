import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';

/// Estado de la inicialización de la app
enum AppInitStatus { idle, loading, ready, error }

/// Responsabilidad: cargar los datos globales de la sesión (catálogos,
/// parámetros del sistema) una única vez tras el login.
/// Expone [catalogs] y [status] para que cualquier widget descendiente
/// pueda acceder a los datos sin volver a solicitarlos al backend.
class AppInitProvider extends ChangeNotifier {
  final CompanyService _companyService = CompanyService();

  AppInitStatus _status = AppInitStatus.idle;
  String _errorMessage = '';
  CatalogModelList? _catalogs;

  // ─── Getters ────────────────────────────────────────────────────────────────

  AppInitStatus get status => _status;
  String get errorMessage => _errorMessage;
  CatalogModelList? get catalogs => _catalogs;

  bool get isLoading => _status == AppInitStatus.loading;
  bool get isReady => _status == AppInitStatus.ready;
  bool get hasError => _status == AppInitStatus.error;

  // ─── Inicialización ─────────────────────────────────────────────────────────

  /// Carga todos los datos globales necesarios para la sesión.
  /// Debe llamarse una sola vez al montar [HomeScreen].
  Future<void> init(BuildContext context) async {
    if (_status == AppInitStatus.ready || _status == AppInitStatus.loading) {
      return;
    }

    _setStatus(AppInitStatus.loading);

    try {
      await _loadCatalogs(context);
      if (!context.mounted) return;
      _setStatus(AppInitStatus.ready);
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AppInitStatus.error);
    }
  }

  /// Permite reintentar la carga tras un error.
  Future<void> retry(BuildContext context) async {
    _status = AppInitStatus.idle;
    await init(context);
  }

  /// Limpia el estado de la sesión. Llamar en logout para que la próxima
  /// sesión recargue los catálogos desde cero.
  void reset() {
    _status = AppInitStatus.idle;
    _catalogs = null;
    _errorMessage = '';
    notifyListeners();
  }

  // ─── Carga de datos ─────────────────────────────────────────────────────────

  Future<void> _loadCatalogs(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final result = await _companyService.getCatalogs(context);
    if (result == null) {
      throw Exception(l10n.initApplicationError);
    }
    _catalogs = result;
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  void _setStatus(AppInitStatus status) {
    _status = status;
    notifyListeners();
  }
}
