import 'dart:typed_data';

/// Enum para el estado de la compañia
enum CompanyState { A, I }

/// Modelo de datos de la compañia
class CompanyModel {
  // Identificación
  String? identificationTypeId;
  String? identificationTypeName;
  String? identification;
  String? businessName;
  String? address;
  String? phone;
  String? email;
  CompanyState? state;

  // Logo y sitio web
  Uint8List? logo;
  String? logoPath;
  String? website;
  double? maxDiscount;
  String? itemAddress;

  // Certificado
  Uint8List? certificate;
  String? certificatePath;
  String? certificateUser;
  String? certificatePassword;
  DateTime? certificateExpirationDate;

  // Configuración de correo
  String? mailServer;
  String? mailPort;
  String? mailAddress;
  String? mailUser;
  String? mailPassword;

  // Punto de emisión
  String? documentTypeId;
  String? documentTypeName;
  String? establishmentCode;
  String? emissionPointCode;
  int? currentSequential;
  String? description;
  bool? isActive;

  // Grupos de impuesto habilitados (IVA, ICE, IRBPNR, ISD)
  List<String> taxGroupCodes;

  CompanyModel({
    this.identificationTypeId,
    this.identificationTypeName,
    this.identification,
    this.businessName,
    this.address,
    this.phone,
    this.email,
    this.state,
    this.logo,
    this.logoPath,
    this.website,
    this.maxDiscount,
    this.itemAddress,
    this.certificate,
    this.certificatePath,
    this.certificateUser,
    this.certificatePassword,
    this.certificateExpirationDate,
    this.mailServer,
    this.mailPort,
    this.mailAddress,
    this.mailUser,
    this.mailPassword,
    this.documentTypeId,
    this.documentTypeName,
    this.establishmentCode,
    this.emissionPointCode,
    this.currentSequential,
    this.description,
    this.isActive,
    this.taxGroupCodes = const [],
  });

  /// Compañia vacía para creación
  factory CompanyModel.empty() => CompanyModel(
        state: CompanyState.A,
        currentSequential: 1,
        isActive: true,
        taxGroupCodes: [],
      );

  /// Carga desde la sesión del usuario (sin claves ni archivos)
  factory CompanyModel.fromSession(Map<String, dynamic> session) =>
      CompanyModel(
        identificationTypeId: session['company_identification_type_id'],
        identificationTypeName: session['company_identification_type_name'],
        identification: session['company_identification'],
        businessName: session['company_name'],
        address: session['company_address'],
        phone: session['company_phone'],
        email: session['company_email'],
        state:
            session['company_state'] == 'A' ? CompanyState.A : CompanyState.I,
        logoPath: session['company_logo_url'],
        website: session['company_website'],
        maxDiscount: session['company_max_discount'] != null
            ? double.tryParse(session['company_max_discount'].toString())
            : null,
        itemAddress: session['company_item_address'],
        documentTypeId: session['document_type_id'],
        documentTypeName: session['document_type_name'],
        establishmentCode: session['establishment_code'],
        emissionPointCode: session['emission_point_code'],
        currentSequential: session['current_sequential'] ?? 1,
        description: session['emission_description'],
        isActive: session['emission_is_active'] ?? true,
        // certificados y claves NO se cargan desde sesión
      );

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        identificationTypeId: json['identification_type_id'],
        identificationTypeName: json['identification_type_name'],
        identification: json['identification'],
        businessName: json['business_name'],
        address: json['address'],
        phone: json['phone'],
        email: json['email'],
        state: json['state'] == 'A' ? CompanyState.A : CompanyState.I,
        website: json['website'],
        maxDiscount: json['max_discount'] != null
            ? double.tryParse(json['max_discount'].toString())
            : null,
        itemAddress: json['item_address'],
        certificateUser: json['certificate_user'],
        certificateExpirationDate: json['certificate_expiration_date'] != null
            ? DateTime.tryParse(json['certificate_expiration_date'])
            : null,
        mailServer: json['mail_server'],
        mailPort: json['mail_port'],
        mailAddress: json['mail_address'],
        mailUser: json['mail_user'],
        documentTypeId: json['document_type_id'],
        documentTypeName: json['document_type_name'],
        establishmentCode: json['establishment_code'],
        emissionPointCode: json['emission_point_code'],
        currentSequential: json['current_sequential'] ?? 1,
        description: json['description'],
        isActive: json['is_active'] ?? true,
        taxGroupCodes: (json['tax_group_codes'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'identification_type_id': identificationTypeId,
        'identification': identification,
        'business_name': businessName,
        'address': address,
        'phone': phone,
        'email': email,
        'state': state == CompanyState.A ? 'A' : 'I',
        'website': website,
        'max_discount': maxDiscount,
        'item_address': itemAddress,
        'certificate_user': certificateUser,
        'certificate_password': certificatePassword,
        'certificate_expiration_date':
            certificateExpirationDate?.toIso8601String(),
        'mail_server': mailServer,
        'mail_port': mailPort,
        'mail_address': mailAddress,
        'mail_user': mailUser,
        'mail_password': mailPassword,
        'document_type_id': documentTypeId,
        'establishment_code': establishmentCode,
        'emission_point_code': emissionPointCode,
        'current_sequential': currentSequential,
        'description': description,
        'is_active': isActive,
        'tax_group_codes': taxGroupCodes,
      };
}
