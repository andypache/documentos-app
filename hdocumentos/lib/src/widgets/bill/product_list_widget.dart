import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/bill_calculation_provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/bill/widgets/widgets.dart';

/// Widget que muestra la lista de productos agregados a la factura
class ProductListWidget extends StatelessWidget {
  final List<BillItemModel> billItems;
  final Function(int index) onRemoveItem;
  final Function(int index, BillItemModel updatedItem) onUpdateItem;
  final VoidCallback? onAddProduct;
  final BillCalculationProvider provider;

  const ProductListWidget({
    Key? key,
    required this.billItems,
    required this.onRemoveItem,
    required this.onUpdateItem,
    required this.onAddProduct,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(
          color: billItems.isNotEmpty ? AppTheme.primaryButton : Colors.white30,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductListHeader(
            billItems: billItems,
            onAddProduct: onAddProduct,
            provider: provider,
          ),
          if (billItems.isEmpty)
            const ProductEmptyState()
          else
            _buildProductList(),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: billItems.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.white.withOpacity(0.1),
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (context, index) {
        final billItem = billItems[index];
        return ProductCard(
          key: ValueKey('product_${billItem.item.id}'),
          billItem: billItem,
          index: index,
          onRemove: onRemoveItem,
          onUpdate: onUpdateItem,
          provider: provider,
        );
      },
    );
  }
}
