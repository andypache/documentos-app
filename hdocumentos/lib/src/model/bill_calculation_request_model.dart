class BillCalculationRequestModel {
  final int? customerId;
  final List<BillCalculationItemModel> items;

  BillCalculationRequestModel({
    this.customerId,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'BillCalculationRequestModel{customerId: $customerId, items: ${items.length}}';
  }
}

class BillCalculationItemModel {
  final int itemId;
  final int quantity;
  final double unitPrice;
  final double discount;

  BillCalculationItemModel({
    required this.itemId,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discount': discount,
    };
  }

  @override
  String toString() {
    return 'BillCalculationItemModel{itemId: $itemId, quantity: $quantity, unitPrice: $unitPrice, discount: $discount}';
  }
}
