import 'dart:convert';

import 'package:hdocumentos/src/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Class to save preferences systems
class Preferences {
  ///Init preferences
  static late SharedPreferences _preferences;
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static bool _keepSession = true;

  //propertiy for get user preference
  static UserSessionModel get userSession {
    final session = _preferences.getString('userSession');
    if (session != null) {
      return UserSessionModel.fromJsonObj(json.decode(session));
    }
    return UserSessionModel.empty();
  }

  //Put the user session
  static set userSession(UserSessionModel userSession) {
    _preferences.setString('userSession', json.encode(userSession.toJson()));
  }

  //Get Keep Session
  // ignore: unnecessary_getters_setters
  static bool get keepSession {
    return _keepSession;
  }

  //Put Keep Session
  static set keepSession(bool keepSession) {
    _keepSession = keepSession;
  }

  /// Idioma de la aplicación (es / en)
  static String get language {
    return _preferences.getString('language') ?? 'es';
  }

  static set language(String lang) {
    _preferences.setString('language', lang);
  }

  //Remove user
  static removeUser() {
    userSession = UserSessionModel.empty();
  }
}
