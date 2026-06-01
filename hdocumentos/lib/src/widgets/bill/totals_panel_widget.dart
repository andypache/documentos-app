import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/share/app_logger.dart';

/// Panel de totales que permanece visible en la parte inferior
/// Muestra subtotal, descuentos, impuestos y total con animaciones
class TotalsPanelWidget extends StatelessWidget {
  final double subtotal;
  final double customerDiscount;
  final double itemDiscount;
  final double discountTotal;
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
    this.itemDiscount = 0.0,
    this.discountTotal = 0.0,
    required this.totalTax,
    required this.total,
    this.isCalculating = false,
    this.canSave = false,
    required this.onSave,
    this.customerDiscountLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLogger.debug(
      'Panel rebuilding - Subtotal: \$$subtotal, Total: \$$total',
      tag: 'TotalsPanelWidget',
    );

    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: isLandscape
            ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: isLandscape ? const Offset(-3, 0) : const Offset(0, -3),
          ),
        ],
      ),
      child: isLandscape
          ? SingleChildScrollView(
              child: _buildContent(context, size, l10n, isLandscape: true),
            )
          : _buildContent(context, size, l10n, isLandscape: false),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Size size,
    AppLocalizations l10n, {
    required bool isLandscape,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle indicator
        Container(
          margin: EdgeInsets.only(top: isLandscape ? 8 : size.height * 0.004),
          width: isLandscape ? 4 : size.width * 0.08,
          height: isLandscape ? 40 : 2.5,
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Content
        Padding(
          padding: EdgeInsets.all(isLandscape ? 10 : size.width * 0.025),
          child: Column(
            children: [
              // Título
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.all(isLandscape ? 6 : size.width * 0.015),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryButton.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimens.radiusS),
                    ),
                    child: Icon(
                      Icons.calculate,
                      color: AppTheme.primaryButton,
                      size: isLandscape ? 18 : size.width * 0.048,
                    ),
                  ),
                  SizedBox(width: isLandscape ? 8 : size.width * 0.02),
                  Text(
                    l10n.billSummaryTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isLandscape ? 13 : size.width * 0.036,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (isCalculating)
                    SizedBox(
                      width: isLandscape ? 14 : size.width * 0.04,
                      height: isLandscape ? 14 : size.width * 0.04,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryButton,
                      ),
                    ),
                ],
              ),
              SizedBox(height: isLandscape ? 6 : size.height * 0.006),

              // Container con los totales
              Container(
                padding: EdgeInsets.all(isLandscape ? 8 : size.width * 0.02),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  border: Border.all(
                    color: AppTheme.primaryButton.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Subtotal
                    _buildTotalRow(
                      l10n.labelSubtotal,
                      subtotal,
                      icon: Icons.shopping_cart_outlined,
                      size: size,
                      isLandscape: isLandscape,
                    ),

                    // Descuento de items/productos
                    if (itemDiscount > 0) ...[
                      SizedBox(height: isLandscape ? 4 : size.height * 0.005),
                      _buildTotalRow(
                        l10n.labelDiscountItems,
                        -itemDiscount,
                        icon: Icons.discount,
                        color: Colors.amber,
                        isDiscount: true,
                        size: size,
                        isLandscape: isLandscape,
                      ),
                    ],

                    // Descuento del cliente
                    if (customerDiscount > 0) ...[
                      SizedBox(height: isLandscape ? 4 : size.height * 0.005),
                      _buildTotalRow(
                        customerDiscountLabel ?? l10n.labelDiscount,
                        -customerDiscount,
                        icon: Icons.local_offer,
                        color: Colors.orangeAccent,
                        isDiscount: true,
                        size: size,
                        isLandscape: isLandscape,
                      ),
                    ],

                    // Descuento total (suma de todos los descuentos)
                    if (discountTotal > 0) ...[
                      SizedBox(height: isLandscape ? 4 : size.height * 0.005),
                      _buildTotalRow(
                        'Total descuentos',
                        -discountTotal,
                        icon: Icons.local_offer_outlined,
                        color: Colors.deepOrangeAccent,
                        isDiscount: true,
                        size: size,
                        isLandscape: isLandscape,
                      ),
                    ],

                    // Impuestos
                    if (totalTax > 0) ...[
                      SizedBox(height: isLandscape ? 4 : size.height * 0.005),
                      _buildTotalRow(
                        l10n.labelTaxes,
                        totalTax,
                        icon: Icons.receipt_long,
                        color: Colors.lightBlueAccent,
                        size: size,
                        isLandscape: isLandscape,
                      ),
                    ],

                    // Divider
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: isLandscape ? 6 : size.height * 0.01),
                      child: const Divider(
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
                              padding: EdgeInsets.all(
                                  isLandscape ? 4 : size.width * 0.012),
                              decoration: BoxDecoration(
                                color: AppTheme.actionSave.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.attach_money,
                                color: AppTheme.actionSave,
                                size: isLandscape ? 16 : size.width * 0.048,
                              ),
                            ),
                            SizedBox(
                                width: isLandscape ? 6 : size.width * 0.02),
                            Text(
                              l10n.labelTotal,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isLandscape ? 13 : size.width * 0.04,
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
                              fontSize: isLandscape ? 16 : size.width * 0.055,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: isLandscape ? 6 : size.height * 0.006),

              // Botón de guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: canSave ? onSave : null,
                  icon: Icon(Icons.save_rounded,
                      size: isLandscape ? 16 : size.width * 0.048),
                  label: Text(
                    l10n.btnSaveInvoice,
                    style: TextStyle(
                      fontSize: isLandscape ? 12 : size.width * 0.036,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        canSave ? AppTheme.actionSave : Colors.grey.shade700,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        vertical: isLandscape ? 10 : size.height * 0.01),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusM),
                    ),
                    elevation: canSave ? 4 : 0,
                  ),
                ),
              ),

              // Mensaje de validación
              if (!canSave) ...[
                SizedBox(height: isLandscape ? 4 : size.height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: isLandscape ? 12 : size.width * 0.036,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(width: isLandscape ? 4 : size.width * 0.015),
                    Flexible(
                      child: Text(
                        l10n.billRequiredFieldsHint,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: isLandscape ? 10 : size.width * 0.028,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(
    String label,
    double value, {
    IconData? icon,
    Color? color,
    bool isDiscount = false,
    required Size size,
    bool isLandscape = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: isLandscape ? 14 : size.width * 0.042,
                color: color ?? Colors.white.withOpacity(0.7),
              ),
              SizedBox(width: isLandscape ? 6 : size.width * 0.02),
            ],
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.white.withOpacity(0.8),
                fontSize: isLandscape ? 11 : size.width * 0.034,
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
              fontSize: isLandscape ? 11 : size.width * 0.034,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
