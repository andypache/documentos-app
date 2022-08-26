///Class to represent user session in device
class UserSessionModel {
  //Constructor of required and not required field
  UserSessionModel({
    required this.id,
    required this.username,
    required this.email,
    this.active,
    required this.idCompany,
    required this.identification,
    required this.surnames,
    required this.names,
    this.createdAt,
    this.confirmedAt,
    this.lastLoginAt,
    this.currentLoginAt,
    this.lastLoginIp,
    this.currentLoginIp,
    this.state,
    this.completeName,
  });

  int id;
  String username;
  String email;
  String? active;
  int idCompany;
  String identification;
  String surnames;
  String names;
  String? createdAt;
  String? confirmedAt;
  String? lastLoginAt;
  String? currentLoginAt;
  String? lastLoginIp;
  String? currentLoginIp;
  String? state;
  String? completeName;

  //Load from json response
  factory UserSessionModel.fromJson(Map<String, dynamic> json) =>
      UserSessionModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        active: json["active"],
        identification: json["company"]["identification"],
        idCompany: json["company"]["id"],
        surnames: json["surnames"],
        names: json["names"],
        completeName: json["names"] + " " + json["surnames"],
      );

  //Create object map with property from json
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "active": active,
        "identification": identification,
        "idCompany": idCompany,
        "surnames": surnames,
        "names": names,
        "completeName": completeName,
      };

  //Create object from object map
  factory UserSessionModel.fromJsonObj(Map<String, dynamic> json) =>
      UserSessionModel(
          id: json["id"],
          username: json["username"],
          email: json["email"],
          identification: json["identification"],
          idCompany: json["idCompany"],
          surnames: json["surnames"],
          names: json["names"],
          completeName: json["completeName"]);
}
