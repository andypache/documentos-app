import 'package:hdocumentos/src/model/config/company_sale_parameter_model.dart';

///Class to represent Item Tax configuration
class ItemTaxModel {
  String? itemId;
  String? idCompanySaleParameter;
  CompanySaleParameterModel? companySaleParameter;

  //Constructor class
  ItemTaxModel({
    this.itemId,
    this.idCompanySaleParameter,
    this.companySaleParameter,
  });

  //Create empty item tax
  factory ItemTaxModel.createEmpty() {
    return ItemTaxModel();
  }

  //Load from json response
  factory ItemTaxModel.fromJson(Map<String, dynamic> json) => ItemTaxModel(
        itemId: json["item_id"],
        idCompanySaleParameter: json["id_company_sale_parameter"],
        companySaleParameter: json["company_sale_parameter"] != null
            ? CompanySaleParameterModel.fromJson(json["company_sale_parameter"])
            : null,
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "id_company_sale_parameter": idCompanySaleParameter,
        "company_sale_parameter": companySaleParameter?.toJson(),
      };
  // Helper methods para acceder a los datos del impuesto
  String get name =>
      companySaleParameter?.saleParameter?.systemParameter?.name ?? 'Impuesto';

  double get percentage =>
      companySaleParameter?.saleParameter?.numberParameter ?? 0.0;
}
