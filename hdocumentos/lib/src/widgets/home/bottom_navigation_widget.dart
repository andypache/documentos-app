import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/common/reload_confirm_dialog.dart';

/// Barra de navegación inferior.
///
/// Ítems fijos: Factura | Actualizar | [Configurar] | Salir
/// [Configurar] → visible SOLO cuando [AppInitProvider.hasCompany] es true.
class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  Future<void> _onReloadPressed(BuildContext context) async {
    final confirmed = await showReloadConfirmDialog(context);
    if (confirmed != true || !context.mounted) return;

    final l10n = AppLocalizations.of(context);
    final initProvider = context.read<AppInitProvider>();

    await initProvider.reload(context);

    if (!context.mounted) return;
    final isSuccess = initProvider.isReady;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSuccess ? l10n.reloadSuccess : initProvider.errorMessage,
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        backgroundColor:
            isSuccess ? AppTheme.actionSave : AppTheme.actionDanger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authService = Provider.of<AuthService>(context);
    final initProvider = context.watch<AppInitProvider>();
    final hasCompany = initProvider.hasCompany;

    // Índices calculados dinámicamente según presencia del botón Configurar
    // Factura=0 | Actualizar=1 | [Config=2] | Salir=2|3
    const syncIndex = 1;
    final configIndex = hasCompany ? 2 : -1;
    final logoutIndex = hasCompany ? 3 : 2;

    // Construcción dinámica de ítems
    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.receipt_long_outlined),
        label: l10n.navBill,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.sync_rounded),
        label: l10n.reloadDialogTitle,
      ),
      if (hasCompany)
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          label: l10n.navConfig,
        ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.logout_rounded),
        label: l10n.navLogout,
      ),
    ];

    return BottomNavigationBar(
      onTap: (int index) async {
        if (index == logoutIndex) {
          await authService.logout();
          if (context.mounted) {
            context.read<AppInitProvider>().reset();
            Navigator.pushReplacementNamed(context, 'login');
          }
        } else if (index == configIndex) {
          Navigator.pushNamed(context, 'config');
        } else if (index == syncIndex) {
          await _onReloadPressed(context);
        }
        // índice 0 → factura: pendiente de implementar
      },
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: AppTheme.primaryButton,
      backgroundColor: AppTheme.bottomNavBg,
      unselectedItemColor: AppTheme.primaryButton,
      currentIndex: 0,
      items: items,
    );
  }
}
