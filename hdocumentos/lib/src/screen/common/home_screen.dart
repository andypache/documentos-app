import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/constant/example_data.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
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
    // Diferir al primer frame para tener context disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppInitProvider>().init(context);
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),
          Text(
            l10n.loading,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
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
            const Icon(Icons.cloud_off_rounded,
                color: Colors.white70, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
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
                    backgroundColor: Colors.red.shade700,
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

///Body for home into sroll view
class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  ///Put user session title and cart menu
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      UserSessionTitle(),
      //SingleChildScrollView(child: CartTableWidget())
      SingleChildScrollView(
          child: Column(children: [
        const CardSwiperWidget(),
        const SizedBox(height: 20),
        CardSlider(bills: billExamples, title: "Mis Ventas", onNextPage: () {})
      ]))
    ]);
  }
}
