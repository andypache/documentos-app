import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:hdocumentos/src/router/app_routes.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Pantalla principal de la app. Inicia la carga de catálogos y parámetros
/// del sistema una única vez por sesión mediante [AppInitProvider].
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Solo iniciar si no se hizo ya (login y check lo llaman antes de navegar).
    // Salvaguarda para accesos directos o recarga inesperada.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppInitProvider>();
      if (provider.status == AppInitStatus.idle) {
        provider.init(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final initProvider = context.watch<AppInitProvider>();

    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          if (initProvider.isLoading) const _LoadingOverlay(),
          if (initProvider.hasError)
            _ErrorOverlay(
              message: initProvider.errorMessage,
              onRetry: () => initProvider.retry(context),
            ),
          if (initProvider.isReady) const _HomeScreenBody(),
        ],
      ),
      bottomNavigationBar:
          initProvider.isReady ? const BottomNavigationWidget() : null,
    );
  }
}

// ─── Overlay de carga ────────────────────────────────────────────────────────

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppLoadingWidget(
      label: l10n.loading,
      overlay: true,
      color: AppTheme.white,
    );
  }
}

// ─── Overlay de error ────────────────────────────────────────────────────────

class _ErrorOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorOverlay({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                color: AppTheme.white.withOpacity(0.7), size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppTheme.white.withOpacity(0.7), fontSize: 13),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.btnRetry),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await context.read<AuthService>().logout();
                    if (context.mounted) {
                      context.read<AppInitProvider>().reset();
                      Navigator.pushReplacementNamed(context, 'login');
                    }
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(l10n.btnLogout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.actionDanger,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///Body for home into scroll view
class _HomeScreenBody extends StatefulWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  @override
  State<_HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<_HomeScreenBody> {
  /// Abre el diálogo de confirmación y, si el usuario acepta, recarga
  /// catálogos y datos de empresa mostrando feedback visual al terminar.
  Future<void> _onReloadPressed() async {
    final confirmed = await showReloadConfirmDialog(context);
    if (confirmed != true || !context.mounted) return;

    final l10n = AppLocalizations.of(context);
    final initProvider = context.read<AppInitProvider>();

    await initProvider.reload(context);

    if (!context.mounted) return;
    final isSuccess = initProvider.isReady;
    if (isSuccess) {
      NotificationService.showSuccess(l10n.reloadSuccess);
    } else {
      NotificationService.showError(initProvider.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final initProvider = context.watch<AppInitProvider>();
    final menus = AppRoutes.buildHomeMenus(
      l10n,
      hasCompany: initProvider.hasCompany,
    );

    return Column(children: [
      _HomeTopBar(onReload: initProvider.hasCompany ? _onReloadPressed : null),
      if (initProvider.isLoading)
        const Expanded(
          child: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryButton),
          ),
        )
      else
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: [
              CardSwiperWidget(menus: menus),
              const SizedBox(height: 36),
              if (initProvider.hasCompany)
                LastSalesWidget(
                  sales: initProvider.lastSales,
                  title: l10n.homeSalesTitle,
                ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
    ]);
  }
}

// ─── Barra superior con título de sesión + botón recarga ────────────────────

class _HomeTopBar extends StatelessWidget {
  final VoidCallback? onReload;

  const _HomeTopBar({this.onReload});

  @override
  Widget build(BuildContext context) {
    return const UserSessionTitle();
  }
}
