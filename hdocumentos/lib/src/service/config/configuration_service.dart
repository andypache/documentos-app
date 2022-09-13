import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';

class ConfigurationService extends ChangeNotifier {
  late ConfigurationModel configuration = ConfigurationModel.empty();

  bool isLoading = false;
  File? newPictureFile;

  Future<ConfigurationModel> loadConfiguration(BuildContext context) async {
    isLoading = true;
    print("ENTRA");
    ServiceResponseModel response = await postFetch(
        context: context,
        url: apiDataCompany,
        body: {"email": Preferences.userSession.email});

    print(response.body);

    isLoading = false;
    //notifyListeners();

    return configuration;
  }

  void updateSelectedImage(String path) {
    configuration.pathImage = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }
}
