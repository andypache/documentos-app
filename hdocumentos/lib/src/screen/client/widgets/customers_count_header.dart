import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';

/// Header mostrando el conteo de clientes encontrados
class CustomersCountHeader extends StatelessWidget {
  final int customerCount;
  final bool isLandscape;

  const CustomersCountHeader({
    Key? key,
    required this.customerCount,
    this.isLandscape = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hPad = isLandscape ? 16.0 : size.width * 0.05;

    if (isLandscape) {
      return Padding(
        padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 6),
        child: Text(
          AppLocalizations.of(context).customersFound(customerCount),
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDimens.spaceS),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Text(
            AppLocalizations.of(context).customersFound(customerCount),
            style: TextStyle(
              color: Colors.white70,
              fontSize: size.width * 0.032,
            ),
          ),
        ),
        SizedBox(height: AppDimens.spaceS),
      ],
    );
  }
}
