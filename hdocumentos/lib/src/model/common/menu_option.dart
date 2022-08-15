import 'package:flutter/material.dart' show IconData, Widget;

///Model class that containt menu option for render into home
class MenuOption {
  final String route;
  final IconData icon;
  final String text;
  final Widget screen;

  ///Constructor with required properties
  MenuOption(
      {required this.route,
      required this.icon,
      required this.text,
      required this.screen});
}
