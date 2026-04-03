import 'dart:convert';
import 'dart:typed_data';

// ─── Sub-modelos ──────────────────────────────────────────────────────────────
class CompanyAdditionalInformationModel {
  final String? id;
  final String? companyId;
  final Uint8List? logoImage;
  final String? website;
  final double? maxDiscount;
  final String? itemAddress;

  const CompanyAdditionalInformationModel({
    this.id,
    this.companyId,
    this.logoImage,
    this.website,
    this.maxDiscount,
    this.itemAddress,
  });

  factory CompanyAdditionalInformationModel.fromJson(
          Map<String, dynamic> json) =>
      CompanyAdditionalInformationModel(
        id: json['id'],
        companyId: json['company_id'],
        logoImage: json['logo_image'] != null
            ? base64Decode(json['logo_image'] as String)
            : null,
        website: json['website'],
        maxDiscount: json['max_discount'] != null
            ? double.tryParse(json['max_discount'].toString())
            : null,
        itemAddress: json['item_address'],
      );

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (id != null) result['id'] = id;
    if (companyId != null) result['company_id'] = companyId;
    if (logoImage != null) result['logo_image'] = base64Encode(logoImage!);
    if (website != null) result['website'] = website;
    if (maxDiscount != null) result['max_discount'] = maxDiscount;
    if (itemAddress != null) result['item_address'] = itemAddress;
    return result;
  }
}

/// Certificado digital de la empresa
class CompanyCertificateModel {
  final String? id;
  final String? companyId;
  final Uint8List? certificate;
  final String? certificateUser;
  final String? certificatePassword;
  final DateTime? certificateExpirationDate;

  const CompanyCertificateModel({
    this.id,
    this.companyId,
    this.certificate,
    this.certificateUser,
    this.certificatePassword,
    this.certificateExpirationDate,
  });

  factory CompanyCertificateModel.fromJson(Map<String, dynamic> json) =>
      CompanyCertificateModel(
        id: json['id'],
        companyId: json['company_id'],
        certificate: json['certificate'] != null
            ? base64Decode(json['certificate'] as String)
            : null,
        certificateUser: json['certificate_user'],
        certificatePassword: json['certificate_password'],
        certificateExpirationDate: json['certificate_expiration_date'] != null
            ? DateTime.tryParse(json['certificate_expiration_date'])
            : null,
      );

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (id != null) result['id'] = id;
    if (companyId != null) result['company_id'] = companyId;
    if (certificate != null) result['certificate'] = base64Encode(certificate!);
    if (certificateUser != null) result['certificate_user'] = certificateUser;
    if (certificatePassword != null) {
      result['certificate_password'] = certificatePassword;
    }
    if (certificateExpirationDate != null) {
      result['certificate_expiration_date'] =
          certificateExpirationDate!.toIso8601String();
    }
    return result;
  }
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

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (id != null) result['id'] = id;
    if (companyId != null) result['company_id'] = companyId;
    if (documentTypeId != null) result['document_type_id'] = documentTypeId;
    if (state != null) result['state'] = state;
    return result;
  }
}

class CompanyEmailConfigurationModel {
  final String? id;
  final String? companyId;
  final String? mailServer;
  final String? mailPort;
  final String? mailAddress;
  final String? mailUser;
  final String? mailPassword;

  const CompanyEmailConfigurationModel({
    this.id,
    this.companyId,
    this.mailServer,
    this.mailPort,
    this.mailAddress,
    this.mailUser,
    this.mailPassword,
  });

  factory CompanyEmailConfigurationModel.fromJson(Map<String, dynamic> json) =>
      CompanyEmailConfigurationModel(
        id: json['id'],
        companyId: json['company_id'],
        mailServer: json['mail_server'],
        mailPort: json['mail_port'],
        mailAddress: json['mail_address'],
        mailUser: json['mail_user'],
        mailPassword: json['mail_password'],
      );

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (id != null) result['id'] = id;
    if (companyId != null) result['company_id'] = companyId;
    if (mailServer != null) result['mail_server'] = mailServer;
    if (mailPort != null) result['mail_port'] = mailPort;
    if (mailAddress != null) result['mail_address'] = mailAddress;
    if (mailUser != null) result['mail_user'] = mailUser;
    if (mailPassword != null) result['mail_password'] = mailPassword;
    return result;
  }
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

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'is_active': isActive};
    if (id != null) result['id'] = id;
    if (companyId != null) result['company_id'] = companyId;
    if (documentTypeId != null) result['document_type_id'] = documentTypeId;
    if (establishmentCode != null) {
      result['establishment_code'] = establishmentCode;
    }
    if (emissionPointCode != null) {
      result['emission_point_code'] = emissionPointCode;
    }
    if (currentSequential != null) {
      result['current_sequential'] = currentSequential;
    }
    if (description != null) result['description'] = description;
    return result;
  }

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

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (id != null) result['id'] = id;
    if (companyId != null) result['company_id'] = companyId;
    if (paymentMethodId != null) result['payment_method_id'] = paymentMethodId;
    if (name != null) result['name'] = name;
    if (state != null) result['state'] = state;
    return result;
  }
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

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (id != null) result['id'] = id;
    if (companyId != null) result['company_id'] = companyId;
    if (saleParameterId != null) result['sale_parameter_id'] = saleParameterId;
    if (state != null) result['state'] = state;
    return result;
  }
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

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (id != null) result['id'] = id;
    if (companyId != null) result['company_id'] = companyId;
    if (systemParameterId != null) {
      result['system_parameter_id'] = systemParameterId;
    }
    if (state != null) result['state'] = state;
    return result;
  }
}

// ─── Modelo principal ─────────────────────────────────────────────────────────

/// Enum para el estado de la compañía
enum CompanyState { A, I }

/// Modelo de datos de la compañía.
///
/// Refleja la respuesta completa del endpoint `companies/default`:
/// campos planos (id, identification, business_name, …) más sub-modelos
/// anidados (additionalInformation, certificateData, emailConfiguration, …).
///
/// Los campos de edición local (logoPath, certificatePath, mailPassword, …)
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

  // ── Sub-modelo: información adicional (logo, web, descuento, dirección) ───
  CompanyAdditionalInformationModel? additionalInformation;

  /// Campos de edición local para el wizard
  Uint8List? logo;
  String? logoPath;
  String? website;
  double? maxDiscount;
  String? itemAddress;

  // ── Sub-modelo: certificado digital ───────────────────────────────────────
  CompanyCertificateModel? certificateData;

  /// Campos de edición local para el wizard
  Uint8List? certificate;
  String? certificatePath;
  String? certificateUser;
  String? certificatePassword;
  DateTime? certificateExpirationDate;

  /// true si el backend indica que ya tiene certificado cargado
  bool hasCertificate;

  // ── Sub-modelo: configuración de correo ───────────────────────────────────
  CompanyEmailConfigurationModel? emailConfiguration;

  /// Campos de edición local para el wizard
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
    // ── Identificadores ──────────────────────────────────────────────────────
    this.companyId,
    // ── Datos básicos ─────────────────────────────────────────────────────────
    this.identificationTypeId,
    this.identificationTypeName,
    this.identification,
    this.businessName,
    this.address,
    this.phone,
    this.email,
    this.state,
    // ── Información adicional ─────────────────────────────────────────────────
    this.additionalInformation,
    this.logo,
    this.logoPath,
    this.website,
    this.maxDiscount,
    this.itemAddress,
    // ── Certificado ───────────────────────────────────────────────────────────
    this.certificateData,
    this.certificate,
    this.certificatePath,
    this.certificateUser,
    this.certificatePassword,
    this.certificateExpirationDate,
    this.hasCertificate = false,
    // ── Correo ────────────────────────────────────────────────────────────────
    this.emailConfiguration,
    this.mailServer,
    this.mailPort,
    this.mailAddress,
    this.mailUser,
    this.mailPassword,
    // ── Listas anidadas ───────────────────────────────────────────────────────
    this.documentTypes = const [],
    this.emissionPoints = const [],
    this.paymentMethods = const [],
    this.saleParameters = const [],
    this.systemParameters = const [],
    // ── Campos locales wizard (punto de emisión activo) ───────────────────────
    this.documentTypeId,
    this.documentTypeName,
    this.establishmentCode,
    this.emissionPointCode,
    this.currentSequential,
    this.description,
    this.isActive,
    // ── Grupos de impuesto ────────────────────────────────────────────────────
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

    // ── Sub-modelos anidados ─────────────────────────────────────────────────
    final addInfoJson = json['additional_information'] as Map<String, dynamic>?;
    final addInfo = addInfoJson != null
        ? CompanyAdditionalInformationModel.fromJson(addInfoJson)
        : null;

    final certJson = json['certificate'] as Map<String, dynamic>?;
    final certData =
        certJson != null ? CompanyCertificateModel.fromJson(certJson) : null;

    final emailJson = json['email_configuration'] as Map<String, dynamic>?;
    final emailConfig = emailJson != null
        ? CompanyEmailConfigurationModel.fromJson(emailJson)
        : null;

    // ── Primer punto de emisión activo (para wizard) ──────────────────────────
    final activePoint = emPoints.isNotEmpty
        ? emPoints.firstWhere((p) => p.isActive, orElse: () => emPoints.first)
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
      // Información adicional
      additionalInformation: addInfo,
      logo: addInfo?.logoImage,
      logoPath: addInfo?.id != null ? null : json['logo_path'],
      website: addInfo?.website ?? json['website'],
      maxDiscount: addInfo?.maxDiscount ??
          (json['max_discount'] != null
              ? double.tryParse(json['max_discount'].toString())
              : null),
      itemAddress: addInfo?.itemAddress ?? json['item_address'],
      // Certificado
      certificateData: certData,
      certificate: certData?.certificate,
      certificatePath: certData?.certificate != null ? 'loaded' : null,
      certificateUser: certData?.certificateUser,
      certificatePassword: certData?.certificatePassword,
      certificateExpirationDate: certData?.certificateExpirationDate,
      hasCertificate: certData != null,
      // Correo
      emailConfiguration: emailConfig,
      mailServer: emailConfig?.mailServer ?? json['mail_server'],
      mailPort: emailConfig?.mailPort ?? json['mail_port'],
      mailAddress: emailConfig?.mailAddress ?? json['mail_address'],
      mailUser: emailConfig?.mailUser ?? json['mail_user'],
      mailPassword: emailConfig?.mailPassword ?? json['mail_password'],
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
      // Tax groups
      taxGroupCodes: (json['tax_group_codes'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    // Helper: elimina las entradas con valor null del mapa
    Map<String, dynamic> compact(Map<String, dynamic> m) =>
        m..removeWhere((_, v) => v == null);

    final Map<String, dynamic> result = {};

    // ── Datos básicos (solo si tienen valor) ──────────────────────────────
    if (companyId != null) result['id'] = companyId;
    if (identificationTypeId != null) {
      result['identification_type_id'] = identificationTypeId;
    }
    if (identification != null) result['identification'] = identification;
    if (businessName != null) result['business_name'] = businessName;
    if (address != null) result['address'] = address;
    if (phone != null) result['phone'] = phone;
    if (email != null) result['email'] = email;
    if (state != null) result['state'] = state;

    // ── Información adicional ─────────────────────────────────────────────
    final rawLogo = logo ?? additionalInformation?.logoImage;
    final addInfoMap = compact({
      'id': additionalInformation?.id,
      'company_id': additionalInformation?.companyId ?? companyId,
      'logo_image': rawLogo != null ? base64Encode(rawLogo) : null,
      'website': website ?? additionalInformation?.website,
      'max_discount': maxDiscount ?? additionalInformation?.maxDiscount,
      'item_address': itemAddress ?? additionalInformation?.itemAddress,
    });
    if (addInfoMap.isNotEmpty) result['additional_information'] = addInfoMap;

    // ── Certificado ───────────────────────────────────────────────────────
    final rawCert = certificate ?? certificateData?.certificate;
    final certMap = compact({
      'id': certificateData?.id,
      'company_id': certificateData?.companyId ?? companyId,
      'certificate': rawCert != null ? base64Encode(rawCert) : null,
      'certificate_user': certificateUser ?? certificateData?.certificateUser,
      'certificate_password':
          certificatePassword ?? certificateData?.certificatePassword,
      'certificate_expiration_date': (certificateExpirationDate ??
              certificateData?.certificateExpirationDate)
          ?.toIso8601String(),
    });
    if (certMap.isNotEmpty) result['certificate'] = certMap;

    // ── Configuración de correo ───────────────────────────────────────────
    final mailMap = compact({
      'id': emailConfiguration?.id,
      'company_id': emailConfiguration?.companyId ?? companyId,
      'mail_server': mailServer ?? emailConfiguration?.mailServer,
      'mail_port': mailPort ?? emailConfiguration?.mailPort,
      'mail_address': mailAddress ?? emailConfiguration?.mailAddress,
      'mail_user': mailUser ?? emailConfiguration?.mailUser,
      'mail_password': mailPassword ?? emailConfiguration?.mailPassword,
    });
    if (mailMap.isNotEmpty) result['email_configuration'] = mailMap;

    // ── Listas anidadas ───────────────────────────────────────────────────
    if (documentTypes.isNotEmpty) {
      result['document_types'] = documentTypes.map((e) => e.toJson()).toList();
    }
    if (emissionPoints.isNotEmpty) {
      result['emission_points'] =
          emissionPoints.map((e) => e.toJson()).toList();
    }
    if (paymentMethods.isNotEmpty) {
      result['payment_methods'] =
          paymentMethods.map((e) => e.toJson()).toList();
    }
    if (saleParameters.isNotEmpty) {
      result['sale_parameters'] =
          saleParameters.map((e) => e.toJson()).toList();
    }
    if (systemParameters.isNotEmpty) {
      result['system_parameters'] =
          systemParameters.map((e) => e.toJson()).toList();
    }

    return result;
  }
}
