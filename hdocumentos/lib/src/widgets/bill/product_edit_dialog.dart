import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Diálogo para editar solo la cantidad de un producto
/// Los campos de precio y descuento son de solo lectura
/// Los cálculos se realizan automáticamente por el backend
class ProductEditDialog extends StatefulWidget {
  final BillItemModel billItem;

  const ProductEditDialog({Key? key, required this.billItem}) : super(key: key);

  @override
  State<ProductEditDialog> createState() => _ProductEditDialogState();
}

class _ProductEditDialogState extends State<ProductEditDialog> {
  late TextEditingController _quantityController;

  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _quantity = widget.billItem.quantity;
    _quantityController = TextEditingController(text: _quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateQuantity(String value) {
    setState(() {
      _quantity = int.tryParse(value) ?? 1;
      if (_quantity < 1) _quantity = 1;
    });
  }

  void _save() {
    final updatedItem = widget.billItem.copyWith(
      quantity: _quantity,
    );
    Navigator.pop(context, updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.billItem.item;
    final hasTaxes = item.itemTaxes != null && item.itemTaxes!.isNotEmpty;

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

                    // Campo de cantidad (SOLO EDITABLE)
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

                    // Campo de precio unitario (BLOQUEADO - SOLO LECTURA)
                    Builder(builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx);
                      return _buildTextField(
                        label: l10n.labelUnitPrice,
                        controller: TextEditingController(
                          text: widget.billItem.unitPrice.toStringAsFixed(2),
                        ),
                        icon: Icons.attach_money,
                        enabled: false,
                      );
                    }),
                    const SizedBox(height: 16),

                    // Campo de descuento (BLOQUEADO - SOLO LECTURA)
                    Builder(builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx);
                      return _buildTextField(
                        label: l10n.labelDiscount,
                        controller: TextEditingController(
                          text: widget.billItem.discount.toStringAsFixed(2),
                        ),
                        icon: Icons.local_offer,
                        enabled: false,
                      );
                    }),

                    // Mostrar impuestos solo como información
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
                              ...item.itemTaxes!.map((tax) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${tax.name} (${tax.percentage.toStringAsFixed(0)}%)',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }),
                    ],

                    // Nota informativa
                    const SizedBox(height: 20),
                    Builder(builder: (ctx) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.amberAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Los cálculos de precios, descuentos y totales se realizarán automáticamente por el sistema.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
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
    TextInputType? keyboardType,
    Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
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
            color: enabled
                ? AppTheme.white.withOpacity(0.1)
                : AppTheme.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: enabled
                  ? AppTheme.primaryButton.withOpacity(0.5)
                  : Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: TextStyle(
              color: enabled ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: enabled
                    ? AppTheme.primaryButton
                    : AppTheme.primaryButton.withOpacity(0.3),
              ),
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
