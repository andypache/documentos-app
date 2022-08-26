import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';

///Provider for management configuration form, management information company
class ConfigurationFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ConfigurationModel configuration;

  ConfigurationFormProvider(this.configuration);

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  File? newCertificateFile;

  //change loading and send signal for rebuild widgets
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  updateAvailability(bool value) {
    notifyListeners();
  }

  //validate if login form its complete
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void updateCertificate(String path) {
    configuration.pathCertificate = path;
    newCertificateFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }
}
