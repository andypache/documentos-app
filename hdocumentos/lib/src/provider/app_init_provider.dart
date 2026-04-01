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
  Future<void> init(BuildContext context, {bool forceRefresh = false}) async {
    // Bloquear siempre si ya hay una carga en curso (evita ejecuciones concurrentes)
    if (_status == AppInitStatus.loading) return;
    // Sin forceRefresh, también bloquear si ya está listo
    if (!forceRefresh && _status == AppInitStatus.ready) return;

    _setStatus(AppInitStatus.loading);

    // Limpiar catálogos para que _catalogs==null detecte fallo real tras la carga
    if (forceRefresh) _catalogs = null;

    // Capturar l10n antes del primer await — soluciona el bug de idioma
    final l10n = AppLocalizations.of(context);

    try {
      await _loadCatalogs(context, l10n, forceRefresh: forceRefresh);
      // Fallo real de API: _catalogs sigue null → pasar a error
      if (_catalogs == null) {
        _errorMessage = l10n.initApplicationError;
        _setStatus(AppInitStatus.error);
        return;
      }
      // ignore: use_build_context_synchronously
      await _loadCompany(context, forceRefresh: forceRefresh);
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

  /// Fuerza la recarga de catálogos y datos de empresa aunque ya estén listos.
  /// Envía `X-Refresh-Cache: true` en cada petición HTTP para invalidar
  /// la caché del backend, y elimina la caché local de catálogos.
  ///
  /// No resetea el estado antes de llamar a [init] para evitar notificaciones
  /// dobles; [init] transiciona directamente de cualquier estado a [loading].
  Future<void> reload(BuildContext context) async {
    await init(context, forceRefresh: true);
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
    BuildContext context,
    AppLocalizations l10n, {
    bool forceRefresh = false,
  }) async {
    final result =
        await _companyService.getCatalogs(context, forceRefresh: forceRefresh);
    if (result != null) _catalogs = result;
    // Si result==null (API falló o contexto desmontado), _catalogs queda null
    // y el flujo en init() lo detecta y pasa a estado error.
  }

  /// Carga la empresa por defecto. No lanza excepción si no existe (404):
  /// en ese caso [_hasCompany] queda en false y el flujo continúa normal.
  Future<void> _loadCompany(
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    final result =
        await _companyService.getCompany(context, forceRefresh: forceRefresh);
    _company = result;
    _hasCompany = result != null;
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _setStatus(AppInitStatus status) {
    _status = status;
    notifyListeners();
  }
}
