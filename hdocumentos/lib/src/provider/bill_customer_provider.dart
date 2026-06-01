import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';

/// Provider especializado para gestionar el cliente de la factura
/// Responsabilidades:
/// - Mantener el cliente seleccionado
/// - Seleccionar/remover/asignar consumidor final
/// - Notificar cambios que requieran recalcular
class BillCustomerProvider extends ChangeNotifier {
  // Estado
  CustomerModel? _selectedCustomer;

  // Callback para notificar que cambió el cliente y se debe recalcular
  VoidCallback? onCustomerChanged;

  // Constructor - inicializa con consumidor final por defecto
  BillCustomerProvider() {
    _selectedCustomer = _createConsumerFinal();
  }

  // Getters
  CustomerModel? get selectedCustomer => _selectedCustomer;
  bool get hasCustomer => _selectedCustomer != null;
  bool get isConsumerFinal =>
      _selectedCustomer?.customerId == '0' &&
      _selectedCustomer?.identification == '9999999999999';

  /// Seleccionar cliente
  void selectCustomer(CustomerModel? customer) {
    _selectedCustomer = customer;
    notifyListeners();

    // Notificar que cambió el cliente (para recalcular)
    onCustomerChanged?.call();
  }

  /// Remover cliente seleccionado (deja sin cliente)
  void removeCustomer() {
    _selectedCustomer = null;
    notifyListeners();

    // Notificar que cambió el cliente (para recalcular)
    onCustomerChanged?.call();
  }

  /// Asignar consumidor final
  void assignConsumerFinal() {
    _selectedCustomer = _createConsumerFinal();
    notifyListeners();

    // Notificar que cambió el cliente (para recalcular)
    onCustomerChanged?.call();
  }

  /// Restaurar consumidor final (para limpiar formulario)
  void restoreConsumerFinal() {
    _selectedCustomer = _createConsumerFinal();
    notifyListeners();
  }

  /// Factory para crear el modelo de consumidor final
  CustomerModel _createConsumerFinal() {
    return CustomerModel(
      customerId: '0',
      firstName: 'CONSUMIDOR',
      lastName: 'FINAL',
      identification: '9999999999999',
      identificationType: IdentificationTypeModel(
        identificationTypeId: '1',
        name: 'CONSUMIDOR FINAL',
        status: 'A',
      ),
      status: 'A',
    );
  }
}
