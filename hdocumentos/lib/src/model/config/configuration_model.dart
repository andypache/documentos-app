///Class to management configuration user and company
class ConfigurationModel {
  String? id;
  String? pathImage;
  String? pathCertificate;
  String? email;
  String? passwordCertificate;
  DateTime? certificateExpirationDate;
  int? enviroment;

  //Constructor of class
  ConfigurationModel(
      {this.id,
      this.pathImage,
      this.pathCertificate,
      this.email,
      this.passwordCertificate,
      this.certificateExpirationDate});

  //Create empty model
  factory ConfigurationModel.empty() => ConfigurationModel(
      id: null,
      pathImage: null,
      pathCertificate: null,
      email: null,
      passwordCertificate: null,
      certificateExpirationDate: null);

  //Load from json map
  factory ConfigurationModel.fromJson(Map<String, dynamic> json) =>
      ConfigurationModel(
          id: json["id"],
          pathImage: json["pathImage"],
          pathCertificate: json["pathCertificate"],
          email: json["email"],
          passwordCertificate: json["passwordCertificate"],
          certificateExpirationDate: json["certificateExpirationDate"]);

  //Change to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "pathImage": pathImage,
        "pathCertificate": pathCertificate,
        "email": email,
        "passwordCertificate": passwordCertificate,
        "certificateExpirationDate": certificateExpirationDate
      };
}
