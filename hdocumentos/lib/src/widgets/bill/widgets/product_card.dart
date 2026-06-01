import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/bill_calculation_provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/bill/product_edit_dialog.dart';

/// Tarjeta de producto en la lista de factura
class ProductCard extends StatelessWidget {
  final BillItemModel billItem;
  final int index;
  final Function(int index) onRemove;
  final Function(int index, BillItemModel updatedItem) onUpdate;
  final BillCalculationProvider provider;

  const ProductCard({
    Key? key,
    required this.billItem,
    required this.index,
    required this.onRemove,
    required this.onUpdate,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final item = billItem.item;
    final hasTaxes = item.itemTaxes != null && item.itemTaxes!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductIcon(item),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProductInfo(context, item, hasTaxes),
              ),
              _buildTotalAndActions(context, item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductIcon(ItemModel item) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.primaryButton.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
      ),
      child: Icon(
        item.isService == 'Y' ? Icons.design_services : Icons.inventory_2,
        color: AppTheme.primaryButton,
        size: 28,
      ),
    );
  }

  Widget _buildProductInfo(
      BuildContext context, ItemModel item, bool hasTaxes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppDimens.spaceXS),
        _buildQuantityControl(context),
        const SizedBox(height: 2),
        _buildUnitPrice(context, item),
        _buildDiscounts(context, item),
        if (hasTaxes) ...[
          SizedBox(height: AppDimens.spaceXS),
          _buildTaxesBadges(item),
        ],
      ],
    );
  }

  Widget _buildQuantityControl(BuildContext context) {
    return Row(
      children: [
        Text(
          'Cantidad: ',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 13,
          ),
        ),
        _buildDecrementButton(context),
        const SizedBox(width: 6),
        Text(
          '${billItem.quantity}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 6),
        _buildIncrementButton(context),
      ],
    );
  }

  Widget _buildDecrementButton(BuildContext context) {
    final isDisabled = provider.isCalculating || billItem.quantity <= 1;

    return InkWell(
      onTap: isDisabled
          ? null
          : () => _changeQuantity(context, billItem.quantity - 1),
      borderRadius: BorderRadius.circular(AppDimens.radiusXS),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.withOpacity(0.2)
              : AppTheme.primaryButton.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppDimens.radiusXS),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.withOpacity(0.3)
                : AppTheme.primaryButton,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.remove,
          color: isDisabled
              ? Colors.grey.withOpacity(0.5)
              : AppTheme.primaryButton,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildIncrementButton(BuildContext context) {
    final isDisabled = provider.isCalculating;

    return InkWell(
      onTap: isDisabled
          ? null
          : () => _changeQuantity(context, billItem.quantity + 1),
      borderRadius: BorderRadius.circular(AppDimens.radiusXS),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.withOpacity(0.2)
              : AppTheme.primaryButton.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppDimens.radiusXS),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.withOpacity(0.3)
                : AppTheme.primaryButton,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          color: isDisabled
              ? Colors.grey.withOpacity(0.5)
              : AppTheme.primaryButton,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildUnitPrice(BuildContext context, ItemModel item) {
    final itemCalc = provider.getItemCalculation(item.id ?? '');
    final unitPrice = itemCalc?.priceSale ?? billItem.unitPrice;

    return Text(
      'Precio unit.: \$${unitPrice.toStringAsFixed(2)}',
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 13,
      ),
    );
  }

  Widget _buildDiscounts(BuildContext context, ItemModel item) {
    final itemCalc = provider.getItemCalculation(item.id ?? '');

    if (itemCalc != null) {
      final hasProductDiscount = itemCalc.discountProductValue > 0;
      final hasCustomerDiscount = itemCalc.discountCustomerValue > 0;

      if (hasProductDiscount || hasCustomerDiscount) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasProductDiscount) ...[
              const SizedBox(height: 2),
              Text(
                'Desc. producto: \$${itemCalc.discountProductValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 13,
                ),
              ),
            ],
            if (hasCustomerDiscount) ...[
              const SizedBox(height: 2),
              Text(
                'Desc. cliente: \$${itemCalc.discountCustomerValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        );
      }
    } else if (billItem.discount > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            'Descuento: \$${billItem.discount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.orangeAccent,
              fontSize: 13,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTaxesBadges(ItemModel item) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: item.itemTaxes!.map((tax) {
        return Container(
          key: ValueKey('tax_badge_${tax.id}'),
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppDimens.radiusXS),
            border: Border.all(color: Colors.blue, width: 1),
          ),
          child: Text(
            '${tax.name} ${tax.percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTotalAndActions(BuildContext context, ItemModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildTotal(context, item),
        SizedBox(height: AppDimens.spaceS),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEditButton(context),
            const SizedBox(width: 8),
            _buildDeleteButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildTotal(BuildContext context, ItemModel item) {
    final itemCalc = provider.getItemCalculation(item.id ?? '');
    final total = itemCalc?.total ?? (billItem.unitPrice * billItem.quantity);

    return Text(
      '\$${total.toStringAsFixed(2)}',
      style: const TextStyle(
        color: Colors.greenAccent,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    final isDisabled = provider.isCalculating;

    return InkWell(
      onTap: isDisabled ? null : () => _editProduct(context),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.blue.withOpacity(0.1)
              : Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          Icons.edit,
          color: isDisabled
              ? Colors.blueAccent.withOpacity(0.3)
              : Colors.blueAccent,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    final isDisabled = provider.isCalculating;

    return InkWell(
      onTap: isDisabled ? null : () => _confirmRemove(context),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.red.withOpacity(0.1)
              : Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          Icons.delete_outline,
          color:
              isDisabled ? Colors.redAccent.withOpacity(0.3) : Colors.redAccent,
          size: 18,
        ),
      ),
    );
  }

  void _changeQuantity(BuildContext context, int newQuantity) {
    if (newQuantity < 1) return;

    final updatedItem = BillItemModel(
      item: billItem.item,
      quantity: newQuantity,
      unitPrice: billItem.unitPrice,
      discount: billItem.discount,
    );

    onUpdate(index, updatedItem);
  }

  Future<void> _editProduct(BuildContext context) async {
    final result = await showDialog<BillItemModel>(
      context: context,
      builder: (context) => ProductEditDialog(billItem: billItem),
    );

    if (result != null) {
      onUpdate(index, result);
    }
  }

  Future<void> _confirmRemove(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.primary,
        title: const Text(
          'Eliminar Producto',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de eliminar este producto de la factura?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onRemove(index);
    }
  }
}
