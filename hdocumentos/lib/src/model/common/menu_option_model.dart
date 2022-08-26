import 'dart:ui';

import 'package:flutter/material.dart' show IconData, Widget;

///Model class that containt menu option for render into home
class MenuOptionModel {
  String? id;
  final String route;
  final IconData icon;
  final String text;
  final Widget screen;
  final Color? color;
  final String? description;
  final String? pathImage;

  ///Constructor with required properties
  MenuOptionModel(
      {this.id,
      required this.route,
      required this.icon,
      required this.text,
      required this.screen,
      this.color,
      this.description,
      this.pathImage});
}
