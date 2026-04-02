import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/service/client/consume_service.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/service/notification_service.dart';
import 'package:hdocumentos/src/share/preference.dart';

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
    final formValid = currentFormKey.currentState?.validate() ?? false;
    // Paso 3 (índice 2): validar también campos fuera del Form
    if (_currentStep == 2) {
      _step3Submitted = true;
      notifyListeners();
      final certOk = company.certificatePath != null;
      final dateOk = company.certificateExpirationDate != null;
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
        final l10nMsg = NotificationService.l10n;
        NotificationService.showSnackbarSuccess(
            l10nMsg?.stepSavedSuccess ?? 'Paso guardado correctamente');
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
          'emission_points':
              company.emissionPoints.map((p) => p.toJson()).toList(),
          'selected_emission_point_id': selectedEmissionPointId,
        };
      case 5:
        // Envía solo los system_parameters que corresponden a grupos TAX-GROUP
        final taxGroupParams = company.systemParameters
            .where((sp) =>
                sp.systemParameterId != null &&
                sp.systemParameterId!.contains('TAX-GROUP-'))
            .toList();
        return {
          'system_parameters': taxGroupParams.map((e) => e.toJson()).toList(),
        };
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

  /// Marca un punto como el activo por su índice y lo persiste en Preferences
  void selectActiveEmissionPoint(CompanyEmissionPointModel point) {
    final idx = company.emissionPoints.indexOf(point);
    selectedEmissionPointIndex = idx >= 0 ? idx : null;
    _syncSelectedPointFields(point);
    // Persistir en Preferences
    Preferences.saveActiveEmissionPoint(
      id: point.id,
      documentTypeId: point.documentTypeId,
      establishmentCode: point.establishmentCode,
      emissionPointCode: point.emissionPointCode,
      currentSequential: point.currentSequential,
    );
    notifyListeners();
  }

  /// Sincroniza los campos planos del company con el punto seleccionado
  void _syncSelectedPointFields(CompanyEmissionPointModel point) {
    company.documentTypeId = point.documentTypeId;
    company.establishmentCode = point.establishmentCode;
    company.emissionPointCode = point.emissionPointCode;
    company.currentSequential = point.currentSequential;
    company.description = point.description;
    company.isActive = point.isActive;
  }

  /// Inicializa la selección con el primer punto activo existente (si hay)
  void initEmissionPointSelection() {
    final savedId = Preferences.activeEmissionPointId;
    final points = company.emissionPoints;
    if (points.isEmpty) return;
    // Intentar restaurar por id guardado en prefs
    int idx = savedId != null ? points.indexWhere((p) => p.id == savedId) : -1;
    if (idx < 0) {
      // Fallback: primer punto activo o el primero de la lista
      idx = points.indexWhere((p) => p.isActive);
      if (idx < 0) idx = 0;
    }
    selectedEmissionPointIndex = idx;
    _syncSelectedPointFields(points[idx]);
  }
}
