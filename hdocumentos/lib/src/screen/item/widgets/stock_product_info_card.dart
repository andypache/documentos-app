import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Tarjeta con información del producto para pantalla de stock
class StockProductInfoCard extends StatelessWidget {
  final ItemModel item;

  const StockProductInfoCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDimens.paddingS),
        border: Border.all(
            color: AppTheme.primaryButton.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.primaryButton.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
              border: Border.all(color: AppTheme.primaryButton, width: 2),
            ),
            child: item.media?.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
                    child: Image.memory(item.media?.image ?? Uint8List(0),
                        fit: BoxFit.cover),
                  )
                : const Icon(Icons.inventory_2,
                    color: AppTheme.primaryButton, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.searchKey != null && item.searchKey!.isNotEmpty)
                  Text(
                    l10n.labelSearchKeyPrefix(item.searchKey!),
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
