import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Widget para seleccionar el método de pago
class PaymentMethodWidget extends StatelessWidget {
  final List<PaymentMethodModel> paymentMethods;
  final PaymentMethodModel? selectedMethod;
  final Function(PaymentMethodModel?) onMethodSelected;
  final bool isLoading;

  const PaymentMethodWidget({
    Key? key,
    required this.paymentMethods,
    required this.selectedMethod,
    required this.onMethodSelected,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              selectedMethod != null ? AppTheme.primaryButton : Colors.white30,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryButton.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.payment,
                    color: AppTheme.primaryButton,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Método de Pago',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dropdown o Loading
            if (isLoading)
              _buildLoadingState()
            else if (paymentMethods.isEmpty)
              _buildEmptyState()
            else
              _buildDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryButton,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No hay métodos de pago disponibles',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.primaryButton.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PaymentMethodModel>(
          isExpanded: true,
          value: selectedMethod,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.credit_card,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Selecciona un método de pago',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.white.withOpacity(0.7),
              size: 28,
            ),
          ),
          dropdownColor: AppTheme.secondary,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          borderRadius: BorderRadius.circular(10),
          items: paymentMethods.map((method) {
            return DropdownMenuItem<PaymentMethodModel>(
              value: method,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      _getPaymentIcon(method.name),
                      color: AppTheme.primaryButton,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        method.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: onMethodSelected,
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String methodName) {
    final nameLower = methodName.toLowerCase();

    if (nameLower.contains('efectivo') || nameLower.contains('cash')) {
      return Icons.money;
    } else if (nameLower.contains('tarjeta') ||
        nameLower.contains('crédito') ||
        nameLower.contains('débito') ||
        nameLower.contains('card')) {
      return Icons.credit_card;
    } else if (nameLower.contains('transferencia') ||
        nameLower.contains('transfer')) {
      return Icons.account_balance;
    } else if (nameLower.contains('cheque') || nameLower.contains('check')) {
      return Icons.receipt_long;
    } else if (nameLower.contains('digital') ||
        nameLower.contains('online') ||
        nameLower.contains('paypal') ||
        nameLower.contains('zelle')) {
      return Icons.phone_android;
    } else {
      return Icons.payment;
    }
  }
}
