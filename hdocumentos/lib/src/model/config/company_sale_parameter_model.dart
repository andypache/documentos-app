import 'package:hdocumentos/src/model/common/sale_parameter_model.dart';

///Class to represent Company Sale Parameter configuration
class CompanySaleParameterModel {
  String? id;
  String? saleParameterId;
  String? companyId;
  SaleParameterModel? saleParameter;

  //Constructor class
  CompanySaleParameterModel(
      {this.id, this.companyId, this.saleParameterId, this.saleParameter});

  //Create empty company sale parameter
  factory CompanySaleParameterModel.createEmpty() {
    return CompanySaleParameterModel();
  }

  //Load from json response
  factory CompanySaleParameterModel.fromJson(Map<String, dynamic> json) =>
      CompanySaleParameterModel(
          id: json["id"],
          companyId: json["company_id"],
          saleParameterId: json["sale_parameter_id"],
          saleParameter: json["sale_parameter"] != null
              ? SaleParameterModel.fromJson(json["sale_parameter"])
              : null);

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "sale_parameter_id": saleParameterId,
        "sale_parameter": saleParameter?.toJson()
      };
}
