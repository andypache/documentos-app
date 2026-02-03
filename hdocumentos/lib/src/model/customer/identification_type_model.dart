///Class to represent Customer Identification Type
class IdentificationTypeModel {
  String? identificationTypeId;
  String? name;
  String? description;
  String? inicials;
  String? sriCode;
  int? length;
  String? status; // 'A' or 'I'

  //Constructor class
  IdentificationTypeModel({
    this.identificationTypeId,
    this.name,
    this.description,
    this.inicials,
    this.sriCode,
    this.length,
    this.status,
  });

  //Create empty identification type
  factory IdentificationTypeModel.createEmpty() {
    return IdentificationTypeModel(
      status: 'A',
    );
  }

  //Load from json response
  factory IdentificationTypeModel.fromJson(Map<String, dynamic> json) =>
      IdentificationTypeModel(
        identificationTypeId: json["identification_type_id"],
        name: json["name"],
        description: json["description"],
        inicials: json["inicials"],
        sriCode: json["sri_code"],
        length: json["length"],
        status: json["status"],
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "identification_type_id": identificationTypeId,
        "name": name,
        "description": description,
        "inicials": inicials,
        "sri_code": sriCode,
        "length": length,
        "status": status,
      };
}
