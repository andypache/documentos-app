import 'dart:typed_data';

// ─── Sub-modelos ──────────────────────────────────────────────────────────────

/// Certificado digital de la empresa
class CompanyCertificateModel {
  final String? id;
  final String? companyId;
  final String? certificatePath;
  final String? certificateUser;
  final DateTime? certificateExpirationDate;

  const CompanyCertificateModel({
    this.id,
    this.companyId,
    this.certificatePath,
    this.certificateUser,
    this.certificateExpirationDate,
  });

  factory CompanyCertificateModel.fromJson(Map<String, dynamic> json) =>
      CompanyCertificateModel(
        id: json['id'],
        companyId: json['company_id'],
        certificatePath: json['certificate_path'],
        certificateUser: json['certificate_user'],
        certificateExpirationDate: json['certificate_expiration_date'] != null
            ? DateTime.tryParse(json['certificate_expiration_date'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_id': companyId,
        'certificate_path': certificatePath,
        'certificate_user': certificateUser,
        'certificate_expiration_date':
            certificateExpirationDate?.toIso8601String(),
      };
}

/// Tipo de documento habilitado para la empresa
class CompanyDocumentTypeModel {
  final String? id;
  final String? companyId;
  final String? documentTypeId;
  final String? state;

  const CompanyDocumentTypeModel({
    this.id,
    this.companyId,
    this.documentTypeId,
    this.state,
  });

  factory CompanyDocumentTypeModel.fromJson(Map<String, dynamic> json) =>
      CompanyDocumentTypeModel(
        id: json['id'],
        companyId: json['company_id'],
        documentTypeId: json['document_type_id'],
        state: json['state'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_id': companyId,
        'document_type_id': documentTypeId,
        'state': state,
      };
}

/// Punto de emisión de la empresa
class CompanyEmissionPointModel {
  final String? id;
  final String? companyId;
  final String? documentTypeId;
  final String? establishmentCode;
  final String? emissionPointCode;
  final int? currentSequential;
  final String? description;
  final bool isActive;

  const CompanyEmissionPointModel({
    this.id,
    this.companyId,
    this.documentTypeId,
    this.establishmentCode,
    this.emissionPointCode,
    this.currentSequential,
    this.description,
    this.isActive = true,
  });

  factory CompanyEmissionPointModel.fromJson(Map<String, dynamic> json) =>
      CompanyEmissionPointModel(
        id: json['id'],
        companyId: json['company_id'],
        documentTypeId: json['document_type_id'],
        establishmentCode: json['establishment_code'],
        emissionPointCode: json['emission_point_code'],
        currentSequential: json['current_sequential'],
        description: json['description'],
        isActive: json['is_active'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_id': companyId,
        'document_type_id': documentTypeId,
        'establishment_code': establishmentCode,
        'emission_point_code': emissionPointCode,
        'current_sequential': currentSequential,
        'description': description,
        'is_active': isActive,
      };

  CompanyEmissionPointModel copyWith({
    String? id,
    String? companyId,
    String? documentTypeId,
    String? establishmentCode,
    String? emissionPointCode,
    int? currentSequential,
    String? description,
    bool? isActive,
  }) =>
      CompanyEmissionPointModel(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        documentTypeId: documentTypeId ?? this.documentTypeId,
        establishmentCode: establishmentCode ?? this.establishmentCode,
        emissionPointCode: emissionPointCode ?? this.emissionPointCode,
        currentSequential: currentSequential ?? this.currentSequential,
        description: description ?? this.description,
        isActive: isActive ?? this.isActive,
      );
}

/// Método de pago habilitado para la empresa
class CompanyPaymentMethodModel {
  final String? id;
  final String? companyId;
  final String? paymentMethodId;
  final String? name;
  final String? state;

  const CompanyPaymentMethodModel({
    this.id,
    this.companyId,
    this.paymentMethodId,
    this.name,
    this.state,
  });

  factory CompanyPaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      CompanyPaymentMethodModel(
        id: json['id'],
        companyId: json['company_id'],
        paymentMethodId: json['payment_method_id'],
        name: json['name'],
        state: json['state'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_id': companyId,
        'payment_method_id': paymentMethodId,
        'name': name,
        'state': state,
      };
}

/// Parámetro de venta habilitado para la empresa
class CompanySaleParameterModel {
  final String? id;
  final String? companyId;
  final String? saleParameterId;
  final String? state;

  const CompanySaleParameterModel({
    this.id,
    this.companyId,
    this.saleParameterId,
    this.state,
  });

  factory CompanySaleParameterModel.fromJson(Map<String, dynamic> json) =>
      CompanySaleParameterModel(
        id: json['id'],
        companyId: json['company_id'],
        saleParameterId: json['sale_parameter_id'],
        state: json['state'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_id': companyId,
        'sale_parameter_id': saleParameterId,
        'state': state,
      };
}

/// Parámetro de sistema habilitado para la empresa
class CompanySystemParameterRefModel {
  final String? id;
  final String? companyId;
  final String? systemParameterId;
  final String? state;

  const CompanySystemParameterRefModel({
    this.id,
    this.companyId,
    this.systemParameterId,
    this.state,
  });

  factory CompanySystemParameterRefModel.fromJson(Map<String, dynamic> json) =>
      CompanySystemParameterRefModel(
        id: json['id'],
        companyId: json['company_id'],
        systemParameterId: json['system_parameter_id'],
        state: json['state'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_id': companyId,
        'system_parameter_id': systemParameterId,
        'state': state,
      };
}

// ─── Modelo principal ─────────────────────────────────────────────────────────

/// Enum para el estado de la compañía
enum CompanyState { A, I }

/// Modelo de datos de la compañía.
///
/// Refleja la respuesta completa del endpoint `companies/default`:
/// campos planos (id, identification, business_name, …) más listas
/// anidadas (certificate, document_types, emission_points, …).
///
/// Los campos de edición local (logo, certificateFile, mailPassword, …)
/// se mantienen para el wizard de configuración.
class CompanyModel {
  // ── Identificadores ────────────────────────────────────────────────────────
  String? companyId;

  // ── Datos básicos ──────────────────────────────────────────────────────────
  String? identificationTypeId;
  String? identificationTypeName;
  String? identification;
  String? businessName;
  String? address;
  String? phone;
  String? email;
  String? state;

  // ── Logo y sitio web ───────────────────────────────────────────────────────
  Uint8List? logo;
  String? logoPath;
  String? website;
  double? maxDiscount;
  String? itemAddress;

  // ── Certificado (objeto anidado del API) ───────────────────────────────────
  CompanyCertificateModel? certificateData;

  /// Campos de edición local para el wizard (no provienen del API)
  Uint8List? certificate;
  String? certificatePath;
  String? certificateUser;
  String? certificatePassword;
  DateTime? certificateExpirationDate;

  /// true si el backend indica que ya tiene certificado cargado
  bool hasCertificate;

  // ── Configuración de correo ────────────────────────────────────────────────
  String? mailServer;
  String? mailPort;
  String? mailAddress;
  String? mailUser;
  String? mailPassword;

  // ── Listas anidadas (respuesta del API) ───────────────────────────────────
  List<CompanyDocumentTypeModel> documentTypes;
  List<CompanyEmissionPointModel> emissionPoints;
  List<CompanyPaymentMethodModel> paymentMethods;
  List<CompanySaleParameterModel> saleParameters;
  List<CompanySystemParameterRefModel> systemParameters;

  // ── Campos de edición local para wizard (punto de emisión activo) ─────────
  String? documentTypeId;
  String? documentTypeName;
  String? establishmentCode;
  String? emissionPointCode;
  int? currentSequential;
  String? description;
  bool? isActive;

  // ── Grupos de impuesto habilitados (IVA, ICE, IRBPNR, ISD) ───────────────
  List<String> taxGroupCodes;

  CompanyModel({
    this.companyId,
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
    this.certificateData,
    this.certificate,
    this.certificatePath,
    this.certificateUser,
    this.certificatePassword,
    this.certificateExpirationDate,
    this.hasCertificate = false,
    this.mailServer,
    this.mailPort,
    this.mailAddress,
    this.mailUser,
    this.mailPassword,
    this.documentTypes = const [],
    this.emissionPoints = const [],
    this.paymentMethods = const [],
    this.saleParameters = const [],
    this.systemParameters = const [],
    this.documentTypeId,
    this.documentTypeName,
    this.establishmentCode,
    this.emissionPointCode,
    this.currentSequential,
    this.description,
    this.isActive,
    this.taxGroupCodes = const [],
  });

  // ── Factories ─────────────────────────────────────────────────────────────

  /// Compañía vacía para creación (wizard nuevo)
  factory CompanyModel.empty() => CompanyModel(
        state: 'ACTIVE',
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
        state: session['company_state'],
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
      );

  /// Deserializa la respuesta completa del endpoint `companies/default`.
  ///
  /// Mapea tanto los campos planos como las listas anidadas.
  /// También puebla los campos de edición local con el primer
  /// emission_point y document_type activos para el wizard.
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    // ── Listas anidadas ──────────────────────────────────────────────────────
    final docTypes = (json['document_types'] as List<dynamic>? ?? [])
        .map(
            (e) => CompanyDocumentTypeModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final emPoints = (json['emission_points'] as List<dynamic>? ?? [])
        .map((e) =>
            CompanyEmissionPointModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final payMethods = (json['payment_methods'] as List<dynamic>? ?? [])
        .map((e) =>
            CompanyPaymentMethodModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final saleParams = (json['sale_parameters'] as List<dynamic>? ?? [])
        .map((e) =>
            CompanySaleParameterModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final sysParams = (json['system_parameters'] as List<dynamic>? ?? [])
        .map((e) =>
            CompanySystemParameterRefModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // ── Certificado anidado ──────────────────────────────────────────────────
    final certJson = json['certificate'] as Map<String, dynamic>?;
    final certData =
        certJson != null ? CompanyCertificateModel.fromJson(certJson) : null;

    // ── Primer punto de emisión activo (para wizard) ──────────────────────────
    final activePoint = emPoints.isNotEmpty
        ? emPoints.firstWhere(
            (p) => p.isActive,
            orElse: () => emPoints.first,
          )
        : null;

    // ── Primer tipo de documento (para wizard) ────────────────────────────────
    final firstDocType = docTypes.isNotEmpty ? docTypes.first : null;

    return CompanyModel(
      companyId: json['id'],
      identificationTypeId: json['identification_type_id'],
      identification: json['identification'],
      businessName: json['business_name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      state: json['state'],
      website: json['website'],
      maxDiscount: json['max_discount'] != null
          ? double.tryParse(json['max_discount'].toString())
          : null,
      itemAddress: json['item_address'],
      // Certificado
      certificateData: certData,
      certificatePath: certData?.certificatePath,
      certificateUser: certData?.certificateUser,
      certificateExpirationDate: certData?.certificateExpirationDate,
      hasCertificate: certData != null,
      // Correo (puede no venir en este endpoint)
      mailServer: json['mail_server'],
      mailPort: json['mail_port'],
      mailAddress: json['mail_address'],
      mailUser: json['mail_user'],
      // Listas anidadas
      documentTypes: docTypes,
      emissionPoints: emPoints,
      paymentMethods: payMethods,
      saleParameters: saleParams,
      systemParameters: sysParams,
      // Campos de edición local (primer punto activo)
      documentTypeId:
          activePoint?.documentTypeId ?? firstDocType?.documentTypeId,
      establishmentCode: activePoint?.establishmentCode,
      emissionPointCode: activePoint?.emissionPointCode,
      currentSequential: activePoint?.currentSequential ?? 1,
      description: activePoint?.description,
      isActive: activePoint?.isActive ?? true,
      // Tax groups: extraídos de system_parameters si los hay
      taxGroupCodes: (json['tax_group_codes'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': companyId,
        'identification_type_id': identificationTypeId,
        'identification': identification,
        'business_name': businessName,
        'address': address,
        'phone': phone,
        'email': email,
        'state': state,
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
