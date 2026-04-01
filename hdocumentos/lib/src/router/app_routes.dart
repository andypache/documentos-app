import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/screen/screen.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Clase que centraliza todas las rutas y los elementos de menú de la app.
class AppRoutes {
  /// Construye la lista de opciones del swiper del home.
  ///
  /// [l10n] provee los textos traducidos.
  /// [hasCompany] controla si se incluye la tarjeta de Configuración:
  ///   - false → empresa no configurada → mostrar CONFIGURACIÓN en el swiper.
  ///   - true  → empresa ya configurada → NO mostrar en swiper (va en BottomNav).
  static List<MenuOptionModel> buildHomeMenus(
    AppLocalizations l10n, {
    required bool hasCompany,
  }) {
    // Sin company → solo CONFIGURACIÓN en el swiper para que el usuario
    // pueda configurar su empresa antes de usar las demás funciones.
    if (!hasCompany) {
      return [
        MenuOptionModel(
            id: '6',
            color: AppTheme.menuConfig,
            route: 'config',
            icon: Icons.settings_applications_outlined,
            text: l10n.homeMenuConfig,
            screen: const Text('Menu'),
            description: l10n.homeMenuConfigDesc),
      ];
    }

    // Con company → todas las opciones excepto CONFIGURACIÓN
    // (config queda en el BottomNavigationBar).
    return [
      MenuOptionModel(
          id: '1',
          color: AppTheme.menuBill,
          route: 'bill',
          icon: Icons.point_of_sale_sharp,
          text: l10n.homeMenuBill,
          screen: const Text('Menu'),
          description: l10n.homeMenuBillDesc),
      MenuOptionModel(
          id: '2',
          color: AppTheme.menuClient,
          route: 'client',
          icon: Icons.person_add_alt_1_outlined,
          text: l10n.homeMenuClient,
          screen: const Text('Menu'),
          description: l10n.homeMenuClientDesc),
      MenuOptionModel(
          id: '3',
          color: AppTheme.menuItem,
          route: 'item',
          icon: Icons.shopping_cart_outlined,
          text: l10n.homeMenuItem,
          screen: const Text('Menu'),
          description: l10n.homeMenuItemDesc),
      MenuOptionModel(
          id: '4',
          color: AppTheme.menuReport,
          route: 'report',
          icon: Icons.file_copy_outlined,
          text: l10n.homeMenuReport,
          screen: const Text('Menu'),
          description: l10n.homeMenuReportDesc),
      MenuOptionModel(
          id: '5',
          color: AppTheme.menuReview,
          route: 'review',
          icon: Icons.send_and_archive,
          text: l10n.homeMenuReview,
          screen: const Text('Menu'),
          description: l10n.homeMenuReviewDesc),
    ];
  }

  //Initial route
  static const initialRoute = 'check';

  ///Function for create routes for menus
  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    return {
      'check': (_) => const CheckOutScreen(),
      'alert': (_) => const AlertScreen(),
      'home': (_) => const HomeScreen(),
      'register': (_) => const RegisterUserScreen(),
      'config': (_) => const ConfigurationWizardScreen(),
      'client': (_) => const ClientScreen(),
      'bill': (_) => const BillScreen(),
      'item': (_) => const ItemScreen(),
      'report': (_) => const ReportScreen(),
      'review': (_) => const ReviewScreen(),
      'login': (_) => const LoginScreen(),
    };
  }
}
