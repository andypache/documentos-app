import 'package:hdocumentos/src/model/model.dart';

class BillItemModel {
  final ItemModel item;
  final int quantity;
  final double unitPrice;
  final double discount;
  final double subtotal;
  final double totalTax;
  final double total;

  BillItemModel({
    required this.item,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
    required this.subtotal,
    required this.totalTax,
    required this.total,
  });

  factory BillItemModel.fromItem({
    required ItemModel item,
    int quantity = 1,
    double? customPrice,
    double? customDiscount,
  }) {
    final unitPrice = customPrice ?? item.price ?? 0.0;
    final discount = customDiscount ?? 0.0;
    final subtotal = (unitPrice * quantity) - discount;

    // Calcular impuestos
    double totalTax = 0.0;
    if (item.itemTaxList != null) {
      for (var tax in item.itemTaxList!) {
        totalTax += subtotal * (tax.percentage / 100);
      }
    }

    final total = subtotal + totalTax;

    return BillItemModel(
      item: item,
      quantity: quantity,
      unitPrice: unitPrice,
      discount: discount,
      subtotal: subtotal,
      totalTax: totalTax,
      total: total,
    );
  }

  factory BillItemModel.fromJson(Map<String, dynamic> json) {
    return BillItemModel(
      item: ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num).toDouble(),
      totalTax: (json['totalTax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item.toJson(),
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discount': discount,
      'subtotal': subtotal,
      'totalTax': totalTax,
      'total': total,
    };
  }

  BillItemModel copyWith({
    ItemModel? item,
    int? quantity,
    double? unitPrice,
    double? discount,
  }) {
    return BillItemModel.fromItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      customPrice: unitPrice ?? this.unitPrice,
      customDiscount: discount ?? this.discount,
    );
  }

  @override
  String toString() {
    return 'BillItemModel{item: ${item.name}, quantity: $quantity, unitPrice: $unitPrice, discount: $discount, total: $total}';
  }
}
