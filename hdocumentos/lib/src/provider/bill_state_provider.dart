import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/bill_customer_provider.dart';
import 'package:hdocumentos/src/provider/bill_items_provider.dart';
import 'package:hdocumentos/src/provider/bill_payment_provider.dart';
import 'package:hdocumentos/src/provider/bill_calculation_provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/exception/error_handler.dart';

/// Provider para estados globales y operaciones de la factura
/// Responsabilidades:
/// - Mantener estados UI (isLoading, isSaving)
/// - Coordinar guardado de factura
/// - Limpiar formulario
/// - Validar estado general (canSave)
class BillStateProvider extends ChangeNotifier {
  // Referencias a otros providers
  final BillCustomerProvider _customerProvider;
  final BillItemsProvider _itemsProvider;
  final BillPaymentProvider _paymentProvider;
  final BillCalculationProvider _calculationProvider;

  // Estados
  bool _isLoading = false;
  bool _isSaving = false;

  // Constructor
  BillStateProvider({
    required BillCustomerProvider customerProvider,
    required BillItemsProvider itemsProvider,
    required BillPaymentProvider paymentProvider,
    required BillCalculationProvider calculationProvider,
  })  : _customerProvider = customerProvider,
        _itemsProvider = itemsProvider,
        _paymentProvider = paymentProvider,
        _calculationProvider = calculationProvider;

  // Getters - Estados
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get canSave =>
      _customerProvider.hasCustomer &&
      _itemsProvider.hasItems &&
      _paymentProvider.hasPaymentMethod &&
      !_isSaving;

  /// Cambiar estado de loading
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Guardar factura
  Future<bool> saveBill(BuildContext context) async {
    if (!canSave) {
      NotificationService.showSnackbarError(
        'Completa todos los campos requeridos',
      );
      return false;
    }

    // Validar stock de productos
    final stockError = _itemsProvider.validateStock();
    if (stockError != null) {
      NotificationService.showSnackbarError(stockError);
      return false;
    }

    _isSaving = true;
    notifyListeners();

    final customer = _customerProvider.selectedCustomer!;
    final items = _itemsProvider.billItems;
    final paymentMethod = _paymentProvider.selectedPaymentMethod!;
    final calculation = _calculationProvider;

    // Preparar datos de la factura
    final billData = {
      'customerId': customer.customerId,
      'paymentMethodId': paymentMethod.id,
      'items': items.map((item) {
        return {
          'itemId': item.item.id,
          'quantity': item.quantity,
          'unitPrice': item.unitPrice,
          'discount': item.discount,
        };
      }).toList(),
      'subtotal': calculation.subtotal,
      'customerDiscount': calculation.customerDiscount,
      'totalTax': calculation.totalTax,
      'total': calculation.total,
    };

    final success = await ErrorHandler.tryExecute<bool>(
      action: () async => await BillService.saveBill(
        context: context,
        billData: billData,
      ),
      context: context,
      errorMessage: 'Error al guardar la factura',
      showNotification: true,
      defaultValue: false,
    );

    if (success == true) {
      // Limpiar formulario después de guardar exitosamente
      clearForm();
    }

    _isSaving = false;
    notifyListeners();
    return success ?? false;
  }

  /// Limpiar formulario completo
  void clearForm() {
    _customerProvider.restoreConsumerFinal();
    _itemsProvider.clearItems();
    _paymentProvider.clearSelection();
    _calculationProvider.clear();
    notifyListeners();
  }
}
