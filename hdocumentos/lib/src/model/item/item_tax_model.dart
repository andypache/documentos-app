import 'package:hdocumentos/src/model/item/company_system_parameter_model.dart';

///Class to represent Item Tax configuration
class ItemTaxModel {
  String? iteTaxId;
  String? idCompanySystemParameter;
  CompanySystemParameterModel? companySystemParameter;

  //Constructor class
  ItemTaxModel({
    this.iteTaxId,
    this.idCompanySystemParameter,
    this.companySystemParameter,
  });

  //Create empty item tax
  factory ItemTaxModel.createEmpty() {
    return ItemTaxModel();
  }

  //Load from json response
  factory ItemTaxModel.fromJson(Map<String, dynamic> json) => ItemTaxModel(
        iteTaxId: json["ite_tax_id"],
        idCompanySystemParameter: json["id_company_system_parameter"],
        companySystemParameter: json["company_system_parameter"] != null
            ? CompanySystemParameterModel.fromJson(
                json["company_system_parameter"])
            : null,
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "ite_tax_id": iteTaxId,
        "id_company_system_parameter": idCompanySystemParameter,
        "company_system_parameter": companySystemParameter?.toJson(),
      };

  // Helper methods para acceder a los datos del impuesto
  String get name =>
      companySystemParameter?.systemParameter?.name ?? 'Impuesto';

  double get percentage => companySystemParameter?.numberParameter ?? 0.0;
}
