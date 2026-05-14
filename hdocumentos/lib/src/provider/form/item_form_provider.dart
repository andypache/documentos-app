import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';

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
  void loadItem(ItemModel existingItem) {
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
    itemTaxList = existingItem.itemTaxes ?? [];
    notifyListeners();
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
