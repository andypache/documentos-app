import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Panel de totales que permanece visible en la parte inferior
/// Muestra subtotal, descuentos, impuestos y total con animaciones
class TotalsPanelWidget extends StatelessWidget {
  final double subtotal;
  final double customerDiscount;
  final double totalTax;
  final double total;
  final bool isCalculating;
  final bool canSave;
  final VoidCallback onSave;
  final String? customerDiscountLabel;

  const TotalsPanelWidget({
    Key? key,
    required this.subtotal,
    required this.customerDiscount,
    required this.totalTax,
    required this.total,
    this.isCalculating = false,
    this.canSave = false,
    required this.onSave,
    this.customerDiscountLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Título
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryButton.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calculate,
                        color: AppTheme.primaryButton,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Resumen de Factura',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (isCalculating)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryButton,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Container con los totales
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryButton.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Subtotal
                      _buildTotalRow(
                        'Subtotal',
                        subtotal,
                        icon: Icons.shopping_cart_outlined,
                      ),

                      // Descuento del cliente
                      if (customerDiscount > 0) ...[
                        const SizedBox(height: 8),
                        _buildTotalRow(
                          customerDiscountLabel ?? 'Descuento Cliente',
                          -customerDiscount,
                          icon: Icons.local_offer,
                          color: Colors.orangeAccent,
                          isDiscount: true,
                        ),
                      ],

                      // Impuestos
                      if (totalTax > 0) ...[
                        const SizedBox(height: 8),
                        _buildTotalRow(
                          'Impuestos',
                          totalTax,
                          icon: Icons.receipt_long,
                          color: Colors.lightBlueAccent,
                        ),
                      ],

                      // Divider
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          color: Colors.white30,
                          height: 1,
                        ),
                      ),

                      // Total (grande y destacado)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.attach_money,
                                  color: Colors.greenAccent,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'TOTAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Text(
                              '\$${total.toStringAsFixed(2)}',
                              key: ValueKey(total),
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Botón de guardar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: canSave ? onSave : null,
                    icon: const Icon(Icons.save, size: 24),
                    label: const Text(
                      'Guardar Factura',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canSave
                          ? AppTheme.primaryButton
                          : Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: canSave ? 4 : 0,
                    ),
                  ),
                ),

                // Mensaje de validación
                if (!canSave) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Completa todos los campos requeridos',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double value, {
    IconData? icon,
    Color? color,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: color ?? Colors.white.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.white.withOpacity(0.8),
                fontSize: 15,
              ),
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Text(
            '${isDiscount ? '-' : ''}\$${value.abs().toStringAsFixed(2)}',
            key: ValueKey('$label-$value'),
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
