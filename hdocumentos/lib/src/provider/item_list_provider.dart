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

  // Eliminar un item
  Future<bool> deleteItem(String itemId) async {
    isLoading = true;

    try {
      // TODO: Llamar al servicio real
      // await ItemService.deleteItem(itemId);

      // Simulación temporal
      await Future.delayed(const Duration(milliseconds: 500));

      _items.removeWhere((item) => item.itemId == itemId);
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
        itemId: "1",
        name: "Laptop HP",
        description: "Laptop HP 15.6 pulgadas, 8GB RAM",
        searchKey: "LAP001",
        price: 899.99,
        cost: 650.00,
        stock: 10,
        barCode: "7501234567890",
        state: 'A',
        isService: 'N',
      ),
      ItemModel(
        itemId: "2",
        name: "Mouse Logitech",
        description: "Mouse inalámbrico Logitech M185",
        searchKey: "MOU001",
        price: 19.99,
        cost: 12.00,
        stock: 50,
        barCode: "7501234567891",
        state: 'A',
        isService: 'N',
      ),
      ItemModel(
        itemId: "3",
        name: "Teclado Mecánico",
        description: "Teclado mecánico RGB",
        searchKey: "TEC001",
        price: 79.99,
        cost: 45.00,
        stock: 25,
        state: 'A',
        isService: 'N',
      ),
      ItemModel(
        itemId: "4",
        name: "Servicio de Instalación",
        description: "Instalación de software y configuración",
        searchKey: "SRV001",
        price: 50.00,
        cost: 0.00,
        stock: 0,
        state: 'A',
        isService: 'Y',
      ),
      ItemModel(
        itemId: "5",
        name: "Monitor Samsung 24\"",
        description: "Monitor LED Full HD",
        searchKey: "MON001",
        price: 179.99,
        cost: 120.00,
        stock: 15,
        state: 'A',
        isService: 'N',
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
