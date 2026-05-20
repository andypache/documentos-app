import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/model/common/catalog_model.dart';
import 'package:hdocumentos/src/model/common/sale_parameter_model.dart';
import 'package:hdocumentos/src/service/company_service.dart';
import 'package:hdocumentos/src/share/preference.dart';

///Provider for management item form wizard
class ItemFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep4 = GlobalKey<FormState>();

  int _currentStep = 0;
  bool _isLoading = false;
  bool _isEditing = false;
  ItemModel _item = ItemModel.createEmpty();

  // Getters
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;
  ItemModel get item => _item;

  // Step 1 - Información Básica
  String name = "";
  String description = "";
  String searchKey = "";
  bool isService = false;
  String state = 'A';

  // Step 2 - Precios y Stock
  double price = 0.0;
  double cost = 0.0;
  double discount = 0.0;
  int stock = 0;

  // Step 3 - Códigos e Imagen
  String barCode = "";
  String qrCode = "";
  Uint8List? image;
  String? imageName;

  // Step 4 - Impuestos
  List<ItemTaxModel> itemTaxList = [];

  // Setters
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set currentStep(int value) {
    _currentStep = value;
    notifyListeners();
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
      case 3:
        return formKeyStep4.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  // Navegar al siguiente paso
  bool nextStep() {
    if (isValidCurrentStep() && _currentStep < 3) {
      _currentStep++;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Navegar al paso anterior
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Ir a un paso específico
  void goToStep(int step) {
    if (step >= 0 && step <= 3) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Actualizar imagen
  void updateImage(Uint8List? imageData, String? fileName) {
    image = imageData;
    imageName = fileName;
    notifyListeners();
  }

  // Agregar impuesto
  void addTax(ItemTaxModel tax) {
    itemTaxList.add(tax);
    notifyListeners();
  }

  // Remover impuesto
  void removeTax(int index) {
    if (index >= 0 && index < itemTaxList.length) {
      itemTaxList.removeAt(index);
      notifyListeners();
    }
  }

  // Construir el modelo completo
  ItemModel buildItemModel() {
    return ItemModel(
      name: name,
      description: description.isEmpty ? null : description,
      searchKey: searchKey.isEmpty ? null : searchKey,
      isService: isService ? 'Y' : 'N',
      barCode: barCode.isEmpty ? null : barCode,
      qrCode: qrCode.isEmpty ? null : qrCode,
      state: state,
      createdAt: DateTime.now(),
      pricing: ItemPricingModel(price: price, cost: cost, discount: discount),
      stock: ItemStockModel(stock: isService ? 0 : stock),
      media: image != null ? ItemMediaModel(image: image) : null,
      itemTaxes: itemTaxList.isEmpty ? null : itemTaxList,
    );
  }

  // Cargar un item existente para edición
  Future<void> loadItem(ItemModel existingItem, BuildContext context) async {
    _item = existingItem;
    _isEditing = true;
    name = existingItem.name;
    description = existingItem.description ?? "";
    searchKey = existingItem.searchKey ?? "";
    isService = existingItem.isService == 'Y';
    state = existingItem.state ?? 'A';
    price = existingItem.pricing?.price ?? 0.0;
    cost = existingItem.pricing?.cost ?? 0.0;
    discount = existingItem.pricing?.discount ?? 0.0;
    stock = existingItem.stock?.stock ?? 0;
    barCode = existingItem.barCode ?? "";
    qrCode = existingItem.qrCode ?? "";
    image = existingItem.media?.image;
    imageName = null;
    itemTaxList = await _enrichTaxes(existingItem.itemTaxes ?? [], context);
    notifyListeners();
  }

  /// Enriquece cada [ItemTaxModel] con los datos de presentación del catálogo
  /// (nombre, porcentaje, taxCode, percentageCode) usando la misma lógica
  /// que [TaxSelectionDialogWidget._loadTaxes].
  Future<List<ItemTaxModel>> _enrichTaxes(
    List<ItemTaxModel> rawTaxes,
    BuildContext context,
  ) async {
    if (rawTaxes.isEmpty) return rawTaxes;

    final companySaleParams =
        Preferences.userSession.company?.saleParameters ?? [];
    if (companySaleParams.isEmpty) return rawTaxes;

    final catalog =
        await CompanyService().getCatalogs(context) ?? CatalogModelList();

    // Índices O(1) — igual que en el diálogo de selección
    final saleParamByCode = {
      for (final sp in catalog.saleParameters) sp.code: sp,
    };
    final systemParamByCode = {
      for (final sp in catalog.systemParameters) sp.code: sp,
    };
    final companySaleById = {
      for (final csp in companySaleParams) csp.id: csp,
    };

    return rawTaxes.map((tax) {
      // Si ya viene con el árbol completo de presentación, no toca nada
      if (tax.companySaleParameter?.saleParameter?.name != null) return tax;

      final csp = companySaleById[tax.idCompanySaleParameter];
      if (csp == null) return tax;

      final catalogSaleParam = saleParamByCode[csp.saleParameterId];
      if (catalogSaleParam == null) return tax;

      final systemParamId =
          catalogSaleParam.value?['system_parameter_id'] as String?;
      final systemParam = systemParamByCode[systemParamId ?? ''];

      final enrichedSaleParam = SaleParameterModel(
        id: csp.saleParameterId,
        name: catalogSaleParam.description,
        description: systemParam?.description,
        numberParameter: double.tryParse(
            catalogSaleParam.value?['number_parameter']?.toString() ?? ''),
        taxCode: systemParamId,
        percentageCode: catalogSaleParam.value?['percentage_code'] as String?,
      );

      return ItemTaxModel(
        itemId: tax.itemId,
        idCompanySaleParameter: tax.idCompanySaleParameter,
        companySaleParameter: CompanySaleParameterModel(
          id: csp.id,
          saleParameterId: csp.saleParameterId,
          saleParameter: enrichedSaleParam,
        ),
      );
    }).toList();
  }

  // Resetear el formulario
  void reset() {
    _currentStep = 0;
    _isLoading = false;
    _isEditing = false;
    name = "";
    description = "";
    searchKey = "";
    isService = false;
    state = 'A';
    price = 0.0;
    cost = 0.0;
    discount = 0;
    stock = 0;
    barCode = "";
    qrCode = "";
    image = null;
    imageName = null;
    itemTaxList = [];
    notifyListeners();
  }
}
