import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/bill_customer_provider.dart';
import 'package:hdocumentos/src/provider/bill_items_provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:hdocumentos/src/share/app_logger.dart';
import 'package:hdocumentos/src/exception/error_handler.dart';

/// Provider especializado para cálculos de facturación
/// Responsabilidades:
/// - Calcular totales consultando al servidor
/// - Gestionar debouncing de cálculos
/// - Mantener resultados de cálculos (subtotal, descuentos, impuestos, total)
/// - Actualizar items con datos del servidor
class BillCalculationProvider extends ChangeNotifier {
  // Referencias a otros providers
  final BillCustomerProvider _customerProvider;
  final BillItemsProvider _itemsProvider;

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

  // Estados
  bool _isCalculating = false;

  // Timer para debouncing
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 800);
  BuildContext? _calculationContext;

  // Constructor
  BillCalculationProvider({
    required BillCustomerProvider customerProvider,
    required BillItemsProvider itemsProvider,
  })  : _customerProvider = customerProvider,
        _itemsProvider = itemsProvider {
    // Suscribirse a cambios de customer e items
    _customerProvider.onCustomerChanged = _triggerCalculation;
    _itemsProvider.onItemsChanged = _triggerCalculation;
  }

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

  // Getters - Estados
  bool get isCalculating => _isCalculating;

  /// Obtener cálculo de un item específico
  DetailCalculateModel? getItemCalculation(String itemId) {
    return _itemCalculations[itemId];
  }

  /// Inicializar contexto para cálculos
  void initialize(BuildContext context) {
    _calculationContext = context;
  }

  /// Disparar cálculo automático (debounced)
  void _triggerCalculation() {
    // Cancelar timer anterior si existe
    _debounceTimer?.cancel();

    // Si no hay items, resetear inmediatamente sin debounce
    if (!_itemsProvider.hasItems) {
      _resetCalculations();
      return;
    }

    // Si no hay contexto, no se puede calcular
    if (_calculationContext == null) {
      return;
    }

    // Crear nuevo timer para calcular con debounce
    _debounceTimer = Timer(_debounceDuration, () {
      if (_calculationContext != null) {
        _calculateBill(_calculationContext!);
      }
    });
  }

  /// Calcular totales en el servidor (público para llamadas manuales)
  Future<void> calculateBill(BuildContext context) async {
    _calculationContext = context;

    // Cancelar debounce y calcular inmediatamente
    _debounceTimer?.cancel();
    await _calculateBill(context);
  }

  /// Calcular totales en el servidor (implementación interna)
  Future<void> _calculateBill(BuildContext context) async {
    if (!_itemsProvider.hasItems) {
      _resetCalculations();
      return;
    }

    AppLogger.debug('Iniciando cálculo, _isCalculating = true',
        tag: 'BillCalculationProvider');
    _isCalculating = true;
    notifyListeners();

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

    final customer = _customerProvider.selectedCustomer;
    final items = _itemsProvider.billItems;

    // Preparar request para la nueva API
    final request = SaleCalculateRequestModel(
      companyId: companyId,
      searchCustomer: SearchCustomerModel(
        companyId: companyId,
        notData: customer != null && customer.identification != null,
        identification: customer?.identification ?? '',
      ),
      dataForSaleDetails: items.map((billItem) {
        return DataForSaleDetailModel(
          companyId: companyId,
          id: billItem.item.id!,
          amount: billItem.quantity,
          adminItemDiscount: billItem.discount,
          inventory: billItem.item.isService != 'Y',
        );
      }).toList(),
    );

    AppLogger.info('Request preparado para cálculo',
        tag: 'BillCalculationProvider');
    AppLogger.debug('  - CompanyId: $companyId',
        tag: 'BillCalculationProvider');
    AppLogger.debug('  - Customer: ${customer?.identification}',
        tag: 'BillCalculationProvider');
    AppLogger.debug('  - Items: ${items.length}',
        tag: 'BillCalculationProvider');

    // Llamar al servicio de cálculo real con manejo de errores
    final response = await ErrorHandler.tryExecute<SaleCalculateResponseModel?>(
      action: () async => await BillService.calculateSale(
        context: context,
        request: request,
      ),
      context: context,
      errorMessage: 'Error al calcular totales',
      showNotification: true,
    );

    if (response != null) {
      AppLogger.success(
        'Respuesta recibida: ${response.detailCalculate.length} items, total: \$${response.totalCalculate.total}',
        tag: 'BillCalculationProvider',
      );

      _lastCalculateResponse = response;

      // Extraer totales del response
      final totalCalc = response.totalCalculate;
      _subtotal = totalCalc.subTotal;
      _customerDiscount = totalCalc.discountCustomer;
      _discountItem = totalCalc.discountItem;
      _discountTotal = totalCalc.discountTotal;
      _totalTax = totalCalc.totalTax;
      _total = totalCalc.total;

      AppLogger.info('Totales actualizados:', tag: 'BillCalculationProvider');
      AppLogger.debug('  - Subtotal: \$$_subtotal',
          tag: 'BillCalculationProvider');
      AppLogger.debug('  - Desc. total: \$$_discountTotal',
          tag: 'BillCalculationProvider');
      AppLogger.debug('  - Impuestos: \$$_totalTax',
          tag: 'BillCalculationProvider');
      AppLogger.debug('  - TOTAL: \$$_total', tag: 'BillCalculationProvider');

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
        final index = _itemsProvider.findItemIndexById(detailCalc.itemId);
        if (index >= 0) {
          final currentItem = _itemsProvider.billItems[index];
          // Actualizar con datos del API sin disparar recálculo
          final updatedItem = BillItemModel(
            item: currentItem.item,
            quantity: detailCalc.amount,
            unitPrice: detailCalc.priceSale,
            discount: currentItem.discount,
          );
          _itemsProvider.updateItemModel(index, updatedItem);
        }
      }
    } else {
      AppLogger.warning('Response es null, manteniendo valores actuales',
          tag: 'BillCalculationProvider');
    }

    _isCalculating = false;
    AppLogger.debug(
      'Cálculo finalizado - Subtotal: \$$subtotal, Total: \$$total',
      tag: 'BillCalculationProvider',
    );
    notifyListeners();
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
    _isCalculating = false;
    notifyListeners();
  }

  /// Limpiar todo (para resetear formulario)
  void clear() {
    _resetCalculations();
    _calculationContext = null;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _calculationContext = null;
    super.dispose();
  }
}
