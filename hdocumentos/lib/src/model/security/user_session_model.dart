import 'package:hdocumentos/src/model/model.dart';

///Class to represent user session in device
class UserSessionModel {
  //Constructor of required and not required field
  UserSessionModel(
      {required this.userId,
      required this.username,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.fullName,
      this.company,
      this.keepSession});

  String userId;
  String username;
  String email;
  String firstName;
  String lastName;
  String fullName;
  CompanyModel? company;
  bool? keepSession;

  /// Crea un [UserSessionModel] vacío (usuario no autenticado).
  factory UserSessionModel.empty() => UserSessionModel(
        userId: '0',
        username: '',
        email: '',
        firstName: '',
        lastName: '',
        fullName: '',
        company: null,
        keepSession: false,
      );

  /// Retorna true si la compañia está configurada en la sesión
  bool get hasCompany =>
      company != null &&
      company!.businessName!.isNotEmpty &&
      company!.companyId!.isNotEmpty;

  //Load from json response
  factory UserSessionModel.fromJson(Map<String, dynamic> json) =>
      UserSessionModel(
        userId: json["user_id"],
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        fullName: json["full_name"],
        company: json["company"] != null
            ? CompanyModel.fromJson(json["company"])
            : null,
        keepSession: json["keep_session"],
      );

  //Create object map with property from json
  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "full_name": fullName,
        "company": company?.toJson(),
        "keep_session": keepSession,
      };

  //Create object from object map
  factory UserSessionModel.fromJsonObj(Map<String, dynamic> json) =>
      UserSessionModel(
          userId: json["user_id"],
          username: json["username"],
          email: json["email"],
          firstName: json["first_name"],
          lastName: json["last_name"],
          fullName: json["full_name"],
          company: json["company"] != null
              ? CompanyModel.fromJson(json["company"])
              : null,
          keepSession: json["keep_session"]);
}
