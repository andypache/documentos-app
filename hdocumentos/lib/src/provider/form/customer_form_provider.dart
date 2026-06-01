import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/share/form_validation_helper.dart';
import 'package:hdocumentos/src/share/app_logger.dart';

///Provider for management customer form wizard
class CustomerFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep3 = GlobalKey<FormState>();

  int _currentStep = 0;
  bool _isLoading = false;
  CustomerModel _customer = CustomerModel.createEmpty();
  List<IdentificationTypeModel> _identificationTypes = [];

  // Getters
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  CustomerModel get customer => _customer;
  List<IdentificationTypeModel> get identificationTypes => _identificationTypes;

  CustomerFormProvider() {
    _loadIdentificationTypes();
  }

  /// Carga los tipos de identificación desde [FlutterSecureStorage]
  /// (clave `'catalogs'`), sin llamar a ninguna API.
  Future<void> _loadIdentificationTypes() async {
    const storage = FlutterSecureStorage();
    try {
      final raw = await storage.read(key: 'catalogs');
      if (raw != null && raw.isNotEmpty) {
        final catalogList =
            CatalogModelList.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        _identificationTypes = catalogList.identificationTypes
            .asMap()
            .entries
            .map((e) => IdentificationTypeModel(
                  identificationTypeId: e.value.code,
                  name: e.value.description,
                  description: e.value.description,
                  sriCode: e.value.code,
                  status: 'A',
                ))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      AppLogger.warning(
        'No se pudieron cargar tipos de identificación desde storage: $e',
        tag: 'CustomerFormProvider',
      );
      // La lista queda vacía, no es crítico para el flujo
    }
  }

  // Step 1 - Tipo de Identificación y Datos Personales/Empresa
  String? identificationTypeId;
  IdentificationTypeModel? identificationType;
  String identification = "";
  String firstName = "";
  String lastName = "";
  String businessName = "";

  // Step 2 - Información de Contacto
  String email = "";
  String phoneNumber = "";
  String address = "";

  // Step 3 - Descuento del Cliente
  DateTime? startDate;
  DateTime? endDate;
  bool isVariable = false;
  int discountValue = 0;
  String? customerDiscountId;
  CustomerDiscountModel? customerDiscount;
  String status = 'A';

  // Setters
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set currentStep(int value) {
    _currentStep = value;
    notifyListeners();
  }

  // Determinar si es persona natural o empresa según el tipo de identificación
  bool isCompany() {
    // RUC en Ecuador tiene código '04' en el SRI
    return identificationType?.sriCode == '04' ||
        identificationType?.inicials == 'RUC';
  }

  // Validar formulario del paso actual
  bool isValidCurrentStep() {
    switch (_currentStep) {
      case 0:
        return formKeyStep1.currentState?.validate() ?? false;
      case 1:
        return formKeyStep2.currentState?.validate() ?? false;
      case 2:
        return formKeyStep3.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  /// Valida y construye el modelo de cliente, lanzando ValidationException si hay errores
  ///
  /// Ejemplo de uso:
  /// ```dart
  /// try {
  ///   final customer = provider.validateAndBuildCustomer();
  ///   await CustomerService.saveCustomer(context, customer);
  /// } on ValidationException catch (e) {
  ///   ErrorHandler.handleError(e, context: context);
  /// }
  /// ```
  CustomerModel validateAndBuildCustomer() {
    // Validar formularios de todos los pasos
    FormValidationHelper.validateForm(
      formKey: formKeyStep1,
      formName: 'Información de Identificación',
    );
    FormValidationHelper.validateForm(
      formKey: formKeyStep2,
      formName: 'Información de Contacto',
    );
    FormValidationHelper.validateForm(
      formKey: formKeyStep3,
      formName: 'Descuento del Cliente',
    );

    // Validar campos requeridos según tipo de cliente
    if (isCompany()) {
      FormValidationHelper.validateRequiredFields({
        'Razón Social': businessName,
        'Identificación': identification,
      });
    } else {
      FormValidationHelper.validateRequiredFields({
        'Nombre': firstName,
        'Apellido': lastName,
        'Identificación': identification,
      });
    }

    // Validar email si fue proporcionado
    if (email.isNotEmpty) {
      FormValidationHelper.validateEmail(email);
    }

    // Validar teléfono si fue proporcionado (mínimo 7 dígitos)
    if (phoneNumber.isNotEmpty) {
      FormValidationHelper.validateLength(
        value: phoneNumber.replaceAll(RegExp(r'\D'), ''), // solo dígitos
        fieldName: 'Teléfono',
        minLength: 7,
        maxLength: 15,
      );
    }

    // Construir descuento si aplica
    CustomerDiscountModel? discount;
    if (discountValue > 0 || startDate != null || endDate != null) {
      // Validar rango de descuento
      FormValidationHelper.validateRange(
        value: discountValue,
        fieldName: 'Descuento',
        min: 0,
        max: 100,
      );

      discount = CustomerDiscountModel(
        customerDiscountId: customerDiscountId,
        startDate: startDate,
        endDate: endDate,
        isVariable: isVariable ? 'Y' : 'N',
        discountValue: discountValue,
        status: 'A',
      );
    }

    return CustomerModel(
      identificationTypeId: identificationTypeId,
      identificationType: identificationType,
      identification: identification.isEmpty ? null : identification,
      firstName: isCompany() ? null : (firstName.isEmpty ? null : firstName),
      lastName: isCompany() ? null : (lastName.isEmpty ? null : lastName),
      businessName:
          isCompany() ? (businessName.isEmpty ? null : businessName) : null,
      email: email.isEmpty ? null : email,
      phoneNumber: phoneNumber.isEmpty ? null : phoneNumber,
      address: address.isEmpty ? null : address,
      customerDiscountId: discount?.customerDiscountId,
      customerDiscount: discount,
      status: status,
    );
  }

  // Navegar al siguiente paso
  bool nextStep() {
    if (isValidCurrentStep() && _currentStep < 2) {
      _currentStep++;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Navegar al paso anterior (sin validación)
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Ir a un paso específico
  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Actualizar tipo de identificación
  void updateIdentificationType(IdentificationTypeModel? type) {
    identificationType = type;
    identificationTypeId = type?.identificationTypeId;
    // Limpiar campos según el cambio de tipo
    if (type != null) {
      if (isCompany()) {
        firstName = "";
        lastName = "";
      } else {
        businessName = "";
      }
    }
    notifyListeners();
  }

  // Actualizar descuento
  void updateCustomerDiscount(CustomerDiscountModel? discount) {
    customerDiscount = discount;
    customerDiscountId = discount?.customerDiscountId;
    notifyListeners();
  }

  // Construir el modelo completo
  CustomerModel buildCustomerModel() {
    // Crear el descuento solo si tiene valores válidos
    CustomerDiscountModel? discount;
    if (discountValue > 0 || startDate != null || endDate != null) {
      discount = CustomerDiscountModel(
        customerDiscountId: customerDiscountId,
        startDate: startDate,
        endDate: endDate,
        isVariable: isVariable ? 'Y' : 'N',
        discountValue: discountValue,
        status: 'A',
      );
    }

    return CustomerModel(
      identificationTypeId: identificationTypeId,
      identificationType: identificationType,
      identification: identification.isEmpty ? null : identification,
      firstName: isCompany() ? null : (firstName.isEmpty ? null : firstName),
      lastName: isCompany() ? null : (lastName.isEmpty ? null : lastName),
      businessName:
          isCompany() ? (businessName.isEmpty ? null : businessName) : null,
      email: email.isEmpty ? null : email,
      phoneNumber: phoneNumber.isEmpty ? null : phoneNumber,
      address: address.isEmpty ? null : address,
      customerDiscountId: discount?.customerDiscountId,
      customerDiscount: discount,
      status: status,
    );
  }

  // Cargar un cliente existente para edición
  void loadCustomer(CustomerModel existingCustomer) {
    _customer = existingCustomer;
    identificationTypeId = existingCustomer.identificationTypeId;
    identificationType = existingCustomer.identificationType;
    identification = existingCustomer.identification ?? "";
    firstName = existingCustomer.firstName ?? "";
    lastName = existingCustomer.lastName ?? "";
    businessName = existingCustomer.businessName ?? "";
    email = existingCustomer.email ?? "";
    phoneNumber = existingCustomer.phoneNumber ?? "";
    address = existingCustomer.address ?? "";

    // Cargar descuento si existe
    if (existingCustomer.customerDiscount != null) {
      customerDiscountId =
          existingCustomer.customerDiscount!.customerDiscountId;
      customerDiscount = existingCustomer.customerDiscount;
      startDate = existingCustomer.customerDiscount!.startDate;
      endDate = existingCustomer.customerDiscount!.endDate;
      isVariable = existingCustomer.customerDiscount!.isVariable == 'Y';
      discountValue = existingCustomer.customerDiscount!.discountValue ?? 0;
    }

    status = existingCustomer.status ?? 'A';
    notifyListeners();
  }

  // Resetear el formulario
  void reset() {
    _currentStep = 0;
    _isLoading = false;
    identificationTypeId = null;
    identificationType = null;
    identification = "";
    firstName = "";
    lastName = "";
    businessName = "";
    email = "";
    phoneNumber = "";
    address = "";
    startDate = null;
    endDate = null;
    isVariable = false;
    discountValue = 0;
    customerDiscountId = null;
    customerDiscount = null;
    status = 'A';
    notifyListeners();
  }
}
