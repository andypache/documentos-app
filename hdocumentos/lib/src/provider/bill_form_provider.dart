import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';

/// Provider para gestionar el estado del formulario de facturación
class BillFormProvider extends ChangeNotifier {
  // Estado del formulario
  CustomerModel? _selectedCustomer;
  final List<BillItemModel> _billItems = [];
  PaymentMethodModel? _selectedPaymentMethod;
  List<PaymentMethodModel> _paymentMethods = [];

  // Estado de cálculos (del servidor)
  double _subtotal = 0.0;
  double _customerDiscount = 0.0;
  double _totalTax = 0.0;
  double _total = 0.0;
  CustomerDiscountInfoModel? _customerDiscountInfo;
  final Map<int, BillCalculationItemResponseModel> _itemCalculations = {};

  // Estados de UI
  bool _isLoading = false;
  bool _isCalculating = false;
  bool _isSaving = false;

  // Timer para debouncing
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 800);

  // Constructor - inicializa con consumidor final
  BillFormProvider() {
    _selectedCustomer = CustomerModel(
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

  // Getters - Cliente
  CustomerModel? get selectedCustomer => _selectedCustomer;
  bool get hasCustomer => _selectedCustomer != null;

  // Getters - Items
  List<BillItemModel> get billItems => _billItems;
  int get itemCount => _billItems.length;
  bool get hasItems => _billItems.isNotEmpty;

  // Getters - Método de pago
  PaymentMethodModel? get selectedPaymentMethod => _selectedPaymentMethod;
  List<PaymentMethodModel> get paymentMethods => _paymentMethods;
  bool get hasPaymentMethod => _selectedPaymentMethod != null;

  // Getters - Totales
  double get subtotal => _subtotal;
  double get customerDiscount => _customerDiscount;
  double get totalTax => _totalTax;
  double get total => _total;
  CustomerDiscountInfoModel? get customerDiscountInfo => _customerDiscountInfo;

  // Getters - Estados UI
  bool get isLoading => _isLoading;
  bool get isCalculating => _isCalculating;
  bool get isSaving => _isSaving;
  bool get canSave => hasCustomer && hasItems && hasPaymentMethod && !isSaving;

  // Obtener cálculo de un item específico
  BillCalculationItemResponseModel? getItemCalculation(int itemId) {
    return _itemCalculations[itemId];
  }

  /// Inicializar provider - cargar métodos de pago
  Future<void> initialize(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    _paymentMethods = await BillService.getPaymentMethods(context: context);

    _isLoading = false;
    notifyListeners();
  }

  /// Seleccionar cliente
  void selectCustomer(CustomerModel? customer) {
    _selectedCustomer = customer;
    notifyListeners();

    // Recalcular si hay items (el descuento del cliente puede cambiar)
    if (_billItems.isNotEmpty) {
      _triggerCalculation();
    }
  }

  /// Remover cliente seleccionado (deja sin cliente)
  void removeCustomer() {
    _selectedCustomer = null;
    notifyListeners();

    // Recalcular si hay items (el descuento del cliente puede cambiar)
    if (_billItems.isNotEmpty) {
      _triggerCalculation();
    }
  }

  /// Asignar consumidor final
  void assignConsumerFinal() {
    _selectedCustomer = CustomerModel(
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
    notifyListeners();

    // Recalcular si hay items
    if (_billItems.isNotEmpty) {
      _triggerCalculation();
    }
  }

  /// Agregar item a la factura
  void addItem(ItemModel item, {int quantity = 1, double? customPrice}) {
    // Verificar si el item ya existe
    final existingIndex =
        _billItems.indexWhere((bi) => bi.item.itemId == item.itemId);

    if (existingIndex >= 0) {
      // Si existe, actualizar cantidad
      final existing = _billItems[existingIndex];
      _billItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      // Si no existe, agregar nuevo
      final billItem = BillItemModel.fromItem(
        item: item,
        quantity: quantity,
        customPrice: customPrice,
      );
      _billItems.add(billItem);
    }

    notifyListeners();
    _triggerCalculation();
  }

  /// Actualizar item (precio, descuento, cantidad)
  void updateItem(int index,
      {int? quantity, double? unitPrice, double? discount}) {
    if (index < 0 || index >= _billItems.length) return;

    final currentItem = _billItems[index];
    _billItems[index] = currentItem.copyWith(
      quantity: quantity,
      unitPrice: unitPrice,
      discount: discount,
    );

    notifyListeners();
    _triggerCalculation();
  }

  /// Eliminar item de la factura
  void removeItem(int index) {
    if (index >= 0 && index < _billItems.length) {
      _billItems.removeAt(index);
      notifyListeners();
      _triggerCalculation();
    }
  }

  /// Limpiar todos los items
  void clearItems() {
    _billItems.clear();
    _resetCalculations();
    notifyListeners();
  }

  /// Seleccionar método de pago
  void selectPaymentMethod(PaymentMethodModel? method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  /// Disparar cálculo automático (debounced)
  BuildContext? _calculationContext;

  void _triggerCalculation() {
    if (_calculationContext == null || _billItems.isEmpty) {
      return;
    }

    // Cancelar timer anterior si existe
    _debounceTimer?.cancel();

    // Crear nuevo timer
    _debounceTimer = Timer(_debounceDuration, () {
      if (_calculationContext != null) {
        _calculateBill(_calculationContext!);
      }
    });
  }

  /// Calcular totales en el servidor
  Future<void> calculateBill(BuildContext context) async {
    _calculationContext = context;

    // Cancelar debounce y calcular inmediatamente
    _debounceTimer?.cancel();
    await _calculateBill(context);
  }

  Future<void> _calculateBill(BuildContext context) async {
    if (_billItems.isEmpty) {
      _resetCalculations();
      return;
    }

    _isCalculating = true;
    notifyListeners();

    try {
      // Preparar request
      final request = BillCalculationRequestModel(
        customerId: _selectedCustomer?.customerId != null
            ? int.tryParse(_selectedCustomer!.customerId!)
            : null,
        items: _billItems.map((billItem) {
          return BillCalculationItemModel(
            itemId: int.parse(billItem.item.itemId!),
            quantity: billItem.quantity,
            unitPrice: billItem.unitPrice,
            discount: billItem.discount,
          );
        }).toList(),
      );

      // Llamar al servicio
      final response = await BillService.calculateBill(
        context: context,
        request: request,
      );

      if (response != null) {
        _subtotal = response.subtotal;
        _customerDiscount = response.customerDiscount;
        _totalTax = response.totalTax;
        _total = response.total;
        _customerDiscountInfo = response.customerDiscountInfo;

        // Guardar cálculos por item
        _itemCalculations.clear();
        for (var itemCalc in response.items) {
          _itemCalculations[itemCalc.itemId] = itemCalc;
        }
      }
    } catch (e) {
      // Si falla el servicio, calcular localmente como fallback
      _calculateLocally();
    }

    _isCalculating = false;
    notifyListeners();
  }

  /// Cálculo local como fallback si el servicio falla
  void _calculateLocally() {
    _subtotal = 0.0;
    _totalTax = 0.0;

    for (var billItem in _billItems) {
      _subtotal += billItem.subtotal;
      _totalTax += billItem.totalTax;
    }

    // Aplicar descuento del cliente si existe
    _customerDiscount = 0.0;
    if (_selectedCustomer?.customerDiscount != null) {
      final discountPercent =
          _selectedCustomer!.customerDiscount!.discountValue ?? 0;
      _customerDiscount = _subtotal * (discountPercent / 100);
      _customerDiscountInfo = CustomerDiscountInfoModel(
        percentage: discountPercent.toDouble(),
        amount: _customerDiscount,
        description: 'Descuento del cliente',
      );
    }

    _total = _subtotal - _customerDiscount + _totalTax;
  }

  /// Guardar factura
  Future<bool> saveBill(BuildContext context) async {
    if (!canSave) {
      NotificationService.showSnackbarError(
        'Completa todos los campos requeridos',
      );
      return false;
    }

    // Validar stock de productos (solo productos físicos)
    for (var billItem in _billItems) {
      if (billItem.item.isService != 'Y') {
        final stock = billItem.item.stock ?? 0;
        if (billItem.quantity > stock) {
          NotificationService.showSnackbarError(
            'Stock insuficiente para ${billItem.item.name}. Disponible: $stock',
          );
          return false;
        }
      }
    }

    _isSaving = true;
    notifyListeners();

    try {
      // Preparar datos de la factura
      final billData = {
        'customerId': _selectedCustomer!.customerId,
        'paymentMethodId': _selectedPaymentMethod!.id,
        'items': _billItems.map((item) {
          return {
            'itemId': item.item.itemId,
            'quantity': item.quantity,
            'unitPrice': item.unitPrice,
            'discount': item.discount,
          };
        }).toList(),
        'subtotal': _subtotal,
        'customerDiscount': _customerDiscount,
        'totalTax': _totalTax,
        'total': _total,
      };

      final success = await BillService.saveBill(
        context: context,
        billData: billData,
      );

      if (success) {
        // Limpiar formulario después de guardar exitosamente
        clearForm();
      }

      return success;
    } catch (e) {
      NotificationService.showSnackbarError(
        'Error al guardar la factura: ${e.toString()}',
      );
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Resetear cálculos
  void _resetCalculations() {
    _subtotal = 0.0;
    _customerDiscount = 0.0;
    _totalTax = 0.0;
    _total = 0.0;
    _customerDiscountInfo = null;
    _itemCalculations.clear();
  }

  /// Limpiar formulario completo
  void clearForm() {
    // Restaurar consumidor final por defecto
    _selectedCustomer = CustomerModel(
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
    _billItems.clear();
    _selectedPaymentMethod = null;
    _resetCalculations();
    _calculationContext = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _calculationContext = null;
    super.dispose();
  }
}
