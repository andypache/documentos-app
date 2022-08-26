import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

//General widget card for load forms
class CardContainerWidget extends StatelessWidget {
  const CardContainerWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  //Create container card white fonts for load content
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: _createCardShape(),
            child: child));
  }

  //Box decoration
  BoxDecoration _createCardShape() => BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: AppTheme.black, blurRadius: 15, offset: Offset(0, 5))
          ]);
}
