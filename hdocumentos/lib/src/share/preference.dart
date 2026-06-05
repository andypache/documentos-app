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

  // ── Punto de emisión activo seleccionado en el wizard ─────────────────────

  /// ID del punto de emisión activo (uuid del backend)
  static String? get activeEmissionPointId =>
      _preferences.getString('activeEmissionPointId');

  static set activeEmissionPointId(String? id) {
    if (id == null) {
      _preferences.remove('activeEmissionPointId');
    } else {
      _preferences.setString('activeEmissionPointId', id);
    }
  }

  /// Tipo de documento del punto de emisión activo
  static String? get activeDocumentTypeId =>
      _preferences.getString('activeDocumentTypeId');

  static set activeDocumentTypeId(String? v) {
    if (v == null) {
      _preferences.remove('activeDocumentTypeId');
    } else {
      _preferences.setString('activeDocumentTypeId', v);
    }
  }

  /// Código de establecimiento del punto activo
  static String? get activeEstablishmentCode =>
      _preferences.getString('activeEstablishmentCode');

  static set activeEstablishmentCode(String? v) {
    if (v == null) {
      _preferences.remove('activeEstablishmentCode');
    } else {
      _preferences.setString('activeEstablishmentCode', v);
    }
  }

  /// Código del punto de emisión activo
  static String? get activeEmissionPointCode =>
      _preferences.getString('activeEmissionPointCode');

  static set activeEmissionPointCode(String? v) {
    if (v == null) {
      _preferences.remove('activeEmissionPointCode');
    } else {
      _preferences.setString('activeEmissionPointCode', v);
    }
  }

  /// Guarda un punto de emisión completo como el activo
  static void saveActiveEmissionPoint({
    required String? id,
    required String? documentTypeId,
    required String? establishmentCode,
    required String? emissionPointCode,
  }) {
    activeEmissionPointId = id;
    activeDocumentTypeId = documentTypeId;
    activeEstablishmentCode = establishmentCode;
    activeEmissionPointCode = emissionPointCode;
  }

  /// Elimina el punto de emisión activo guardado
  static void clearActiveEmissionPoint() {
    _preferences.remove('activeEmissionPointId');
    _preferences.remove('activeDocumentTypeId');
    _preferences.remove('activeEstablishmentCode');
    _preferences.remove('activeEmissionPointCode');
  }
}
