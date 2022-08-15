///Class to represent user session in movile
class UserSession {
  //Constructor of required and not required field
  UserSession({
    required this.id,
    required this.username,
    required this.email,
    this.active,
    required this.identification,
    required this.lastname,
    required this.surname,
    required this.name,
    this.createdAt,
    this.confirmedAt,
    this.lastLoginAt,
    this.currentLoginAt,
    this.lastLoginIp,
    this.currentLoginIp,
    this.state,
    this.completeName,
  });

  String id;
  String username;
  String email;
  String? active;
  String identification;
  String lastname;
  String surname;
  String name;
  String? createdAt;
  String? confirmedAt;
  String? lastLoginAt;
  String? currentLoginAt;
  String? lastLoginIp;
  String? currentLoginIp;
  String? state;
  String? completeName;

  //Load from json response
  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        active: json["active"],
        identification: json["identification"],
        lastname: json["last_name"],
        surname: json["sur_name"],
        name: json["name"],
        completeName:
            json["name"] + " " + json["sur_name"] + " " + json["last_name"],
      );

  //Create object map with property from json
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "active": active,
        "identification": identification,
        "lastname": lastname,
        "surname": surname,
        "name": name,
        "completeName": completeName,
      };

  //Create object from object map
  factory UserSession.fromJsonObj(Map<String, dynamic> json) => UserSession(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      identification: json["identification"],
      lastname: json["lastname"],
      surname: json["surname"],
      name: json["name"],
      completeName: json["completeName"]);
}
