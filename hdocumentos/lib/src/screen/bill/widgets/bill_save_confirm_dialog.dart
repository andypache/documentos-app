import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';

/// Diálogo de confirmación para guardar factura
class BillSaveConfirmDialog extends StatelessWidget {
  final String customerName;
  final int itemCount;
  final double total;

  const BillSaveConfirmDialog({
    Key? key,
    required this.customerName,
    required this.itemCount,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      backgroundColor: AppTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      title: Text(
        l10n.billConfirmTitle,
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.billConfirmCustomer(customerName),
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: AppDimens.spaceS),
          Text(
            l10n.billConfirmProducts(itemCount),
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: AppDimens.spaceS),
          Text(
            l10n.billConfirmTotal(total.toStringAsFixed(2)),
            style: const TextStyle(
              color: AppTheme.primaryButton,
              fontSize: AppDimens.fontSubtitle,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.textSecondary,
            side: const BorderSide(color: AppTheme.dialogBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(l10n.btnCancel),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.save_rounded, size: AppDimens.fontSubtitle),
          label: Text(l10n.btnSave),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.actionSave,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingL,
              vertical: AppDimens.spaceM,
            ),
          ),
        ),
      ],
    );
  }
}
