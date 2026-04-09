import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widgets that put title and description application into box corner left
class PageTitleWidget extends StatelessWidget {
  const PageTitleWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  //Create title
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Basado en el lado más corto para que sea coherente en landscape y portrait
    final fontSize = size.shortestSide * 0.052;

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white))
        ]);
  }
}
