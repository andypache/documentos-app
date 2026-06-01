import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';

/// Header mostrando el conteo de items encontrados
class ItemsCountHeader extends StatelessWidget {
  final int itemCount;

  const ItemsCountHeader({
    Key? key,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Text(
        AppLocalizations.of(context).itemsFound(itemCount),
        style: TextStyle(
          color: Colors.white70,
          fontSize: (size.width * 0.032).clamp(11.0, 14.0),
        ),
      ),
    );
  }
}
