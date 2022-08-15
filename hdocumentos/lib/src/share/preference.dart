import 'dart:convert';

import 'package:hdocumentos/src/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Class to save preferences systems
class Preferences {
  static late SharedPreferences _preferences;
  //Usersession properties
  static UserSession _userSession = UserSession(
      id: "",
      username: "",
      email: "",
      identification: "",
      lastname: "",
      surname: "",
      name: "");

  ///Init preferences
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  //propertiy for get user preference
  static UserSession get userSession {
    UserSession response = UserSession(
        id: "",
        username: "",
        email: "",
        identification: "",
        lastname: "",
        surname: "",
        name: "");
    String? session = _preferences.getString('userSession');

    if (session != null) {
      return UserSession.fromJsonObj(json.decode(session));
    }
    return response;
  }

  //Put the user session
  static set userSession(UserSession userSession) {
    _userSession = userSession;
    _preferences.setString('userSession', json.encode(_userSession.toJson()));
  }

  //Remove user
  static removeUser() {
    userSession = UserSession(
        id: "",
        username: "",
        email: "",
        identification: "",
        lastname: "",
        surname: "",
        name: "");
  }
}
