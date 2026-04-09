import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Diálogo para editar cantidad, precio y descuento de un producto
class ProductEditDialog extends StatefulWidget {
  final BillItemModel billItem;

  const ProductEditDialog({Key? key, required this.billItem}) : super(key: key);

  @override
  State<ProductEditDialog> createState() => _ProductEditDialogState();
}

class _ProductEditDialogState extends State<ProductEditDialog> {
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;

  int _quantity = 1;
  double _unitPrice = 0.0;
  double _discount = 0.0;

  @override
  void initState() {
    super.initState();
    _quantity = widget.billItem.quantity;
    _unitPrice = widget.billItem.unitPrice;
    _discount = widget.billItem.discount;

    _quantityController = TextEditingController(text: _quantity.toString());
    _priceController =
        TextEditingController(text: _unitPrice.toStringAsFixed(2));
    _discountController =
        TextEditingController(text: _discount.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _updateQuantity(String value) {
    setState(() {
      _quantity = int.tryParse(value) ?? 1;
      if (_quantity < 1) _quantity = 1;
    });
  }

  void _updatePrice(String value) {
    setState(() {
      _unitPrice = double.tryParse(value) ?? 0.0;
      if (_unitPrice < 0) _unitPrice = 0.0;
    });
  }

  void _updateDiscount(String value) {
    setState(() {
      _discount = double.tryParse(value) ?? 0.0;
      if (_discount < 0) _discount = 0.0;
    });
  }

  double _calculateSubtotal() {
    return (_unitPrice * _quantity) - _discount;
  }

  double _calculateTotalTax() {
    final subtotal = _calculateSubtotal();
    double totalTax = 0.0;
    if (widget.billItem.item.itemTaxList != null) {
      for (var tax in widget.billItem.item.itemTaxList!) {
        totalTax += subtotal * (tax.percentage / 100);
      }
    }
    return totalTax;
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateTotalTax();
  }

  void _save() {
    final updatedItem = widget.billItem.copyWith(
      quantity: _quantity,
      unitPrice: _unitPrice,
      discount: _discount,
    );
    Navigator.pop(context, updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.billItem.item;
    final hasTaxes = item.itemTaxList != null && item.itemTaxList!.isNotEmpty;

    return Dialog(
      backgroundColor: AppTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Builder(builder: (ctx) {
                        return Text(
                          AppLocalizations.of(ctx).labelEditProduct,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Campo de cantidad
                    Builder(builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx);
                      return _buildTextField(
                        label: l10n.labelQuantity,
                        controller: _quantityController,
                        icon: Icons.inventory_2,
                        keyboardType: TextInputType.number,
                        onChanged: _updateQuantity,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      );
                    }),
                    const SizedBox(height: 16),

                    // Campo de precio unitario
                    Builder(builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx);
                      return _buildTextField(
                        label: l10n.labelUnitPrice,
                        controller: _priceController,
                        icon: Icons.attach_money,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: _updatePrice,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),

                    // Campo de descuento
                    Builder(builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx);
                      return _buildTextField(
                        label: l10n.labelDiscount,
                        controller: _discountController,
                        icon: Icons.local_offer,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: _updateDiscount,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      );
                    }),

                    if (hasTaxes) ...[
                      const SizedBox(height: 20),
                      Builder(builder: (ctx) {
                        final l10n = AppLocalizations.of(ctx);
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.receipt_long,
                                    color: Colors.lightBlueAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.labelTaxes,
                                    style: const TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...item.itemTaxList!.map((tax) {
                                final taxAmount = _calculateSubtotal() *
                                    (tax.percentage / 100);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${tax.name} (${tax.percentage.toStringAsFixed(0)}%)',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        '\$${taxAmount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }),
                    ],
                    // Resumen de cálculos
                    const SizedBox(height: 20),
                    Builder(builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx);
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.secondary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryButton.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow(
                              l10n.labelSubtotal,
                              '\$${_calculateSubtotal().toStringAsFixed(2)}',
                            ),
                            if (_discount > 0) ...[
                              const SizedBox(height: 8),
                              _buildSummaryRow(
                                l10n.labelDiscountApplied,
                                '-\$${_discount.toStringAsFixed(2)}',
                                color: Colors.orangeAccent,
                              ),
                            ],
                            if (hasTaxes) ...[
                              const SizedBox(height: 8),
                              _buildSummaryRow(
                                l10n.labelTotalTaxes,
                                '\$${_calculateTotalTax().toStringAsFixed(2)}',
                                color: Colors.lightBlueAccent,
                              ),
                            ],
                            const SizedBox(height: 12),
                            const Divider(color: Colors.white30, height: 1),
                            const SizedBox(height: 12),
                            _buildSummaryRow(
                              l10n.labelTotal,
                              '\$${_calculateTotal().toStringAsFixed(2)}',
                              isBold: true,
                              color: AppTheme.primaryButton,
                              fontSize: 18,
                            ),
                          ],
                        ),
                      );
                    }),

                    // Botones de acción
                    const SizedBox(height: 24),
                    Builder(builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx);
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                foregroundColor: AppTheme.textSecondary,
                                side: const BorderSide(
                                    color: AppTheme.dialogBorder),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(l10n.btnCancel),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _save,
                              icon: const Icon(Icons.save_rounded, size: 18),
                              label: Text(l10n.btnSave),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.actionSave,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required TextInputType keyboardType,
    required Function(String) onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.primaryButton.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.primaryButton),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
    double? fontSize,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color ?? Colors.white.withOpacity(0.8),
            fontSize: fontSize ?? 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: fontSize ?? 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
