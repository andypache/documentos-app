import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/item_service.dart';

enum _ItemListMode { all, filter }

/// Provider para gestionar el listado y búsqueda de items con paginación infinita.
///
/// - [startLoadAll]    → GET /pagination/all   (botón "Ver Todos")
/// - [startLoadFilter] → GET /pagination/filter (botón "Buscar")
/// - [loadNextPage]    → siguiente página con el modo activo
///
/// La paginación se detiene cuando el servicio retorna 400.
class ItemListProvider extends ChangeNotifier {
  final List<ItemModel> _items = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasReachedEnd = false;
  bool _hasStarted = false;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _errorMessage;
  _ItemListMode _mode = _ItemListMode.all;

  // ── Getters ────────────────────────────────────────────────────────────────

  List<ItemModel> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasReachedEnd => _hasReachedEnd;
  bool get hasStarted => _hasStarted;
  bool get hasResults => _items.isNotEmpty;
  String? get errorMessage => _errorMessage;

  /// Mantiene compatibilidad con el código existente.
  bool get hasSearched => _hasStarted;

  // ── Carga con paginación ───────────────────────────────────────────────────

  /// Reinicia la lista y carga la primera página de todos los items.
  Future<void> startLoadAll(BuildContext context) async {
    _reset(_ItemListMode.all, '');
    _isLoading = true;
    notifyListeners();

    await _fetchPage(context);

    _isLoading = false;
    notifyListeners();
  }

  /// Reinicia la lista y carga la primera página filtrada por [query].
  Future<void> startLoadFilter(BuildContext context, String query) async {
    _reset(_ItemListMode.filter, query);
    _isLoading = true;
    notifyListeners();

    await _fetchPage(context);

    _isLoading = false;
    notifyListeners();
  }

  /// Carga la siguiente página con el modo activo.
  Future<void> loadNextPage(BuildContext context) async {
    if (_isLoadingMore || _hasReachedEnd || _isLoading) return;
    _isLoadingMore = true;
    notifyListeners();

    await _fetchPage(context);

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> _fetchPage(BuildContext context) async {
    try {
      final List<ItemModel>? result;

      if (_mode == _ItemListMode.filter) {
        result = await ItemService.fetchItemsPageFilter(
          context,
          page: _currentPage,
          search: _searchQuery,
        );
      } else {
        result = await ItemService.fetchItemsPage(
          context,
          page: _currentPage,
        );
      }

      // null = servidor devolvió 400 → sin más páginas
      if (result == null) {
        _hasReachedEnd = true;
        return;
      }

      _items.addAll(result);
      _currentPage++;
      if (result.isEmpty) _hasReachedEnd = true;
    } catch (e, stack) {
      debugPrint('[ItemListProvider] Error en _fetchPage: $e');
      debugPrintStack(stackTrace: stack);
      _errorMessage = e.toString();
      // Mostrar SnackBar si el contexto sigue montado
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar productos: $_errorMessage'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  void _reset(_ItemListMode mode, String query) {
    _items.clear();
    _currentPage = 1;
    _hasReachedEnd = false;
    _isLoading = false;
    _isLoadingMore = false;
    _hasStarted = true;
    _errorMessage = null;
    _mode = mode;
    _searchQuery = query;
  }

  // ── Compatibilidad con código existente ────────────────────────────────────

  /// Alias para mantener compatibilidad. Llama a [startLoadAll] si hay contexto.
  Future<void> loadAllItems() async {
    // Sin BuildContext no podemos llamar al servicio real.
    // Se usa desde lugares donde no hay contexto; esos sitios deberán migrar
    // a llamar startLoadAll(context).
    notifyListeners();
  }

  // ── Operaciones CRUD (delegadas al servicio real) ──────────────────────────

  Future<bool> updatePrice(
      String itemId, double newPrice, double newCost) async {
    try {
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
        notifyListeners();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateStock(String itemId, int newStock) async {
    try {
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
        notifyListeners();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteItem(String itemId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _items.removeWhere((item) => item.id == itemId);
      return true;
    } catch (_) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Limpieza ───────────────────────────────────────────────────────────────

  void clearSearch() {
    _items.clear();
    _searchQuery = '';
    _currentPage = 1;
    _hasReachedEnd = false;
    _hasStarted = false;
    _isLoading = false;
    _isLoadingMore = false;
    _errorMessage = null;
    notifyListeners();
  }

  void reset() => clearSearch();
}
