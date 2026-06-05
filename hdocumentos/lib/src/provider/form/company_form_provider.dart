import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/exception/error_handler.dart';

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

  /// En edición, indica si el usuario quiere cambiar la contraseña del certificado.
  /// Cuando es false, la validación del paso 3 no requiere el campo de contraseña.
  bool requireCertPassword = true;

  /// En edición, indica si el usuario quiere cambiar la contraseña de correo.
  /// Cuando es false, la validación del paso 4 no requiere el campo de contraseña.
  bool requireMailPassword = true;

  CompanyFormProvider(this.company, {this.isEditing = false}) {
    // Al cargar un modelo existente, sincronizar bytes locales para los widgets
    logoBytes = company.additionalInformation?.logoImage;
    // En edición con certificado ya configurado, no se requiere nueva contraseña
    if (isEditing && company.hasCertificate) {
      requireCertPassword = false;
    }
    // En edición con correo ya configurado, no se requiere nueva contraseña SMTP
    if (isEditing && company.emailConfiguration != null) {
      requireMailPassword = false;
    }
  }

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
    final formValid = currentFormKey.currentState?.validate() ?? false;
    // Paso 3 (índice 2): validar también campos fuera del Form
    if (_currentStep == 2) {
      _step3Submitted = true;
      notifyListeners();
      final certOk = company.certificateData?.certificatePath != null;
      final dateOk = company.certificateData?.certificateExpirationDate != null;
      if (!requireCertPassword) {
        return formValid && certOk && dateOk;
      }
      return formValid && certOk && dateOk;
    }
    // Paso 5 (índice 4): al menos un punto de emisión agregado y uno activo
    if (_currentStep == 4) {
      _step5Submitted = true;
      notifyListeners();
      final hasPoints = company.emissionPoints.isNotEmpty;
      final hasActivePoint = company.emissionPoints.any((p) => p.isActive);
      return formValid && hasPoints && hasActivePoint;
    }
    return formValid;
  }

  /// Indica que el usuario intentó avanzar desde el paso 3,
  /// usado por [CompanyWizardStep3Widget] para mostrar errores de cert/fecha.
  bool _step3Submitted = false;
  bool get step3Submitted => _step3Submitted;

  /// Indica que el usuario intentó avanzar desde el paso 5,
  /// usado por [CompanyWizardStep5Widget] para mostrar error de punto de emisión.
  bool _step5Submitted = false;
  bool get step5Submitted => _step5Submitted;

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

  /// Actualiza el logo: guarda los bytes en [additionalInformation.logoImage] para serializar a Base64.
  void updateLogo(Uint8List? bytes, String? path) {
    logoBytes = bytes;
    company.additionalInformation ??= CompanyAdditionalInformationModel();
    company.additionalInformation!.logoImage = bytes;
    if (path != null) {
      logoFile = File(path);
      company.additionalInformation!.logoPath = path;
    }
    notifyListeners();
  }

  /// Actualiza el certificado: lee los bytes del archivo y los guarda
  /// en [certificateData.certificate] como [Uint8List] para serializar a Base64.
  Future<void> updateCertificate(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    certificateFile = file;
    company.certificateData ??= CompanyCertificateModel();
    company.certificateData!.certificatePath = path;
    company.certificateData!.certificate = bytes;
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

    final body = _buildStepBody(_currentStep);

    final response = await ErrorHandler.tryExecute(
      action: () async => await putFetch(
        context: context,
        url: apiCompanyUpdate,
        body: body,
      ),
      context: context,
      errorMessage: 'Error al guardar el paso',
      showNotification: false, // Manejamos notificaciones manualmente
    );

    if (!context.mounted) return;

    if (response != null &&
        (response.statusHttp == 200 || response.statusHttp == 201)) {
      final l10nMsg = NotificationService.l10n;
      NotificationService.showSnackbarSuccess(
          l10nMsg?.stepSavedSuccess ?? 'Paso guardado correctamente');
      // Sincronizar la empresa editada (logo, certificado, etc.) en el
      // AppInitProvider y en la sesión sin llamar al API
      await context.read<AppInitProvider>().updateCompany(company);
      if (!context.mounted) return;
    } else if (response != null) {
      NotificationService.showSnackbarError(getError(response).toString());
    }

    _isSavingStep = false;
    notifyListeners();
  }

  /// Construye el body específico para el paso indicado
  Map<String, dynamic> _buildStepBody(int step) {
    switch (step) {
      case 0:
        return {
          'company_id': company.companyId,
          'identification': company.identification,
          'identification_type_id': company.identificationTypeId,
          'email': company.email,
          'address': company.address,
          'business_name': company.businessName,
          'phone': company.phone
        };
      case 1:
        return {
          'company_id': company.companyId,
          'additional_information': {
            if (company.additionalInformation?.logoImage != null)
              'logo_image':
                  base64Encode(company.additionalInformation!.logoImage!),
            'website': company.additionalInformation?.website,
            'id': company.additionalInformation?.id,
            'company_id': company.additionalInformation?.companyId,
            'item_address': company.additionalInformation?.itemAddress,
            'max_discount': company.additionalInformation?.maxDiscount,
          }
        };
      case 2:
        return {
          'company_id': company.companyId,
          'certificate': {
            'company_id': company.companyId,
            'id': company.certificateData?.id,
            if (company.certificateData?.certificate != null)
              'certificate':
                  base64Encode(company.certificateData!.certificate!),
            if (company.certificateData?.certificatePassword != null)
              'certificate_password':
                  company.certificateData!.certificatePassword,
            if (company.certificateData?.certificateUser != null)
              'certificate_user': company.certificateData!.certificateUser,
            if (company.certificateData?.certificateExpirationDate != null)
              'certificate_expiration_date': company
                  .certificateData!.certificateExpirationDate!
                  .toIso8601String(),
          }
        };
      case 3:
        return {
          'company_id': company.companyId,
          'email_configuration': {
            'company_id': company.companyId,
            'id': company.emailConfiguration?.id,
            'mail_server': company.emailConfiguration?.mailServer,
            'mail_port': company.emailConfiguration?.mailPort,
            'mail_address': company.emailConfiguration?.mailAddress,
            'mail_user': company.emailConfiguration?.mailUser,
            'mail_password': company.emailConfiguration?.mailPassword,
          }
        };
      case 4:
        return {
          'company_id': company.companyId,
          'emission_points': company.emissionPoints
              .map((p) => {
                    if (p.id != null) 'id': p.id,
                    'company_id': p.companyId ?? company.companyId,
                    'document_type_id': p.documentTypeId,
                    'establishment_code': p.establishmentCode,
                    'emission_point_code': p.emissionPointCode,
                    'description': p.description,
                    'state': p.state,
                  })
              .toList(),
        };
      case 5:
        return {
          'company_id': company.companyId,
          'system_parameters': company.systemParameters
              .map((e) => {
                    'company_id': company.companyId,
                    if (e.id != null) 'id': e.id,
                    'system_parameter_id': e.systemParameterId,
                  })
              .toList(),
        };
      default:
        return company.toJson();
    }
  }

  /// Construye el CompanyModel final
  CompanyModel buildCompanyModel() => company;

  /// Carga los datos de la compañia desde el modelo y sincroniza
  /// los campos locales del wizard (logoBytes, etc.).
  void loadFromModel(CompanyModel model) {
    company = model;
    logoBytes = model.additionalInformation?.logoImage;
    notifyListeners();
  }

  // ── Gestión de puntos de emisión ─────────────────────────────────────────

  /// Índice del punto de emisión seleccionado como activo en el wizard.
  /// Usa índice de lista para soportar puntos sin id (nuevos, no guardados aún).
  int? selectedEmissionPointIndex;

  /// ID del punto activo (null si el punto aún no fue guardado en el backend)
  String? get selectedEmissionPointId {
    final idx = selectedEmissionPointIndex;
    if (idx == null || idx < 0 || idx >= company.emissionPoints.length) {
      return null;
    }
    return company.emissionPoints[idx].id;
  }

  /// Devuelve la lista actual de puntos de emisión
  List<CompanyEmissionPointModel> get emissionPoints => company.emissionPoints;

  /// Agrega un nuevo punto o reemplaza uno existente.
  /// Busca por [id] si lo tiene; si no, usa [editingIndex] para reemplazar
  /// en posición exacta (puntos locales aún sin id del backend).
  void upsertEmissionPoint(CompanyEmissionPointModel point,
      {int editingIndex = -1}) {
    final list = List<CompanyEmissionPointModel>.from(company.emissionPoints);
    // 1º prioridad: buscar por id (puntos guardados en backend)
    final idxById =
        point.id != null ? list.indexWhere((p) => p.id == point.id) : -1;
    // 2ª prioridad: usar el índice conocido (puntos locales sin id)
    final idx = idxById >= 0 ? idxById : editingIndex;

    // Si el punto a guardar es activo, desactivar todos los demás
    if (point.isActive == true) {
      for (int i = 0; i < list.length; i++) {
        if (i != idx && list[i].isActive == true) {
          list[i] = list[i].copyWith(
            state: 'INACTIVE',
          );
        }
      }
    }

    if (idx >= 0 && idx < list.length) {
      list[idx] = point;
    } else {
      list.add(point);
    }
    company.emissionPoints = list;
    notifyListeners();
  }

  /// Elimina un punto de emisión por índice de lista
  void removeEmissionPoint(int index) {
    final list = List<CompanyEmissionPointModel>.from(company.emissionPoints);
    if (index < 0 || index >= list.length) return;
    list.removeAt(index);
    company.emissionPoints = list;
    // Ajustar selección
    if (selectedEmissionPointIndex == index) {
      selectedEmissionPointIndex = list.isNotEmpty ? 0 : null;
      if (selectedEmissionPointIndex != null) {
        _syncSelectedPointFields(list[selectedEmissionPointIndex!]);
      }
    } else if (selectedEmissionPointIndex != null &&
        selectedEmissionPointIndex! > index) {
      selectedEmissionPointIndex = selectedEmissionPointIndex! - 1;
    }
    notifyListeners();
  }

  /// Marca el punto dado como activo, desactiva los demás y actualiza la selección.
  void selectActiveEmissionPoint(CompanyEmissionPointModel point) {
    final list = List<CompanyEmissionPointModel>.from(company.emissionPoints);
    final idx = list.indexOf(point);
    if (idx < 0) return;

    // Desactivar todos y activar solo el elegido
    for (int i = 0; i < list.length; i++) {
      final p = list[i];
      final shouldBeActive = i == idx;
      if (p.isActive != shouldBeActive) {
        list[i] = p.copyWith(
          state: shouldBeActive ? 'ACTIVE' : 'INACTIVE',
        );
      }
    }
    company.emissionPoints = list;

    selectedEmissionPointIndex = idx;
    _syncSelectedPointFields(list[idx]);
    // Persistir en Preferences
    Preferences.saveActiveEmissionPoint(
      id: list[idx].id,
      documentTypeId: list[idx].documentTypeId,
      establishmentCode: list[idx].establishmentCode,
      emissionPointCode: list[idx].emissionPointCode,
    );
    notifyListeners();
  }

  /// Sincroniza los campos planos del company con el punto seleccionado
  void _syncSelectedPointFields(CompanyEmissionPointModel point) {
    company.documentTypeId = point.documentTypeId;
    company.establishmentCode = point.establishmentCode;
    company.emissionPointCode = point.emissionPointCode;
    company.description = point.description;
    company.emissionPointState = point.state;
  }

  /// Inicializa la selección con el punto que tiene isActive == true (si hay).
  /// Si ninguno está activo, selectedEmissionPointIndex queda en null.
  void initEmissionPointSelection() {
    final points = company.emissionPoints;
    if (points.isEmpty) {
      selectedEmissionPointIndex = null;
      return;
    }
    final idx = points.indexWhere((p) => p.isActive);
    selectedEmissionPointIndex = idx >= 0 ? idx : null;
    if (idx >= 0) _syncSelectedPointFields(points[idx]);
    notifyListeners();
  }
}
