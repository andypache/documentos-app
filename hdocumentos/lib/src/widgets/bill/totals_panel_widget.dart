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
    final size = MediaQuery.of(context).size;

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
            margin: EdgeInsets.only(top: size.height * 0.004),
            width: size.width * 0.08,
            height: 2.5,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(size.width * 0.025),
            child: Column(
              children: [
                // Título
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(size.width * 0.015),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryButton.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calculate,
                        color: AppTheme.primaryButton,
                        size: size.width * 0.048,
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Text(
                      'Resumen de Factura',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (isCalculating)
                      SizedBox(
                        width: size.width * 0.04,
                        height: size.width * 0.04,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryButton,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: size.height * 0.006),

                // Container con los totales
                Container(
                  padding: EdgeInsets.all(size.width * 0.02),
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
                        size: size,
                      ),

                      // Descuento del cliente
                      if (customerDiscount > 0) ...[
                        SizedBox(height: size.height * 0.005),
                        _buildTotalRow(
                          customerDiscountLabel ?? 'Descuento Cliente',
                          -customerDiscount,
                          icon: Icons.local_offer,
                          color: Colors.orangeAccent,
                          isDiscount: true,
                          size: size,
                        ),
                      ],

                      // Impuestos
                      if (totalTax > 0) ...[
                        SizedBox(height: size.height * 0.005),
                        _buildTotalRow(
                          'Impuestos',
                          totalTax,
                          icon: Icons.receipt_long,
                          color: Colors.lightBlueAccent,
                          size: size,
                        ),
                      ],

                      // Divider
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
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
                                padding: EdgeInsets.all(size.width * 0.012),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.attach_money,
                                  color: Colors.greenAccent,
                                  size: size.width * 0.048,
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Text(
                                'TOTAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.04,
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
                              style: TextStyle(
                                color: AppTheme.primaryButton,
                                fontSize: size.width * 0.055,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.006),

                // Botón de guardar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: canSave ? onSave : null,
                    icon: Icon(Icons.save, size: size.width * 0.048),
                    label: Text(
                      'Guardar Factura',
                      style: TextStyle(
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canSave
                          ? AppTheme.primaryButton
                          : Colors.grey.shade700,
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: canSave ? 4 : 0,
                    ),
                  ),
                ),

                // Mensaje de validación
                if (!canSave) ...[
                  SizedBox(height: size.height * 0.005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: size.width * 0.036,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      SizedBox(width: size.width * 0.015),
                      Text(
                        'Completa todos los campos requeridos',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: size.width * 0.028,
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
    required Size size,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: size.width * 0.042,
                color: color ?? Colors.white.withOpacity(0.7),
              ),
              SizedBox(width: size.width * 0.02),
            ],
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.white.withOpacity(0.8),
                fontSize: size.width * 0.034,
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
              fontSize: size.width * 0.034,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
