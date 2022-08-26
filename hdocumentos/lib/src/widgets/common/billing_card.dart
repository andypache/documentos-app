import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widgets shoping card
class BillingCard extends StatelessWidget {
  const BillingCard({
    Key? key,
  }) : super(key: key);

  //Build button
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        onPressed: () {},
        fillColor: AppTheme.targetGradient,
        shape: const CircleBorder(),
        elevation: 4.0,
        child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.shopping_cart, color: Colors.white70, size: 14)));
  }
}
