import 'package:hdocumentos/src/model/common/system_parameter_model.dart';

///Class to represent System Parameter configuration
class SaleParameterModel {
  String? id;
  String? systemParameterId;
  String? name;
  String? description;
  SystemParameterModel? systemParameter;
  double? numberParameter;
  DateTime? dateParameter;
  String? stringParameter;
  DateTime? initialDateValidity;
  DateTime? finalDateValidity;
  String? taxCode;
  String? percentageCode;

  //Constructor class
  SaleParameterModel(
      {this.id,
      this.systemParameterId,
      this.name,
      this.description,
      this.systemParameter,
      this.numberParameter,
      this.dateParameter,
      this.stringParameter,
      this.initialDateValidity,
      this.finalDateValidity,
      this.taxCode,
      this.percentageCode});

  //Create empty system parameter
  factory SaleParameterModel.createEmpty() {
    return SaleParameterModel();
  }

  //Load from json response
  factory SaleParameterModel.fromJson(Map<String, dynamic> json) =>
      SaleParameterModel(
        id: json["id"],
        systemParameterId: json["system_parameter_id"],
        name: json["name"],
        description: json["description"],
        systemParameter: json["system_parameter"] != null
            ? SystemParameterModel.fromJson(json["system_parameter"])
            : null,
        numberParameter: json["number_parameter"]?.toDouble(),
        dateParameter: json["date_parameter"] != null
            ? DateTime.parse(json["date_parameter"])
            : null,
        stringParameter: json["string_parameter"],
        initialDateValidity: json["initial_date_validity"] != null
            ? DateTime.parse(json["initial_date_validity"])
            : null,
        finalDateValidity: json["final_date_validity"] != null
            ? DateTime.parse(json["final_date_validity"])
            : null,
        taxCode: json["tax_code"],
        percentageCode: json["percentage_code"],
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "system_parameter_id": systemParameterId,
        "name": name,
        "description": description,
        "system_parameter": systemParameter?.toJson(),
        "number_parameter": numberParameter,
        "date_parameter": dateParameter?.toIso8601String(),
        "string_parameter": stringParameter,
        "initial_date_validity": initialDateValidity?.toIso8601String(),
        "final_date_validity": finalDateValidity?.toIso8601String(),
        "tax_code": taxCode,
        "percentage_code": percentageCode,
      };
}
