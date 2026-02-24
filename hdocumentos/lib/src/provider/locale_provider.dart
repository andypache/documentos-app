import 'package:flutter/material.dart';
import 'package:hdocumentos/src/share/preference.dart';

/// Provider global para manejar el idioma de la aplicación
class LocaleProvider extends ChangeNotifier {
  Locale _locale;

  LocaleProvider() : _locale = Locale(Preferences.language);

  Locale get locale => _locale;

  bool get isSpanish => _locale.languageCode == 'es';

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    Preferences.language = locale.languageCode;
    notifyListeners();
  }

  void toggleLanguage() {
    setLocale(
        _locale.languageCode == 'es' ? const Locale('en') : const Locale('es'));
  }
}
