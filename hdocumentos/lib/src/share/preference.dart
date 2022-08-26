import 'dart:convert';

import 'package:hdocumentos/src/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Class to save preferences systems
class Preferences {
  static late SharedPreferences _preferences;
  //Usersession properties
  static UserSessionModel _userSession = UserSessionModel(
      id: 0,
      username: "",
      email: "",
      identification: "",
      idCompany: 0,
      surnames: "",
      names: "");

  ///Init preferences
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  //propertiy for get user preference
  static UserSessionModel get userSession {
    UserSessionModel response = UserSessionModel(
        id: 0,
        username: "",
        email: "",
        identification: "",
        idCompany: 0,
        surnames: "",
        names: "");
    String? session = _preferences.getString('userSession');

    if (session != null) {
      return UserSessionModel.fromJsonObj(json.decode(session));
    }
    return response;
  }

  //Put the user session
  static set userSession(UserSessionModel userSession) {
    _userSession = userSession;
    _preferences.setString('userSession', json.encode(_userSession.toJson()));
  }

  //Remove user
  static removeUser() {
    userSession = UserSessionModel(
        id: 0,
        username: "",
        email: "",
        identification: "",
        idCompany: 0,
        surnames: "",
        names: "");
  }
}
