import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/bill_calculation_provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Header de la lista de productos con botón de agregar
class ProductListHeader extends StatelessWidget {
  final List<BillItemModel> billItems;
  final VoidCallback? onAddProduct;
  final BillCalculationProvider provider;

  const ProductListHeader({
    Key? key,
    required this.billItems,
    required this.onAddProduct,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context).labelProducts,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isCalculating = provider.isCalculating;

    return ElevatedButton.icon(
      onPressed: isCalculating ? null : onAddProduct,
      icon: isCalculating
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.add, size: 18),
      label: Text(isCalculating ? 'Calculando...' : l10n.btnAdd),
      style: ElevatedButton.styleFrom(
        backgroundColor: isCalculating
            ? AppTheme.primaryButton.withOpacity(0.5)
            : AppTheme.primaryButton,
        foregroundColor: AppTheme.secondary,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
        ),
      ),
    );
  }
}
