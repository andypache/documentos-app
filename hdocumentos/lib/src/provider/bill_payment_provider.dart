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
        .where((pm) => pm.name != null && pm.name!.isNotEmpty)
        .map((pm) {
      // Usar paymentMethodId si existe, sino generar uno único con el nombre
      final id = pm.paymentMethodId?.isNotEmpty == true
          ? pm.paymentMethodId!
          : pm.name!.replaceAll(' ', '_').toLowerCase();

      return PaymentMethodModel(
        id: id,
        name: pm.name!,
      );
    }).toList();

    // Eliminar duplicados por ID (mantener el primero)
    final uniqueIds = <String>{};
    _paymentMethods = _paymentMethods.where((m) {
      if (uniqueIds.contains(m.id)) {
        return false;
      }
      uniqueIds.add(m.id);
      return true;
    }).toList();

    notifyListeners();
  }

  /// Seleccionar método de pago
  void selectPaymentMethod(PaymentMethodModel? method) {
    if (method == null) {
      _selectedPaymentMethod = null;
    } else {
      // Buscar el método en la lista por ID para asegurar que sea la misma instancia
      _selectedPaymentMethod = _paymentMethods.firstWhere(
        (m) => m.id == method.id,
        orElse: () => method,
      );
    }
    notifyListeners();
  }

  /// Limpiar selección (para resetear formulario)
  void clearSelection() {
    _selectedPaymentMethod = null;
    notifyListeners();
  }
}
