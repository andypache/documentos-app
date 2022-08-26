import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';

class ConfigurationService extends ChangeNotifier {
  late ConfigurationModel configuration = ConfigurationModel.empty();

  bool isLoading = false;
  File? newPictureFile;

  Future<ConfigurationModel> loadConfiguration() async {
    isLoading = true;

    isLoading = false;
    notifyListeners();

    return configuration;
  }

  void updateSelectedImage(String path) {
    configuration.pathImage = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }
}
