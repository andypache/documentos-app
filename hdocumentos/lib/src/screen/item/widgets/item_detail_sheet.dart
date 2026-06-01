import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';

/// Bottom sheet con detalles completos del item
class ItemDetailSheet extends StatelessWidget {
  final ItemModel item;

  const ItemDetailSheet({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(AppDimens.borderThin),
              ),
            ),
          ),
          SizedBox(height: AppDimens.spaceL),
          Text(
            item.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: (size.width * 0.052).clamp(16.0, 22.0),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          _DetailRow(
            icon: Icons.label_rounded,
            label: AppLocalizations.of(context).labelSearchKey,
            value: item.searchKey ?? 'N/A',
          ),
          _DetailRow(
            icon: Icons.description_rounded,
            label: AppLocalizations.of(context).labelDescription,
            value:
                item.description ?? AppLocalizations.of(context).noDescription,
          ),
          _DetailRow(
            icon: Icons.attach_money_rounded,
            label: AppLocalizations.of(context).labelPrice,
            value: '\$${item.pricing?.price?.toStringAsFixed(2) ?? "0.00"}',
          ),
          _DetailRow(
            icon: Icons.money_off_rounded,
            label: AppLocalizations.of(context).labelCost,
            value: '\$${item.pricing?.cost?.toStringAsFixed(2) ?? "0.00"}',
          ),
          if (item.isService == 'N')
            _DetailRow(
              icon: Icons.inventory_rounded,
              label: AppLocalizations.of(context).labelStock,
              value: AppLocalizations.of(context)
                  .labelStockUnits(item.stock?.stock ?? 0),
            ),
          if (item.barCode != null && item.barCode!.isNotEmpty)
            _DetailRow(
              icon: Icons.qr_code_rounded,
              label: AppLocalizations.of(context).labelBarCode,
              value: item.barCode!,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Fila de detalle con icono, label y valor
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon,
              color: AppTheme.primaryButton,
              size: (size.width * 0.048).clamp(18.0, 24.0)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: (size.width * 0.03).clamp(11.0, 14.0),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (size.width * 0.038).clamp(13.0, 17.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
