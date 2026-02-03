///Class to represent System Parameter configuration
class SystemParameterModel {
  String? systemParameterId;
  String? name;
  String? description;
  String? companySystemParameter;
  double? numberParameter;
  String? isTaxSale; // 'S' or 'N'
  String? taxCode;
  String? percentageCode;

  //Constructor class
  SystemParameterModel({
    this.systemParameterId,
    this.name,
    this.description,
    this.companySystemParameter,
    this.numberParameter,
    this.isTaxSale,
    this.taxCode,
    this.percentageCode,
  });

  //Create empty system parameter
  factory SystemParameterModel.createEmpty() {
    return SystemParameterModel(
      isTaxSale: 'N',
    );
  }

  //Load from json response
  factory SystemParameterModel.fromJson(Map<String, dynamic> json) =>
      SystemParameterModel(
        systemParameterId: json["system_parameter_id"],
        name: json["name"],
        description: json["description"],
        companySystemParameter: json["company_system_parameter"],
        numberParameter: json["number_parameter"]?.toDouble(),
        isTaxSale: json["is_tax_sale"],
        taxCode: json["tax_code"],
        percentageCode: json["percentage_code"],
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "system_parameter_id": systemParameterId,
        "name": name,
        "description": description,
        "company_system_parameter": companySystemParameter,
        "number_parameter": numberParameter,
        "is_tax_sale": isTaxSale,
        "tax_code": taxCode,
        "percentage_code": percentageCode,
      };
}
