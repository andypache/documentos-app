import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Barra de navegación inferior.
///
/// Ítems base: Factura | Reportes | Salir
/// Ítem adicional (índice 2, antes de Salir): Configurar
///   → visible SOLO cuando [AppInitProvider.hasCompany] es true.
class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authService = Provider.of<AuthService>(context);
    final initProvider = context.watch<AppInitProvider>();
    final hasCompany = initProvider.hasCompany;

    // Construcción dinámica de ítems
    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.point_of_sale_outlined),
        label: l10n.navBill,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.calendar_today_outlined),
        label: l10n.navReports,
      ),
      // Botón Configurar: solo visible cuando la empresa ya está configurada
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

    // Índice del botón "Salir" según si config está presente
    final logoutIndex = hasCompany ? 3 : 2;
    final configIndex = hasCompany ? 2 : -1;

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
        }
        // índice 0 → bill, 1 → report: pendiente de implementar
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
