import 'package:flutter/material.dart';

import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/screen/screen.dart';

//Class that containt all router with render widwegs into app
class AppRoutes {
  //Initial route
  static const initialRoute = 'check';
  //Put menus into this array for render app
  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'alert',
        text: 'Alertas - Alerts',
        screen: const Alert(),
        icon: Icons.add_alert_outlined),
    MenuOption(
        route: 'home', text: 'Home', screen: const Home(), icon: Icons.home),
    MenuOption(
        route: 'register',
        text: 'Registro usuario',
        screen: const RegisterUser(),
        icon: Icons.home),
    MenuOption(
        route: 'config',
        text: 'configuración',
        screen: const ConfigurationUserBill(),
        icon: Icons.home),
    MenuOption(
        route: 'client',
        text: 'Clientes',
        screen: const ClientBill(),
        icon: Icons.home),
    MenuOption(
        route: 'bill',
        text: 'Facturas',
        screen: const ManagementBill(),
        icon: Icons.home),
    MenuOption(
        route: 'item',
        text: 'Productos',
        screen: const ManagementItem(),
        icon: Icons.home),
    MenuOption(
        route: 'report',
        text: 'Reportes',
        screen: const ManagementReport(),
        icon: Icons.home),
    MenuOption(
        route: 'review',
        text: 'Revisión documentos',
        screen: const ManagementReview(),
        icon: Icons.home),
    MenuOption(
        route: 'login', text: 'Login', screen: const Login(), icon: Icons.home)
  ];

  ///Function for create routes for menus
  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({'check': (BuildContext context) => const CheckOut()});
    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }
    return appRoutes;
  }
}
