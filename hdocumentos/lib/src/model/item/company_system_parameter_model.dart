import 'package:hdocumentos/src/model/item/system_parameter_model.dart';

///Class to represent Company System Parameter configuration
class CompanySystemParameterModel {
  String? companySystemParameterId;
  String? companyId;
  String? systemParameterId;
  SystemParameterModel? systemParameter;
  double? numberParameter;
  DateTime? dateParameter;
  String? stringParameter;
  String? isTaxSale; // 'Y' or 'N'
  String? taxCode;
  String? percentageCode;

  //Constructor class
  CompanySystemParameterModel({
    this.companySystemParameterId,
    this.companyId,
    this.systemParameterId,
    this.systemParameter,
    this.numberParameter,
    this.dateParameter,
    this.stringParameter,
    this.isTaxSale,
    this.taxCode,
    this.percentageCode,
  });

  //Create empty company system parameter
  factory CompanySystemParameterModel.createEmpty() {
    return CompanySystemParameterModel(
      isTaxSale: 'N',
    );
  }

  //Load from json response
  factory CompanySystemParameterModel.fromJson(Map<String, dynamic> json) =>
      CompanySystemParameterModel(
        companySystemParameterId: json["company_system_parameter_id"],
        companyId: json["company_id"],
        systemParameterId: json["system_parameter_id"],
        systemParameter: json["system_parameter"] != null
            ? SystemParameterModel.fromJson(json["system_parameter"])
            : null,
        numberParameter: json["number_parameter"]?.toDouble(),
        dateParameter: json["date_parameter"] != null
            ? DateTime.parse(json["date_parameter"])
            : null,
        stringParameter: json["string_parameter"],
        isTaxSale: json["is_tax_sale"],
        taxCode: json["tax_code"],
        percentageCode: json["percentage_code"],
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "company_system_parameter_id": companySystemParameterId,
        "company_id": companyId,
        "system_parameter_id": systemParameterId,
        "system_parameter": systemParameter?.toJson(),
        "number_parameter": numberParameter,
        "date_parameter": dateParameter?.toIso8601String(),
        "string_parameter": stringParameter,
        "is_tax_sale": isTaxSale,
        "tax_code": taxCode,
        "percentage_code": percentageCode,
      };
}
