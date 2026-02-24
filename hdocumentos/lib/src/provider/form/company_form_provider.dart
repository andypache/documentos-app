import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';

/// Provider para el wizard de configuración de compañia
class CompanyFormProvider extends ChangeNotifier {
  // Keys de formulario por paso
  final GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep4 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep5 = GlobalKey<FormState>();

  int _currentStep = 0;
  int get currentStep => _currentStep;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  CompanyModel company;
  File? logoFile;
  File? certificateFile;
  Uint8List? logoBytes;

  CompanyFormProvider(this.company);

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
    if (_currentStep < 4) {
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
    if (step >= 0 && step <= 4) {
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

  /// Construye el CompanyModel final
  CompanyModel buildCompanyModel() => company;

  /// Carga los datos de la compañia desde el modelo
  void loadFromModel(CompanyModel model) {
    company = model;
    notifyListeners();
  }
}
