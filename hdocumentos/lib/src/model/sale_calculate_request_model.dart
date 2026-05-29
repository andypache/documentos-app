/// Modelo de request para cálculo de venta
class SaleCalculateRequestModel {
  final String companyId;
  final SearchCustomerModel? searchCustomer;
  final List<DataForSaleDetailModel> dataForSaleDetails;

  SaleCalculateRequestModel({
    required this.companyId,
    this.searchCustomer,
    required this.dataForSaleDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      if (searchCustomer != null) 'search_customer': searchCustomer!.toJson(),
      'data_for_sale_details':
          dataForSaleDetails.map((e) => e.toJson()).toList(),
    };
  }
}

/// Modelo de búsqueda de cliente
class SearchCustomerModel {
  final String companyId;
  final bool notData;
  final String identification;

  SearchCustomerModel({
    required this.companyId,
    required this.notData,
    required this.identification,
  });

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'not_data': notData,
      'identification': identification,
    };
  }
}

/// Modelo de detalle de producto para venta
class DataForSaleDetailModel {
  final String companyId;
  final String id;
  final int amount;
  final double adminItemDiscount;
  final bool inventory;

  DataForSaleDetailModel({
    required this.companyId,
    required this.id,
    required this.amount,
    required this.adminItemDiscount,
    required this.inventory,
  });

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'id': id,
      'amount': amount,
      'admin_item_discount': adminItemDiscount,
      'inventory': inventory,
    };
  }
}
