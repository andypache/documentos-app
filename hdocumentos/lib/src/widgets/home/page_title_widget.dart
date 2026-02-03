import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widgets that put title and descriptión application into box
///corner left
class PageTitleWidget extends StatelessWidget {
  const PageTitleWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  //Create title
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white))
        ]);
  }
}
