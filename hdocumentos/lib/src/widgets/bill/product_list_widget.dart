import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/bill/product_edit_dialog.dart';

/// Widget que muestra la lista de productos agregados a la factura
class ProductListWidget extends StatelessWidget {
  final List<BillItemModel> billItems;
  final Function(int index) onRemoveItem;
  final Function(int index, BillItemModel updatedItem) onUpdateItem;
  final VoidCallback onAddProduct;

  const ProductListWidget({
    Key? key,
    required this.billItems,
    required this.onRemoveItem,
    required this.onUpdateItem,
    required this.onAddProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: billItems.isNotEmpty ? AppTheme.primaryButton : Colors.white30,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Productos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onAddProduct,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryButton,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de productos o estado vacío
          if (billItems.isEmpty)
            _buildEmptyState()
          else
            _buildProductList(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay productos agregados',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toca "Agregar" para buscar productos',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
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
        return _buildProductCard(context, billItem, index);
      },
    );
  }

  Widget _buildProductCard(
      BuildContext context, BillItemModel billItem, int index) {
    final item = billItem.item;
    final hasTaxes = item.itemTaxList != null && item.itemTaxList!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono del producto
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryButton.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.isService == 'Y'
                      ? Icons.design_services
                      : Icons.inventory_2,
                  color: AppTheme.primaryButton,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),

              // Información del producto
              Expanded(
                child: Column(
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
                    const SizedBox(height: 4),
                    Text(
                      'Cantidad: ${billItem.quantity}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Precio unit.: \$${billItem.unitPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                    if (billItem.discount > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Descuento: \$${billItem.discount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (hasTaxes) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: item.itemTaxList!.map((tax) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
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
                      ),
                    ],
                  ],
                ),
              ),

              // Total y acciones
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${billItem.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón editar
                      InkWell(
                        onTap: () => _editProduct(context, billItem, index),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Botón eliminar
                      InkWell(
                        onTap: () => _confirmRemove(context, index),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editProduct(
      BuildContext context, BillItemModel billItem, int index) async {
    final result = await showDialog<BillItemModel>(
      context: context,
      builder: (context) => ProductEditDialog(billItem: billItem),
    );

    if (result != null) {
      onUpdateItem(index, result);
    }
  }

  Future<void> _confirmRemove(BuildContext context, int index) async {
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
      onRemoveItem(index);
    }
  }
}
