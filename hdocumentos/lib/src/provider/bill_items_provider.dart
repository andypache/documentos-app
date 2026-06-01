import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/share/app_logger.dart';

/// Provider especializado para gestionar los items/productos de la factura
/// Responsabilidades:
/// - Mantener la lista de items
/// - Agregar/actualizar/eliminar items
/// - Notificar cambios que requieran recalcular
class BillItemsProvider extends ChangeNotifier {
  // Estado
  final List<BillItemModel> _billItems = [];

  // Callback para notificar que cambiaron los items y se debe recalcular
  VoidCallback? onItemsChanged;

  // Getters
  List<BillItemModel> get billItems => List.unmodifiable(_billItems);
  int get itemCount => _billItems.length;
  bool get hasItems => _billItems.isNotEmpty;

  /// Agregar item a la factura
  void addItem(ItemModel item, {int quantity = 1, double? customPrice}) {
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

    AppLogger.debug('Item agregado/actualizado: ${item.name}',
        tag: 'BillItemsProvider');

    notifyListeners();

    // Notificar que cambiaron los items (para recalcular)
    onItemsChanged?.call();
  }

  /// Actualizar item (precio, descuento, cantidad)
  void updateItem(
    int index, {
    int? quantity,
    double? unitPrice,
    double? discount,
  }) {
    if (index < 0 || index >= _billItems.length) return;

    final currentItem = _billItems[index];
    _billItems[index] = currentItem.copyWith(
      quantity: quantity,
      unitPrice: unitPrice,
      discount: discount,
    );

    AppLogger.debug('Item actualizado en index $index',
        tag: 'BillItemsProvider');

    notifyListeners();

    // Notificar que cambiaron los items (para recalcular)
    onItemsChanged?.call();
  }

  /// Actualizar item directamente con BillItemModel (usado por cálculos del servidor)
  void updateItemModel(int index, BillItemModel updatedItem) {
    if (index < 0 || index >= _billItems.length) return;

    _billItems[index] = updatedItem;
    notifyListeners();
  }

  /// Buscar índice de item por ID
  int findItemIndexById(String itemId) {
    return _billItems.indexWhere((bi) => bi.item.id == itemId);
  }

  /// Eliminar item de la factura
  void removeItem(int index) {
    if (index >= 0 && index < _billItems.length) {
      final removedItem = _billItems[index];
      _billItems.removeAt(index);

      AppLogger.debug('Item removido: ${removedItem.item.name}',
          tag: 'BillItemsProvider');

      notifyListeners();

      // Notificar que cambiaron los items (para recalcular)
      onItemsChanged?.call();
    }
  }

  /// Limpiar todos los items
  void clearItems() {
    _billItems.clear();
    AppLogger.debug('Todos los items limpiados', tag: 'BillItemsProvider');
    notifyListeners();
  }

  /// Validar stock de todos los productos físicos
  String? validateStock() {
    for (var billItem in _billItems) {
      if (billItem.item.isService != 'Y') {
        final stock = billItem.item.stock?.stock ?? 0;
        if (billItem.quantity > stock) {
          return 'Stock insuficiente para ${billItem.item.name}. Disponible: $stock';
        }
      }
    }
    return null; // Todo OK
  }
}
