import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';

///Provider para gestionar el listado y búsqueda de items
class ItemListProvider extends ChangeNotifier {
  List<ItemModel> _items = [];
  List<ItemModel> _filteredItems = [];
  String _searchQuery = "";
  bool _isLoading = false;
  bool _hasSearched = false;

  // Getters
  List<ItemModel> get items => _filteredItems;
  bool get isLoading => _isLoading;
  bool get hasSearched => _hasSearched;
  String get searchQuery => _searchQuery;
  bool get hasResults => _filteredItems.isNotEmpty;

  // Setter para loading
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Actualizar query de búsqueda
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterItems();
    notifyListeners();
  }

  // Filtrar items localmente
  void _filterItems() {
    if (_searchQuery.isEmpty) {
      _filteredItems = List.from(_items);
    } else {
      final queryLower = _searchQuery.toLowerCase();
      _filteredItems = _items.where((item) {
        final nameLower = item.name.toLowerCase();
        final searchKeyLower = (item.searchKey ?? "").toLowerCase();
        final barCode = item.barCode ?? "";

        return nameLower.contains(queryLower) ||
            searchKeyLower.contains(queryLower) ||
            barCode.contains(queryLower);
      }).toList();
    }
  }

  // Buscar items en el servidor
  Future<void> searchItems(String query) async {
    _searchQuery = query;
    _hasSearched = true;
    isLoading = true;

    try {
      // TODO: Llamar al servicio real
      // final response = await ItemService.searchItems(query);
      // _items = response;

      // Simulación temporal
      await Future.delayed(const Duration(seconds: 1));
      _items = _getMockItems();

      _filterItems();
    } catch (e) {
      _items = [];
      _filteredItems = [];
    } finally {
      isLoading = false;
    }
  }

  // Cargar todos los items
  Future<void> loadAllItems() async {
    _hasSearched = true;
    isLoading = true;

    try {
      // TODO: Llamar al servicio real
      // final response = await ItemService.getAllItems();
      // _items = response;

      // Simulación temporal
      await Future.delayed(const Duration(seconds: 1));
      _items = _getMockItems();

      _filteredItems = List.from(_items);
    } catch (e) {
      _items = [];
      _filteredItems = [];
    } finally {
      isLoading = false;
    }
  }

  // Actualizar precio de un item
  Future<bool> updatePrice(
      String itemId, double newPrice, double newCost) async {
    try {
      // TODO: Llamar al servicio real
      // await ItemService.updatePrice(itemId, newPrice, newCost);

      await Future.delayed(const Duration(milliseconds: 500));
      final index = _items.indexWhere((i) => i.id == itemId);
      if (index != -1) {
        final original = _items[index];
        _items[index] = ItemModel(
          id: original.id,
          name: original.name,
          description: original.description,
          searchKey: original.searchKey,
          isService: original.isService,
          barCode: original.barCode,
          qrCode: original.qrCode,
          state: original.state,
          createdAt: original.createdAt,
          media: original.media,
          stock: original.stock,
          pricing: ItemPricingModel(
            price: newPrice,
            cost: newCost,
            discount: original.pricing?.discount,
          ),
          itemTaxes: original.itemTaxes,
        );
        _filterItems();
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Actualizar stock de un item
  Future<bool> updateStock(String itemId, int newStock) async {
    try {
      // TODO: Llamar al servicio real
      // await ItemService.updateStock(itemId, newStock);

      // Actualizar localmente
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _items.indexWhere((i) => i.id == itemId);
      if (index != -1) {
        final original = _items[index];
        _items[index] = ItemModel(
          id: original.id,
          name: original.name,
          description: original.description,
          searchKey: original.searchKey,
          isService: original.isService,
          barCode: original.barCode,
          qrCode: original.qrCode,
          state: original.state,
          createdAt: original.createdAt,
          media: original.media,
          stock: ItemStockModel(stock: newStock),
          pricing: original.pricing,
          itemTaxes: original.itemTaxes,
        );
        _filterItems();
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Eliminar un item
  Future<bool> deleteItem(String itemId) async {
    isLoading = true;

    try {
      // TODO: Llamar al servicio real
      // await ItemService.deleteItem(itemId);

      // Simulación temporal
      await Future.delayed(const Duration(milliseconds: 500));

      _items.removeWhere((item) => item.id == itemId);
      _filterItems();
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  // Limpiar búsqueda
  void clearSearch() {
    _searchQuery = "";
    _items = [];
    _filteredItems = [];
    _hasSearched = false;
    notifyListeners();
  }

  // Datos de prueba
  List<ItemModel> _getMockItems() {
    return [
      ItemModel(
        id: "1",
        name: "Laptop HP",
        description: "Laptop HP 15.6 pulgadas, 8GB RAM",
        searchKey: "LAP001",
        barCode: "7501234567890",
        state: 'A',
        isService: 'N',
        pricing: ItemPricingModel(price: 899.99, cost: 650.00, discount: 0),
        stock: ItemStockModel(stock: 10),
      ),
      ItemModel(
        id: "2",
        name: "Mouse Logitech",
        description: "Mouse inalámbrico Logitech M185",
        searchKey: "MOU001",
        barCode: "7501234567891",
        state: 'A',
        isService: 'N',
        pricing: ItemPricingModel(price: 19.99, cost: 12.00, discount: 0),
        stock: ItemStockModel(stock: 50),
      ),
      ItemModel(
        id: "3",
        name: "Teclado Mecánico",
        description: "Teclado mecánico RGB",
        searchKey: "TEC001",
        state: 'A',
        isService: 'N',
        pricing: ItemPricingModel(price: 79.99, cost: 45.00, discount: 0),
        stock: ItemStockModel(stock: 25),
      ),
      ItemModel(
        id: "4",
        name: "Servicio de Instalación",
        description: "Instalación de software y configuración",
        searchKey: "SRV001",
        state: 'A',
        isService: 'Y',
        pricing: ItemPricingModel(price: 50.00, cost: 0.00, discount: 0),
        stock: ItemStockModel(stock: 0),
      ),
      ItemModel(
        id: "5",
        name: 'Monitor Samsung 24"',
        description: "Monitor LED Full HD",
        searchKey: "MON001",
        state: 'A',
        isService: 'N',
        pricing: ItemPricingModel(price: 179.99, cost: 120.00, discount: 0),
        stock: ItemStockModel(stock: 15),
      ),
    ];
  }

  // Resetear provider
  void reset() {
    _items = [];
    _filteredItems = [];
    _searchQuery = "";
    _isLoading = false;
    _hasSearched = false;
    notifyListeners();
  }
}
