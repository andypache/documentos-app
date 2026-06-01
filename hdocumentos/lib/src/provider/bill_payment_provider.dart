import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/share/preference.dart';

/// Provider especializado para gestionar el método de pago de la factura
/// Responsabilidades:
/// - Cargar métodos de pago disponibles
/// - Mantener el método de pago seleccionado
/// - Seleccionar método de pago
class BillPaymentProvider extends ChangeNotifier {
  // Estado
  PaymentMethodModel? _selectedPaymentMethod;
  List<PaymentMethodModel> _paymentMethods = [];

  // Getters
  PaymentMethodModel? get selectedPaymentMethod => _selectedPaymentMethod;
  List<PaymentMethodModel> get paymentMethods =>
      List.unmodifiable(_paymentMethods);
  bool get hasPaymentMethod => _selectedPaymentMethod != null;

  /// Inicializar provider - carga los métodos de pago desde
  /// Preferences.userSession.company.paymentMethods
  void initialize() {
    final company = Preferences.userSession.company;
    if (company == null) return;

    _paymentMethods = company.paymentMethods
        .asMap()
        .entries
        .map((e) => PaymentMethodModel(
              id: int.tryParse(e.value.paymentMethodId ?? '') ?? (e.key + 1),
              name: e.value.name ?? '',
            ))
        .where((m) => m.name.isNotEmpty)
        .toList();

    notifyListeners();
  }

  /// Seleccionar método de pago
  void selectPaymentMethod(PaymentMethodModel? method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  /// Limpiar selección (para resetear formulario)
  void clearSelection() {
    _selectedPaymentMethod = null;
    notifyListeners();
  }
}
