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
  //Put menus into this array for render app
  static final menuOptions = <MenuOptionModel>[
    MenuOptionModel(
        route: 'alert',
        text: 'Alertas - Alerts',
        screen: const AlertScreen(),
        icon: Icons.add_alert_outlined),
    MenuOptionModel(
        route: 'home',
        text: 'Home',
        screen: const HomeScreen(),
        icon: Icons.home),
    MenuOptionModel(
        route: 'register',
        text: 'Registro usuario',
        screen: const RegisterUserScreen(),
        icon: Icons.home),
    MenuOptionModel(
        route: 'config',
        text: 'configuración',
        screen: const ConfigurationScreen(),
        icon: Icons.home),
    MenuOptionModel(
        route: 'client',
        text: 'Clientes',
        screen: const ClientScreen(),
        icon: Icons.home),
    MenuOptionModel(
        route: 'bill',
        text: 'Facturas',
        screen: const BillScreen(),
        icon: Icons.home),
    MenuOptionModel(
        route: 'item',
        text: 'Productos',
        screen: const ItemScreen(),
        icon: Icons.home),
    MenuOptionModel(
        route: 'report',
        text: 'Reportes',
        screen: const ReportScreen(),
        icon: Icons.home),
    MenuOptionModel(
        route: 'review',
        text: 'Revisión documentos',
        screen: const ReviewScreen(),
        icon: Icons.home),
    MenuOptionModel(
        route: 'login',
        text: 'Login',
        screen: const LoginScreen(),
        icon: Icons.home)
  ];

  ///Function for create routes for menus
  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes
        .addAll({'check': (BuildContext context) => const CheckOutScreen()});
    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }
    return appRoutes;
  }
}
