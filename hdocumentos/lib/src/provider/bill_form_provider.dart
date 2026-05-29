import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';

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
  double _discountItem = 0.0;
  double _discountTotal = 0.0;
  CustomerDiscountInfoModel? _customerDiscountInfo;
  final Map<String, DetailCalculateModel> _itemCalculations = {};
  SaleCalculateResponseModel? _lastCalculateResponse;

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
  double get discountItem => _discountItem;
  double get discountTotal => _discountTotal;
  CustomerDiscountInfoModel? get customerDiscountInfo => _customerDiscountInfo;
  SaleCalculateResponseModel? get lastCalculateResponse =>
      _lastCalculateResponse;

  // Getters - Estados UI
  bool get isLoading => _isLoading;
  bool get isCalculating => _isCalculating;
  bool get isSaving => _isSaving;
  bool get canSave => hasCustomer && hasItems && hasPaymentMethod && !isSaving;

  // Obtener cálculo de un item específico
  DetailCalculateModel? getItemCalculation(String itemId) {
    return _itemCalculations[itemId];
  }

  /// Inicializar provider - carga los métodos de pago desde
  /// [Preferences.userSession.company.paymentMethods], sin llamar
  /// a ninguna API ni acceder al storage.
  void initialize(BuildContext context) {
    _calculationContext = context;

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
  Future<void> addItem(ItemModel item,
      {int quantity = 1, double? customPrice}) async {
    // Verificar si el item ya existe
    final existingIndex = _billItems.indexWhere((bi) => bi.item.id == item.id);

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

    print('DEBUG: Item agregado, iniciando cálculo...');
    // Esperar a que termine el cálculo antes de continuar
    if (_calculationContext != null) {
      _debounceTimer?.cancel();
      await _calculateBill(_calculationContext!);
      print('DEBUG: Cálculo post-addItem completado');
    }
  }

  /// Actualizar item (precio, descuento, cantidad)
  Future<void> updateItem(int index,
      {int? quantity, double? unitPrice, double? discount}) async {
    if (index < 0 || index >= _billItems.length) return;

    final currentItem = _billItems[index];
    _billItems[index] = currentItem.copyWith(
      quantity: quantity,
      unitPrice: unitPrice,
      discount: discount,
    );

    notifyListeners();

    // Esperar a que termine el cálculo antes de continuar
    if (_calculationContext != null) {
      _debounceTimer?.cancel();
      await _calculateBill(_calculationContext!);
    }
  }

  /// Eliminar item de la factura
  Future<void> removeItem(int index) async {
    if (index >= 0 && index < _billItems.length) {
      _billItems.removeAt(index);
      notifyListeners();

      // Esperar a que termine el cálculo antes de continuar
      if (_calculationContext != null) {
        _debounceTimer?.cancel();
        await _calculateBill(_calculationContext!);
      }
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

    print('DEBUG: Iniciando cálculo... _isCalculating = true');
    _isCalculating = true;
    notifyListeners();

    try {
      final companyId = Preferences.userSession.company?.companyId;
      if (companyId == null) {
        if (context.mounted) {
          NotificationService.showSnackbarError(
            AppLocalizations.of(context).errorCompanyIdNotFound,
          );
        }
        _isCalculating = false;
        notifyListeners();
        return;
      }

      // Preparar request para la nueva API
      final request = SaleCalculateRequestModel(
        companyId: companyId,
        searchCustomer: SearchCustomerModel(
          companyId: companyId,
          notData: _selectedCustomer != null &&
              _selectedCustomer!.identification != null,
          identification: _selectedCustomer!.identification ?? '',
        ),
        dataForSaleDetails: _billItems.map((billItem) {
          return DataForSaleDetailModel(
            companyId: companyId,
            id: billItem.item.id!,
            amount: billItem.quantity,
            adminItemDiscount: billItem.discount,
            inventory: billItem.item.isService != 'Y',
          );
        }).toList(),
      );

      print('DEBUG: REQUEST preparado:');
      print('  - companyId: $companyId');
      print(
          '  - customer.identification: ${_selectedCustomer?.identification}');
      print('  - items count: ${_billItems.length}');
      for (var i = 0; i < _billItems.length; i++) {
        final item = _billItems[i];
        print(
            '  - Item $i: id=${item.item.id}, qty=${item.quantity}, price=${item.unitPrice}, discount=${item.discount}');
      }
      print(
          '  - dataForSaleDetails count: ${request.dataForSaleDetails.length}');

      // Llamar al servicio de cálculo real
      final response = await BillService.calculateSale(
        context: context,
        request: request,
      );

      print('DEBUG: RESPONSE recibido:');
      print('  - response es null: ${response == null}');
      if (response != null) {
        print('  - detailCalculate count: ${response.detailCalculate.length}');
        print(
            '  - totalCalculate.subTotal: ${response.totalCalculate.subTotal}');
        print('  - totalCalculate.total: ${response.totalCalculate.total}');
      }

      print('DEBUG: Response del API recibido');
      if (response != null) {
        _lastCalculateResponse = response;

        // Extraer totales del response
        final totalCalc = response.totalCalculate;
        _subtotal = totalCalc.subTotal;
        _customerDiscount = totalCalc.discountCustomer;
        _discountItem = totalCalc.discountItem;
        _discountTotal = totalCalc.discountTotal;
        _totalTax = totalCalc.totalTax;
        _total = totalCalc.total;

        print('DEBUG: Totales actualizados:');
        print('  - Subtotal: $_subtotal');
        print('  - Descuento cliente: $_customerDiscount');
        print('  - Descuento items: $_discountItem');
        print('  - Descuento total: $_discountTotal');
        print('  - Total impuestos: $_totalTax');
        print('  - Total: $_total');
        print(
            'DEBUG: _itemCalculations tiene ${_itemCalculations.length} items');

        // Actualizar info de descuento del cliente
        if (_customerDiscount > 0) {
          _customerDiscountInfo = CustomerDiscountInfoModel(
            percentage: (_customerDiscount / _subtotal * 100),
            amount: _customerDiscount,
            description: 'Descuento del cliente',
          );
        } else {
          _customerDiscountInfo = null;
        }

        // Guardar cálculos por item y actualizar items con datos del API
        _itemCalculations.clear();
        for (var detailCalc in response.detailCalculate) {
          _itemCalculations[detailCalc.itemId] = detailCalc;

          // Buscar el item correspondiente y actualizar con datos del API
          final index =
              _billItems.indexWhere((bi) => bi.item.id == detailCalc.itemId);
          if (index >= 0) {
            final currentItem = _billItems[index];
            // Actualizar con datos del API:
            // - quantity: usar amount del API para asegurar sincronización
            // - unitPrice: price_sale del API
            // - discount: mantener el descuento administrativo actual
            _billItems[index] = BillItemModel(
              item: currentItem.item,
              quantity: detailCalc.amount,
              unitPrice: detailCalc.priceSale,
              discount: currentItem.discount,
            );
          }
        }
      } else {
        // Si la respuesta es null, mantener los valores actuales
        print('DEBUG: Response es null, manteniendo valores actuales');
      }
    } catch (e) {
      // Si falla el servicio, mantener los valores actuales y mostrar error
      print('DEBUG: ERROR en cálculo: $e');
      print('DEBUG: Manteniendo valores actuales');
      if (context.mounted) {
        NotificationService.showSnackbarError(
          'Error al calcular: ${e.toString()}',
        );
      }
    }

    print('DEBUG: Cálculo completado. _isCalculating = false');
    _isCalculating = false;
    print('DEBUG: Valores JUSTO ANTES de notifyListeners():');
    print('  - subtotal getter: $subtotal');
    print('  - discountTotal getter: $discountTotal');
    print('  - totalTax getter: $totalTax');
    print('  - total getter: $total');
    print('DEBUG: Llamando notifyListeners()...');
    notifyListeners();
    print('DEBUG: notifyListeners() completado');
  }

  /// Cálculo local como fallback si el servicio falla
  void _calculateLocally() {
    _subtotal = 0.0;
    _totalTax = 0.0;
    _discountItem = 0.0;
    _discountTotal = 0.0;

    for (var billItem in _billItems) {
      // Cálculo básico local (sin descuentos de productos ni cliente)
      final itemSubtotal = billItem.unitPrice * billItem.quantity;
      _subtotal += itemSubtotal;

      // Calcular impuestos localmente si hay
      if (billItem.item.itemTaxes != null) {
        for (var tax in billItem.item.itemTaxes!) {
          _totalTax += itemSubtotal * (tax.percentage / 100);
        }
      }
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
        final stock = billItem.item.stock?.stock ?? 0;
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
            'itemId': item.item.id,
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
    _discountItem = 0.0;
    _discountTotal = 0.0;
    _totalTax = 0.0;
    _total = 0.0;
    _customerDiscountInfo = null;
    _itemCalculations.clear();
    _lastCalculateResponse = null;
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
