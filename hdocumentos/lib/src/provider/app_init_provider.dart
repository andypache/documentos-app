import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';

/// Estado de la inicialización de la app
enum AppInitStatus { idle, loading, ready, error }

/// Responsabilidad: cargar catálogos y datos de empresa una vez por sesión.
///
/// - [catalogs]: catálogos del sistema (tipos de documento, impuestos, etc.)
/// - [company]: datos de la compañía configurada. Puede ser null si aún no
///   está configurada (respuesta 404 o error).
/// - [hasCompany]: true cuando [company] se cargó con éxito (HTTP 200).
///   Controla la visibilidad del menú "Configuración" y el botón del BottomNav.
class AppInitProvider extends ChangeNotifier {
  final CompanyService _companyService = CompanyService();

  AppInitStatus _status = AppInitStatus.idle;
  String _errorMessage = '';
  CatalogModelList? _catalogs;
  CompanyModel? _company;
  bool _hasCompany = false;

  // ─── Getters ───────────────────────────────────────────────────────────────

  AppInitStatus get status => _status;
  String get errorMessage => _errorMessage;
  CatalogModelList? get catalogs => _catalogs;
  CompanyModel? get company => _company;

  /// true → empresa ya configurada → mostrar botón config en BottomNav,
  ///         ocultar tarjeta "CONFIGURACIÓN" del swiper.
  /// false → empresa no configurada → mostrar tarjeta config en swiper,
  ///          ocultar botón config en BottomNav.
  bool get hasCompany => _hasCompany;

  bool get isLoading => _status == AppInitStatus.loading;
  bool get isReady => _status == AppInitStatus.ready;
  bool get hasError => _status == AppInitStatus.error;

  // ─── Inicialización ────────────────────────────────────────────────────────

  /// Llama primero a [getCatalogs] y luego a [getCompany].
  /// Debe invocarse una sola vez al montar [HomeScreen].
  ///
  /// IMPORTANTE: capturamos [l10n] ANTES de cualquier await para evitar
  /// el problema de locale incorrecto cuando el contexto ya cambió.
  Future<void> init(BuildContext context) async {
    if (_status == AppInitStatus.ready || _status == AppInitStatus.loading) {
      return;
    }
    _setStatus(AppInitStatus.loading);

    // Capturar l10n antes del primer await — soluciona el bug de idioma
    final l10n = AppLocalizations.of(context);

    try {
      await _loadCatalogs(context, l10n);
      if (!context.mounted) return;
      await _loadCompany(context);
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

  /// Limpia el estado de la sesión (usar en logout).
  void reset() {
    _status = AppInitStatus.idle;
    _catalogs = null;
    _company = null;
    _hasCompany = false;
    _errorMessage = '';
    notifyListeners();
  }

  // ─── Carga de datos ────────────────────────────────────────────────────────

  Future<void> _loadCatalogs(
      BuildContext context, AppLocalizations l10n) async {
    final result = await _companyService.getCatalogs(context);
    if (result == null) {
      throw Exception(l10n.initApplicationError);
    }
    _catalogs = result;
  }

  /// Carga la empresa por defecto. No lanza excepción si no existe (404):
  /// en ese caso [_hasCompany] queda en false y el flujo continúa normal.
  Future<void> _loadCompany(BuildContext context) async {
    final result = await _companyService.getCompany(context);
    _company = result;
    _hasCompany = result != null;
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _setStatus(AppInitStatus status) {
    _status = status;
    notifyListeners();
  }
}
