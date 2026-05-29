import 'package:hdocumentos/src/model/model.dart';

class BillItemModel {
  final ItemModel item;
  final int quantity;
  final double unitPrice;
  final double discount;

  BillItemModel({
    required this.item,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
  });

  factory BillItemModel.fromItem({
    required ItemModel item,
    int quantity = 1,
    double? customPrice,
    double? customDiscount,
  }) {
    final unitPrice = customPrice ?? item.pricing?.price ?? 0.0;
    final discount = customDiscount ?? 0.0;

    return BillItemModel(
      item: item,
      quantity: quantity,
      unitPrice: unitPrice,
      discount: discount,
    );
  }

  factory BillItemModel.fromJson(Map<String, dynamic> json) {
    return BillItemModel(
      item: ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item.toJson(),
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discount': discount,
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
    return 'BillItemModel{item: ${item.name}, quantity: $quantity, unitPrice: $unitPrice, discount: $discount}';
  }
}
