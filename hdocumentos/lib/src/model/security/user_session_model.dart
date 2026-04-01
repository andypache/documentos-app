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
    this.companyName,
    this.companyIdentification,
    // Company extended fields
    this.companyIdentificationTypeId,
    this.companyIdentificationTypeName,
    this.companyAddress,
    this.companyPhone,
    this.companyEmail,
    this.companyState,
    this.companyLogoUrl,
    this.companyWebsite,
    this.companyMaxDiscount,
    this.companyItemAddress,
    // Emission point fields
    this.documentTypeId,
    this.documentTypeName,
    this.establishmentCode,
    this.emissionPointCode,
    this.currentSequential,
    this.emissionDescription,
    this.emissionIsActive,
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
  String? companyName;
  String? companyIdentification;

  // Company extended fields
  String? companyIdentificationTypeId;
  String? companyIdentificationTypeName;
  String? companyAddress;
  String? companyPhone;
  String? companyEmail;
  String? companyState;
  String? companyLogoUrl;
  String? companyWebsite;
  double? companyMaxDiscount;
  String? companyItemAddress;

  // Emission point fields
  String? documentTypeId;
  String? documentTypeName;
  String? establishmentCode;
  String? emissionPointCode;
  int? currentSequential;
  String? emissionDescription;
  bool? emissionIsActive;

  /// Crea un [UserSessionModel] vacío (usuario no autenticado).
  factory UserSessionModel.empty() => UserSessionModel(
        userId: '0',
        username: '',
        email: '',
        identification: '',
        idCompany: 0,
        surnames: '',
        names: '',
      );

  /// Retorna true si la compañia está configurada en la sesión
  bool get hasCompany =>
      companyName != null && companyName!.isNotEmpty && idCompany > 0;

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
        companyName: json["company_name"],
        companyIdentification: json["company_identification"],
        companyIdentificationTypeId: json["company_identification_type_id"],
        companyIdentificationTypeName: json["company_identification_type_name"],
        companyAddress: json["company_address"],
        companyPhone: json["company_phone"],
        companyEmail: json["company_email"],
        companyState: json["company_state"],
        companyLogoUrl: json["company_logo_url"],
        companyWebsite: json["company_website"],
        companyMaxDiscount: json["company_max_discount"] != null
            ? double.tryParse(json["company_max_discount"].toString())
            : null,
        companyItemAddress: json["company_item_address"],
        documentTypeId: json["document_type_id"],
        documentTypeName: json["document_type_name"],
        establishmentCode: json["establishment_code"],
        emissionPointCode: json["emission_point_code"],
        currentSequential: json["current_sequential"],
        emissionDescription: json["emission_description"],
        emissionIsActive: json["emission_is_active"],
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
        "companyName": companyName,
        "companyIdentification": companyIdentification,
        "company_identification_type_id": companyIdentificationTypeId,
        "company_identification_type_name": companyIdentificationTypeName,
        "company_address": companyAddress,
        "company_phone": companyPhone,
        "company_email": companyEmail,
        "company_state": companyState,
        "company_logo_url": companyLogoUrl,
        "company_website": companyWebsite,
        "company_max_discount": companyMaxDiscount,
        "company_item_address": companyItemAddress,
        "document_type_id": documentTypeId,
        "document_type_name": documentTypeName,
        "establishment_code": establishmentCode,
        "emission_point_code": emissionPointCode,
        "current_sequential": currentSequential,
        "emission_description": emissionDescription,
        "emission_is_active": emissionIsActive,
      };

  //Create object from object map
  factory UserSessionModel.fromJsonObj(
          Map<String, dynamic> json) =>
      UserSessionModel(
          userId: json["user_id"],
          username: json["username"],
          email: json["email"],
          identification: json["identification"],
          idCompany: json["idCompany"],
          surnames: json["surnames"],
          names: json["names"],
          completeName: json["completeName"],
          companyName: json["companyName"],
          companyIdentification: json["companyIdentification"],
          companyIdentificationTypeId: json["company_identification_type_id"],
          companyIdentificationTypeName:
              json["company_identification_type_name"],
          companyAddress: json["company_address"],
          companyPhone: json["company_phone"],
          companyEmail: json["company_email"],
          companyState: json["company_state"],
          companyLogoUrl: json["company_logo_url"],
          companyWebsite: json["company_website"],
          companyMaxDiscount: json["company_max_discount"] != null
              ? double.tryParse(json["company_max_discount"].toString())
              : null,
          companyItemAddress: json["company_item_address"],
          documentTypeId: json["document_type_id"],
          documentTypeName: json["document_type_name"],
          establishmentCode: json["establishment_code"],
          emissionPointCode: json["emission_point_code"],
          currentSequential: json["current_sequential"],
          emissionDescription: json["emission_description"],
          emissionIsActive: json["emission_is_active"]);
}
