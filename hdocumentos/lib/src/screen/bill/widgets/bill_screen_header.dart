import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

/// Header de la pantalla de facturación con título y botón cerrar
class BillScreenHeader extends StatelessWidget {
  final VoidCallback onClose;

  const BillScreenHeader({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: 0,
        left: size.width * 0.05,
        right: size.width * 0.05,
        bottom: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageTitleWidget(title: l10n.billTitle),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: size.width * 0.07,
            ),
            onPressed: onClose,
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }
}
