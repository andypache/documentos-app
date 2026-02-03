///Class to represent user session in device
class UserSessionModel {
  //Constructor of required and not required field
  UserSessionModel({
    required this.userId,
    required this.username,
    required this.email,
    this.active,
    required this.idCompany,
    required this.identification,
    required this.surnames,
    required this.names,
    this.keepSession,
    this.createdAt,
    this.confirmedAt,
    this.lastLoginAt,
    this.currentLoginAt,
    this.lastLoginIp,
    this.currentLoginIp,
    this.state,
    this.completeName,
  });

  String userId;
  String username;
  String email;
  String? active;
  int idCompany;
  String identification;
  String surnames;
  String names;
  bool? keepSession;
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
        userId: json["user_id"],
        username: json["username"],
        email: json["email"],
        active: json["active"],
        identification:
            json.containsKey("identification") ? json["identification"] : "",
        idCompany: json.containsKey("company_id") ? json["company_id"] : 0,
        surnames: json["last_name"],
        names: json["first_name"],
        completeName: json["first_name"] + " " + json["last_name"],
      );

  //Create object map with property from json
  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "email": email,
        "active": active,
        "identification": identification,
        "idCompany": idCompany,
        "surnames": surnames,
        "names": names,
        "keepSession": keepSession,
        "completeName": completeName,
      };

  //Create object from object map
  factory UserSessionModel.fromJsonObj(Map<String, dynamic> json) =>
      UserSessionModel(
          userId: json["user_id"],
          username: json["username"],
          email: json["email"],
          identification: json["identification"],
          idCompany: json["idCompany"],
          surnames: json["surnames"],
          names: json["names"],
          completeName: json["completeName"]);
}
