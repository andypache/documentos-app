import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';

/// Panel informativo sobre precios sin impuestos ni descuentos
class PriceInfoPanel extends StatelessWidget {
  const PriceInfoPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(color: Colors.blue.withOpacity(0.4), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: Colors.blue.shade300, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(l10n.infoPriceWithoutDiscountOrTax,
                style: TextStyle(
                    color: Colors.blue.shade200, fontSize: 12, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
