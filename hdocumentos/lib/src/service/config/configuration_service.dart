import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';

///Create a service for interact screen to configuration service
class ConfigurationService extends ChangeNotifier {
  late ConfigurationModel configuration = ConfigurationModel.empty();
  bool isLoading = false;
  File? newPictureFile;

  ConfigurationService(BuildContext context) {
    _loadConfiguration(context);
  }

  Future<ConfigurationModel> _loadConfiguration(BuildContext context) async {
    ServiceResponseModel response = await postFetch(
        context: context,
        url: apiDataCompany,
        body: {"email": Preferences.userSession.email});
    if (response.statusHttp != 200) {
      NotificationService.showSnackbarError(response.message);
    }

    return configuration;
  }

  //Call service to update image logo
  void updateSelectedImage(BuildContext context, String path) async {
    isLoading = true;
    notifyListeners();
    newPictureFile = File.fromUri(Uri(path: path));
    Uint8List? imagebytes =
        await newPictureFile?.readAsBytes(); //convert to bytes
    String base64string =
        base64.encode(imagebytes!); //convert bytes to base64 string

    ServiceResponseModel response = await postFetch(
        context: context,
        url: apiPrintingLogoRegisterCompany,
        body: {
          "code_company": Preferences.userSession.idCompany,
          "username": Preferences.userSession.username,
          "printing_logo": base64string
        });
    isLoading = false;
    notifyListeners();
    if (response.statusHttp == 200) {
      configuration.pathImage = path;
      //NotificationService.showSnackbarSuccess(successMessage);
    } else {
      //NotificationService.showSnackbarError("$prefixError ${response.message}");
    }
  }
}
