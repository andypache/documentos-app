class CatalogModel {
  String code;
  String description;
  dynamic value;

  CatalogModel({required this.code, required this.description, this.value});

  factory CatalogModel.fromJson(Map<String, dynamic> json) {
    return CatalogModel(
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      value: json['value'],
    );
  }
}

class CatalogModelList {
  List<CatalogModel> documentTypes;
  List<CatalogModel> identificationTypes;
  List<CatalogModel> paymentMethods;
  List<CatalogModel> saleParameters;
  List<CatalogModel> systemParameters;

  CatalogModelList(
      {this.documentTypes = const [],
      this.identificationTypes = const [],
      this.paymentMethods = const [],
      this.saleParameters = const [],
      this.systemParameters = const []});

  factory CatalogModelList.fromJson(Map<String, dynamic> json) {
    return CatalogModelList(
      identificationTypes: (json['identification_types'] as List<dynamic>?)
              ?.map((item) => CatalogModel.fromJson(item))
              .toList() ??
          [],
      documentTypes: (json['document_types'] as List<dynamic>?)
              ?.map((item) => CatalogModel.fromJson(item))
              .toList() ??
          [],
      paymentMethods: (json['payment_methods'] as List<dynamic>?)
              ?.map((item) => CatalogModel.fromJson(item))
              .toList() ??
          [],
      saleParameters: (json['sale_parameters'] as List<dynamic>?)
              ?.map((item) => CatalogModel.fromJson(item))
              .toList() ??
          [],
      systemParameters: (json['system_parameters'] as List<dynamic>?)
              ?.map((item) => CatalogModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
