/// Modelo de respuesta de cálculo de venta
class SaleCalculateResponseModel {
  final List<DetailCalculateModel> detailCalculate;
  final TotalCalculateModel totalCalculate;

  SaleCalculateResponseModel({
    required this.detailCalculate,
    required this.totalCalculate,
  });

  factory SaleCalculateResponseModel.fromJson(Map<String, dynamic> json) {
    return SaleCalculateResponseModel(
      detailCalculate: (json['detail_calculate'] as List?)
              ?.map((e) => DetailCalculateModel.fromJson(e))
              .toList() ??
          [],
      totalCalculate:
          TotalCalculateModel.fromJson(json['total_calculate'] ?? {}),
    );
  }
}

/// Modelo de detalle calculado por producto
class DetailCalculateModel {
  final int amount;
  final double cost;
  final String description;
  final double discount;
  final double discountCustomerValue;
  final double discountProductValue;
  final bool inventory;
  final String itemId;
  final String name;
  final double price;
  final double priceFinal;
  final double priceSale;
  final List<SaleTaxDetailModel> taxList;
  final double total;
  final double totalDiscount;

  DetailCalculateModel({
    required this.amount,
    required this.cost,
    required this.description,
    required this.discount,
    required this.discountCustomerValue,
    required this.discountProductValue,
    required this.inventory,
    required this.itemId,
    required this.name,
    required this.price,
    required this.priceFinal,
    required this.priceSale,
    required this.taxList,
    required this.total,
    required this.totalDiscount,
  });

  factory DetailCalculateModel.fromJson(Map<String, dynamic> json) {
    return DetailCalculateModel(
      amount: json['amount'] ?? 0,
      cost: (json['cost'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      discount: (json['discount'] ?? 0).toDouble(),
      discountCustomerValue: (json['discount_customer_value'] ?? 0).toDouble(),
      discountProductValue: (json['discount_product_value'] ?? 0).toDouble(),
      inventory: json['inventory'] ?? false,
      itemId: json['item_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      priceFinal: (json['price_final'] ?? 0).toDouble(),
      priceSale: (json['price_sale'] ?? 0).toDouble(),
      taxList: (json['tax_list'] as List?)
              ?.map((e) => SaleTaxDetailModel.fromJson(e))
              .toList() ??
          [],
      total: (json['total'] ?? 0).toDouble(),
      totalDiscount: (json['total_discount'] ?? 0).toDouble(),
    );
  }
}

/// Modelo de impuesto por producto en venta
class SaleTaxDetailModel {
  final double value;
  final double valueTax;

  SaleTaxDetailModel({
    required this.value,
    required this.valueTax,
  });

  factory SaleTaxDetailModel.fromJson(Map<String, dynamic> json) {
    return SaleTaxDetailModel(
      value: (json['value'] ?? 0).toDouble(),
      valueTax: (json['value_tax'] ?? 0).toDouble(),
    );
  }
}

/// Modelo de totales calculados
class TotalCalculateModel {
  final double discountCustomer;
  final double discountItem;
  final double discountTotal;
  final double discountValue;
  final double subTotal;
  final List<SubTotalTaxModel> subTotalTaxList;
  final double subTotalWithoutTax;
  final double total;
  final double totalTax;

  TotalCalculateModel({
    required this.discountCustomer,
    required this.discountItem,
    required this.discountTotal,
    required this.discountValue,
    required this.subTotal,
    required this.subTotalTaxList,
    required this.subTotalWithoutTax,
    required this.total,
    required this.totalTax,
  });

  factory TotalCalculateModel.fromJson(Map<String, dynamic> json) {
    return TotalCalculateModel(
      discountCustomer: (json['discount_customer'] ?? 0).toDouble(),
      discountItem: (json['discount_item'] ?? 0).toDouble(),
      discountTotal: (json['discount_total'] ?? 0).toDouble(),
      discountValue: (json['discount_value'] ?? 0).toDouble(),
      subTotal: (json['sub_total'] ?? 0).toDouble(),
      subTotalTaxList: (json['sub_total_tax_list'] as List?)
              ?.map((e) => SubTotalTaxModel.fromJson(e))
              .toList() ??
          [],
      subTotalWithoutTax: (json['sub_total_without_tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      totalTax: (json['total_tax'] ?? 0).toDouble(),
    );
  }
}

/// Modelo de subtotal por tipo de impuesto
class SubTotalTaxModel {
  final String companySaleParameterId;
  final String name;
  final double subTotal;
  final double total;
  final double value;

  SubTotalTaxModel({
    required this.companySaleParameterId,
    required this.name,
    required this.subTotal,
    required this.total,
    required this.value,
  });

  factory SubTotalTaxModel.fromJson(Map<String, dynamic> json) {
    return SubTotalTaxModel(
      companySaleParameterId: json['company_sale_parameter_id'] ?? '',
      name: json['name'] ?? '',
      subTotal: (json['sub_total'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      value: (json['value'] ?? 0).toDouble(),
    );
  }
}
