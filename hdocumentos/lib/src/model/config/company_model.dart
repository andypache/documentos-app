import 'dart:convert';
import 'dart:typed_data';

import 'package:hdocumentos/src/model/config/company_sale_parameter_model.dart';

// ─── Sub-modelos ──────────────────────────────────────────────────────────────
class CompanyAdditionalInformationModel {
  final String? id;
  final String? companyId;
  Uint8List? logoImage;
  String? logoPath;
  String? website;
  double? maxDiscount;
  String? itemAddress;

  CompanyAdditionalInformationModel({
    this.id,
    this.companyId,
    this.logoImage,
    this.logoPath,
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
        logoPath: json['logo_path'],
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
    if (logoPath != null) result['logo_path'] = logoPath;
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
  Uint8List? certificate;
  String? certificatePath;
  String? certificateUser;
  String? certificatePassword;
  DateTime? certificateExpirationDate;

  CompanyCertificateModel({
    this.id,
    this.companyId,
    this.certificate,
    this.certificatePath,
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
        certificatePath: json['certificate'] != null ? 'loaded' : null,
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
  String? mailServer;
  String? mailPort;
  String? mailAddress;
  String? mailUser;
  String? mailPassword;

  CompanyEmailConfigurationModel({
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
  final String? description;
  final String? state; // 'ACTIVE' o 'INACTIVE'

  const CompanyEmissionPointModel({
    this.id,
    this.companyId,
    this.documentTypeId,
    this.establishmentCode,
    this.emissionPointCode,
    this.description,
    this.state = 'ACTIVE',
  });

  /// Helper para verificar si está activo
  bool get isActive => state == 'ACTIVE';

  factory CompanyEmissionPointModel.fromJson(Map<String, dynamic> json) =>
      CompanyEmissionPointModel(
        id: json['id'],
        companyId: json['company_id'],
        documentTypeId: json['document_type_id'],
        establishmentCode: json['establishment_code'],
        emissionPointCode: json['emission_point_code'],
        description: json['description'],
        state: json['state'] ?? 'ACTIVE',
      );

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (id != null) result['id'] = id;
    if (companyId != null) result['company_id'] = companyId;
    if (documentTypeId != null) result['document_type_id'] = documentTypeId;
    if (establishmentCode != null) {
      result['establishment_code'] = establishmentCode;
    }
    if (emissionPointCode != null) {
      result['emission_point_code'] = emissionPointCode;
    }
    if (description != null) result['description'] = description;
    if (state != null) result['state'] = state;
    return result;
  }

  CompanyEmissionPointModel copyWith({
    String? id,
    String? companyId,
    String? documentTypeId,
    String? establishmentCode,
    String? emissionPointCode,
    String? description,
    String? state,
  }) =>
      CompanyEmissionPointModel(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        documentTypeId: documentTypeId ?? this.documentTypeId,
        establishmentCode: establishmentCode ?? this.establishmentCode,
        emissionPointCode: emissionPointCode ?? this.emissionPointCode,
        description: description ?? this.description,
        state: state ?? this.state,
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

class CompanyUserModel {
  final String? id;
  final String? companyId;
  final String? userId;
  final bool? isDefault;
  final bool? isOwner;
  final String? state;

  const CompanyUserModel({
    this.id,
    this.companyId,
    this.userId,
    this.isDefault,
    this.isOwner,
    this.state,
  });

  factory CompanyUserModel.fromJson(Map<String, dynamic> json) =>
      CompanyUserModel(
        id: json['id'],
        companyId: json['company_id'],
        userId: json['user_id'],
        isDefault: json['is_default'],
        isOwner: json['is_owner'],
        state: json['state'],
      );

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (id != null) result['id'] = id;
    if (companyId != null) result['company_id'] = companyId;
    if (userId != null) result['user_id'] = userId;
    if (isDefault != null) result['is_default'] = isDefault;
    if (isOwner != null) result['is_owner'] = isOwner;
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

  // ── Sub-modelo: certificado digital ───────────────────────────────────────
  CompanyCertificateModel? certificateData;

  /// true si el backend indica que ya tiene certificado cargado
  bool hasCertificate;

  // ── Sub-modelo: configuración de correo ───────────────────────────────────
  CompanyEmailConfigurationModel? emailConfiguration;

  // ── Listas anidadas (respuesta del API) ───────────────────────────────────
  List<CompanyDocumentTypeModel> documentTypes;
  List<CompanyEmissionPointModel> emissionPoints;
  List<CompanyPaymentMethodModel> paymentMethods;
  List<CompanySaleParameterModel> saleParameters;
  List<CompanySystemParameterRefModel> systemParameters;
  List<CompanyUserModel> users;

  // ── Campos de edición local para wizard (punto de emisión activo) ─────────
  String? documentTypeId;
  String? documentTypeName;
  String? establishmentCode;
  String? emissionPointCode;
  String? description;
  String? emissionPointState;

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
    // ── Certificado ───────────────────────────────────────────────────────────
    this.certificateData,
    this.hasCertificate = false,
    // ── Correo ────────────────────────────────────────────────────────────────
    this.emailConfiguration,
    // ── Listas anidadas ───────────────────────────────────────────────────────
    this.documentTypes = const [],
    this.emissionPoints = const [],
    this.paymentMethods = const [],
    this.saleParameters = const [],
    this.systemParameters = const [],
    this.users = const [],
    // ── Campos locales wizard (punto de emisión activo) ───────────────
    this.documentTypeId,
    this.documentTypeName,
    this.establishmentCode,
    this.emissionPointCode,
    this.description,
    this.emissionPointState,
    // ── Grupos de impuesto ────────────────────────────────────────────────────
    this.taxGroupCodes = const [],
  });

  // ── Factories ─────────────────────────────────────────────────────────────

  /// Compañía vacía para creación (wizard nuevo)
  factory CompanyModel.empty() => CompanyModel(
        state: 'ACTIVE',
        emissionPointState: 'ACTIVE',
        taxGroupCodes: [],
      );

  /// Carga desde la sesión del usuario (sin claves ni archivos)
  factory CompanyModel.fromSession(Map<String, dynamic> session) {
    final addInfo = CompanyAdditionalInformationModel(
      logoPath: session['company_logo_url'],
      website: session['company_website'],
      maxDiscount: session['company_max_discount'] != null
          ? double.tryParse(session['company_max_discount'].toString())
          : null,
      itemAddress: session['company_item_address'],
    );

    final users = session['company_users'] != null
        ? (session['company_users'] as List<dynamic>)
            .map((e) => CompanyUserModel.fromJson(e as Map<String, dynamic>))
            .where((user) => user.isDefault == true)
            .toList()
        : <CompanyUserModel>[];

    return CompanyModel(
      identificationTypeId: session['company_identification_type_id'],
      identificationTypeName: session['company_identification_type_name'],
      identification: session['company_identification'],
      businessName: session['company_name'],
      address: session['company_address'],
      phone: session['company_phone'],
      email: session['company_email'],
      state: session['company_state'],
      additionalInformation: addInfo,
      documentTypeId: session['document_type_id'],
      documentTypeName: session['document_type_name'],
      establishmentCode: session['establishment_code'],
      emissionPointCode: session['emission_point_code'],
      description: session['emission_description'],
      emissionPointState: session['emission_state'] ?? 'ACTIVE',
      users: users,
    );
  }

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

    final users = (json['users'] as List<dynamic>? ?? [])
        .map((e) => CompanyUserModel.fromJson(e as Map<String, dynamic>))
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
      // Certificado
      certificateData: certData,
      hasCertificate: certData != null,
      // Correo
      emailConfiguration: emailConfig,
      // Listas anidadas
      documentTypes: docTypes,
      emissionPoints: emPoints,
      paymentMethods: payMethods,
      saleParameters: saleParams,
      systemParameters: sysParams,
      users: users,
      // Campos de edición local (primer punto activo)
      documentTypeId:
          activePoint?.documentTypeId ?? firstDocType?.documentTypeId,
      establishmentCode: activePoint?.establishmentCode,
      emissionPointCode: activePoint?.emissionPointCode,
      description: activePoint?.description,
      emissionPointState: activePoint?.state ?? 'ACTIVE',
      // Tax groups
      taxGroupCodes: (json['tax_group_codes'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
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
    if (additionalInformation != null) {
      result['additional_information'] = additionalInformation!.toJson();
    }

    // ── Certificado ───────────────────────────────────────────────────────
    if (certificateData != null) {
      result['certificate'] = certificateData!.toJson();
    }

    // ── Configuración de correo ───────────────────────────────────────────
    if (emailConfiguration != null) {
      result['email_configuration'] = emailConfiguration!.toJson();
    }

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
    if (users.isNotEmpty) {
      result['users'] = users.map((e) => e.toJson()).toList();
    }

    return result;
  }
}
