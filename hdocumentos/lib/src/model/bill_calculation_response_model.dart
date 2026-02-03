class BillCalculationResponseModel {
  final double subtotal;
  final double customerDiscount;
  final double totalTax;
  final double total;
  final List<BillCalculationItemResponseModel> items;
  final CustomerDiscountInfoModel? customerDiscountInfo;

  BillCalculationResponseModel({
    required this.subtotal,
    required this.customerDiscount,
    required this.totalTax,
    required this.total,
    required this.items,
    this.customerDiscountInfo,
  });

  factory BillCalculationResponseModel.fromJson(Map<String, dynamic> json) {
    return BillCalculationResponseModel(
      subtotal: (json['subtotal'] as num).toDouble(),
      customerDiscount: (json['customerDiscount'] as num?)?.toDouble() ?? 0.0,
      totalTax: (json['totalTax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((item) => BillCalculationItemResponseModel.fromJson(
              item as Map<String, dynamic>))
          .toList(),
      customerDiscountInfo: json['customerDiscountInfo'] != null
          ? CustomerDiscountInfoModel.fromJson(
              json['customerDiscountInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toString() {
    return 'BillCalculationResponseModel{subtotal: $subtotal, customerDiscount: $customerDiscount, totalTax: $totalTax, total: $total, items: ${items.length}}';
  }
}

class BillCalculationItemResponseModel {
  final int itemId;
  final double subtotal;
  final double totalTax;
  final double total;
  final List<TaxDetailModel> taxes;

  BillCalculationItemResponseModel({
    required this.itemId,
    required this.subtotal,
    required this.totalTax,
    required this.total,
    required this.taxes,
  });

  factory BillCalculationItemResponseModel.fromJson(Map<String, dynamic> json) {
    return BillCalculationItemResponseModel(
      itemId: json['itemId'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
      totalTax: (json['totalTax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      taxes: (json['taxes'] as List<dynamic>?)
              ?.map(
                  (tax) => TaxDetailModel.fromJson(tax as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'BillCalculationItemResponseModel{itemId: $itemId, subtotal: $subtotal, totalTax: $totalTax, total: $total}';
  }
}

class TaxDetailModel {
  final String name;
  final double percentage;
  final double amount;

  TaxDetailModel({
    required this.name,
    required this.percentage,
    required this.amount,
  });

  factory TaxDetailModel.fromJson(Map<String, dynamic> json) {
    return TaxDetailModel(
      name: json['name'] as String,
      percentage: (json['percentage'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'TaxDetailModel{name: $name, percentage: $percentage%, amount: $amount}';
  }
}

class CustomerDiscountInfoModel {
  final double percentage;
  final double amount;
  final String description;

  CustomerDiscountInfoModel({
    required this.percentage,
    required this.amount,
    this.description = '',
  });

  factory CustomerDiscountInfoModel.fromJson(Map<String, dynamic> json) {
    return CustomerDiscountInfoModel(
      percentage: (json['percentage'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'CustomerDiscountInfoModel{percentage: $percentage%, amount: $amount, description: $description}';
  }
}
