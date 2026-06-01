import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/screen/item/widgets/price_info_box.dart';

/// Fila con precios actuales (precio y costo)
class CurrentPricesRow extends StatelessWidget {
  final ItemModel item;

  const CurrentPricesRow({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: PriceInfoBox(
            label: l10n.labelCurrentPrice,
            value: '\$${(item.pricing?.price ?? 0).toStringAsFixed(2)}',
            icon: Icons.attach_money_rounded,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PriceInfoBox(
            label: l10n.labelCurrentCost,
            value: '\$${(item.pricing?.cost ?? 0).toStringAsFixed(2)}',
            icon: Icons.money_off_rounded,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}
