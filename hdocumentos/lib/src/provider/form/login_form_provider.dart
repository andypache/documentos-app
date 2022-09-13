import 'package:flutter/material.dart';

///Provider for management login form, send and management login form
class LoginFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String username = "";
  String password = "";
  bool keepSession = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //change loading and send signal for rebuild widgets
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //validate if login form its complete
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
