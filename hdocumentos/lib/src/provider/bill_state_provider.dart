import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/bill_customer_provider.dart';
import 'package:hdocumentos/src/provider/bill_items_provider.dart';
import 'package:hdocumentos/src/provider/bill_payment_provider.dart';
import 'package:hdocumentos/src/provider/bill_calculation_provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/exception/error_handler.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/share/preference.dart';

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
        _calculationProvider = calculationProvider {
    // Escuchar cambios de los providers para actualizar canSave
    _customerProvider.addListener(_onDependencyChanged);
    _itemsProvider.addListener(_onDependencyChanged);
    _paymentProvider.addListener(_onDependencyChanged);
    _calculationProvider.addListener(_onDependencyChanged);
  }

  /// Callback cuando cambia alguna dependencia
  void _onDependencyChanged() {
    notifyListeners();
  }

  // Getters - Estados
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  /// Indica si la factura puede ser guardada
  /// Requiere cliente, items y método de pago
  bool get canSave =>
      _customerProvider.hasCustomer &&
      _itemsProvider.hasItems &&
      _paymentProvider.hasPaymentMethod &&
      _calculationProvider.lastCalculateResponse != null &&
      !_calculationProvider.isCalculating &&
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
        AppLocalizations.of(context).billRequiredFieldsHint,
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
    final paymentMethod = _paymentProvider.selectedPaymentMethod!;
    final calculation = _calculationProvider;
    final lastCalculateResponse = calculation.lastCalculateResponse;

    // Validar que tengamos el response del cálculo
    if (lastCalculateResponse == null) {
      NotificationService.showSnackbarError(
        AppLocalizations.of(context).billCalculateBeforeSave,
      );
      _isSaving = false;
      notifyListeners();
      return false;
    }

    // Obtener datos de sesión y compañía
    final userSession = Preferences.userSession;
    final company = userSession.company;

    if (company == null) {
      NotificationService.showSnackbarError(
        AppLocalizations.of(context).billCompanyInfoNotFound,
      );
      _isSaving = false;
      notifyListeners();
      return false;
    }

    // Determinar si es consumidor final (no_data)
    final isConsumerFinal = customer.customerId == '0';

    // Construir datos del cliente
    final customerData = CustomerSaleModel(
      identificationType:
          customer.identificationType?.identificationTypeId ?? '',
      identification: customer.identification ?? '',
      businessName: customer.businessName ?? '',
      name: customer.firstName ?? '',
      surname: '', // No está en CustomerModel actual
      lastname: customer.lastName ?? '',
      telephone: customer.phoneNumber ?? '',
      location: customer.address ?? '',
      email: customer.email ?? '',
    );

    // Construir lista de impuestos totales desde el response del cálculo
    final totalTaxList = lastCalculateResponse.totalCalculate.subTotalTaxList
        .map((tax) => TotalTaxListModel(
              companySaleParameterId: tax.companySaleParameterId,
              calculationSubtotal: tax.subTotal,
              taxPercentage: tax.value,
              taxValue: tax.total,
            ))
        .toList();

    // Construir detalles de venta desde el response del cálculo
    final saleDetails = lastCalculateResponse.detailCalculate.map((detail) {
      // Construir lista de impuestos por item
      final taxList = detail.taxList
          .map((tax) => TaxListModel(
                companySaleParameterId: '', // El API debe proporcionarlo
                calculationSubtotal: tax.value,
                taxPercentage: 0.0, // No está en SaleTaxDetailModel
                taxValue: tax.valueTax,
              ))
          .toList();

      return SaleDetailModel(
        itemId: detail.itemId,
        amount: detail.amount,
        price: detail.price,
        cost: detail.cost,
        description: detail.description,
        discount: detail.discount,
        discountValue:
            detail.discountCustomerValue + detail.discountProductValue,
        total: detail.total,
        totalDiscount: detail.totalDiscount,
        inventory: detail.inventory,
        taxList: taxList,
      );
    }).toList();

    // Construir detalle de método de pago
    final paymentMethodDetails = [
      PaymentMethodDetailModel(
        companyPaymentMethodId: paymentMethod.id.toString(),
        value: calculation.total,
      ),
    ];

    // Construir request completo
    final request = SaleCreateRequestModel(
      username: userSession.username,
      companyId: company.companyId ?? '',
      companyUserId: company.users.isNotEmpty ? company.users[0].id ?? '' : '',
      noData: isConsumerFinal,
      establishmentNumber: company.establishmentCode ?? '',
      emissionPoint: company.emissionPointCode ?? '',
      customer: customerData,
      subtotal: calculation.subtotal,
      discount: calculation.customerDiscount,
      discountItem: calculation.discountItem,
      discountValue: calculation.discountTotal,
      totalTax: calculation.totalTax,
      total: calculation.total,
      subtotalWithoutTax:
          lastCalculateResponse.totalCalculate.subTotalWithoutTax,
      totalTaxList: totalTaxList,
      saleDetails: saleDetails,
      paymentMethodDetails: paymentMethodDetails,
    );

    final success = await ErrorHandler.tryExecute<bool>(
      action: () async => await BillService.saveBill(
        context: context,
        request: request,
      ),
      context: context,
      errorMessage: AppLocalizations.of(context).billSaveErrorMessage,
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

  @override
  void dispose() {
    // Remover listeners para evitar memory leaks
    _customerProvider.removeListener(_onDependencyChanged);
    _itemsProvider.removeListener(_onDependencyChanged);
    _paymentProvider.removeListener(_onDependencyChanged);
    _calculationProvider.removeListener(_onDependencyChanged);
    super.dispose();
  }
}
