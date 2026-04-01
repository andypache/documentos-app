import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/screen/screen.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

//Class that containt all router with render widwegs into app
class AppRoutes {
  static List<MenuOptionModel> homeMenus = [
    MenuOptionModel(
        id: "1",
        color: Colors.orange,
        route: "bill",
        icon: Icons.point_of_sale_sharp,
        text: 'FACTURAR',
        screen: const Text('Menu'),
        description: 'Genere sus facturas para un bien o servicio'),
    MenuOptionModel(
        id: "2",
        color: Colors.green,
        route: "client",
        icon: Icons.person_add_alt_1_outlined,
        text: 'CLIENTES',
        screen: const Text('Menu'),
        description: 'Gestione sus clientes, cree, edite o elimine'),
    MenuOptionModel(
        id: "3",
        color: Colors.amber,
        route: "item",
        icon: Icons.shopping_cart_outlined,
        text: 'PRODUCTOS',
        screen: const Text('Menu'),
        description: 'Gestione sus productos, cree, edite o elimine'),
    MenuOptionModel(
        id: "4",
        color: AppTheme.blue,
        route: "report",
        icon: Icons.file_copy_outlined,
        text: 'REPORTES',
        screen: const Text('Menu'),
        description: 'Genere sus facturas en pdf'),
    MenuOptionModel(
        id: "5",
        color: AppTheme.pinkAccent,
        route: "review",
        icon: Icons.send_and_archive,
        text: 'REVISIÓN',
        screen: const Text('Menu'),
        description: 'Verifique sus facturas en el SRI'),
    MenuOptionModel(
        id: "6",
        color: AppTheme.secondaryButton,
        route: "config",
        icon: Icons.settings_applications_outlined,
        text: 'CONFIGURACIÓN',
        screen: const Text('Menu'),
        description:
            'Configure su empresa, cambie su imagen y firma electrónica')
  ];

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
