import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/service/client/consume_service.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/service/notification_service.dart';

// ─── Endpoints por paso ───────────────────────────────────────────────────────

final Map<int, String> _stepEndpoints = {
  0: apiCompanyBasic, // Paso 1: datos generales
  1: apiCompanyLogo, // Paso 2: logo
  2: apiCompanyCertificate, // Paso 3: certificado
  3: apiCompanyMail, // Paso 4: correo
  4: apiCompanyEmission, // Paso 5: emisión
  5: apiCompanyTaxGroups, // Paso 6: grupos de impuesto
};

/// Provider para el wizard de configuración de compañia
class CompanyFormProvider extends ChangeNotifier {
  // Keys de formulario por paso
  final GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep4 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep5 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep6 = GlobalKey<FormState>();

  int _currentStep = 0;
  int get currentStep => _currentStep;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isSavingStep = false;
  bool get isSavingStep => _isSavingStep;

  final bool isEditing;
  CompanyModel company;
  File? logoFile;
  File? certificateFile;
  Uint8List? logoBytes;

  CompanyFormProvider(this.company, {this.isEditing = false});

  GlobalKey<FormState> get currentFormKey {
    switch (_currentStep) {
      case 0:
        return formKeyStep1;
      case 1:
        return formKeyStep2;
      case 2:
        return formKeyStep3;
      case 3:
        return formKeyStep4;
      case 4:
        return formKeyStep5;
      case 5:
        return formKeyStep6;
      default:
        return formKeyStep1;
    }
  }

  /// Valida el paso actual antes de avanzar
  bool isValidCurrentStep() {
    return currentFormKey.currentState?.validate() ?? false;
  }

  /// Avanza al siguiente paso si la validación pasa
  bool nextStep() {
    if (!isValidCurrentStep()) return false;
    if (_currentStep < 5) {
      _currentStep++;
      notifyListeners();
    }
    return true;
  }

  /// Regresa al paso anterior
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  /// Ir a un paso específico
  void goToStep(int step) {
    if (step >= 0 && step <= 5) {
      _currentStep = step;
      notifyListeners();
    }
  }

  /// Actualiza el logo (bytes + file)
  void updateLogo(Uint8List? bytes, String? path) {
    logoBytes = bytes;
    if (path != null) {
      logoFile = File(path);
      company.logoPath = path;
    }
    notifyListeners();
  }

  /// Actualiza el certificado
  void updateCertificate(String path) {
    company.certificatePath = path;
    certificateFile = File(path);
    notifyListeners();
  }

  /// Guarda solo el paso actual en su endpoint independiente (solo edición)
  Future<void> saveStep(BuildContext context) async {
    if (!isValidCurrentStep()) {
      final l10n = NotificationService.l10n;
      NotificationService.showSnackbarError(
          l10n?.msgRequiredFields ?? 'Campos requeridos incompletos');
      return;
    }

    _isSavingStep = true;
    notifyListeners();

    try {
      final url = _stepEndpoints[_currentStep];
      if (url == null) return;

      final body = _buildStepBody(_currentStep);
      final response = await postFetch(context: context, url: url, body: body);

      if (!context.mounted) return;

      if (response.statusHttp == 200 || response.statusHttp == 201) {
        NotificationService.showSnackbarSuccess('Paso guardado correctamente');
      } else {
        NotificationService.showSnackbarError(response.message);
      }
    } catch (e) {
      NotificationService.showSnackbarError(e.toString());
    } finally {
      _isSavingStep = false;
      notifyListeners();
    }
  }

  /// Construye el body específico para el paso indicado
  Map<String, dynamic> _buildStepBody(int step) {
    switch (step) {
      case 0:
        return {
          'business_name': company.businessName,
          'identification': company.identification,
          'identification_type_id': company.identificationTypeId,
          'address': company.address,
          'phone': company.phone,
          'email': company.email,
          'website': company.website,
        };
      case 1:
        return {'logo_path': company.logoPath};
      case 2:
        return {
          'certificate_path': company.certificatePath,
          'certificate_password': company.certificatePassword,
          'certificate_user': company.certificateUser,
        };
      case 3:
        return {
          'mail_server': company.mailServer,
          'mail_port': company.mailPort,
          'mail_address': company.mailAddress,
          'mail_user': company.mailUser,
          'mail_password': company.mailPassword,
        };
      case 4:
        return {
          'document_type_id': company.documentTypeId,
          'establishment_code': company.establishmentCode,
          'emission_point_code': company.emissionPointCode,
          'current_sequential': company.currentSequential,
          'description': company.description,
          'is_active': company.isActive,
        };
      case 5:
        return {'tax_group_codes': company.taxGroupCodes};
      default:
        return company.toJson();
    }
  }

  /// Construye el CompanyModel final
  CompanyModel buildCompanyModel() => company;

  /// Carga los datos de la compañia desde el modelo
  void loadFromModel(CompanyModel model) {
    company = model;
    notifyListeners();
  }
}
