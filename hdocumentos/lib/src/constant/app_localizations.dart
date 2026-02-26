import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'constant/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// Título pantalla editar compañía
  ///
  /// In es, this message translates to:
  /// **'Editar Compañía'**
  String get configEditTitle;

  /// Título pantalla nueva compañía
  ///
  /// In es, this message translates to:
  /// **'Nueva Compañía'**
  String get configNewTitle;

  /// Subtítulo editar compañía
  ///
  /// In es, this message translates to:
  /// **'Actualiza la información de tu empresa'**
  String get configEditSubtitle;

  /// Subtítulo nueva compañía
  ///
  /// In es, this message translates to:
  /// **'Configura tu empresa paso a paso'**
  String get configNewSubtitle;

  /// Etiqueta paso 1 del wizard
  ///
  /// In es, this message translates to:
  /// **'Empresa'**
  String get stepCompany;

  /// Etiqueta paso 2 del wizard
  ///
  /// In es, this message translates to:
  /// **'Logo'**
  String get stepLogo;

  /// Etiqueta paso 3 del wizard
  ///
  /// In es, this message translates to:
  /// **'Cert.'**
  String get stepCert;

  /// Etiqueta paso 4 del wizard
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get stepMail;

  /// Etiqueta paso 5 del wizard
  ///
  /// In es, this message translates to:
  /// **'Emisión'**
  String get stepEmission;

  /// Botón ir al paso anterior
  ///
  /// In es, this message translates to:
  /// **'Anterior'**
  String get btnPrevious;

  /// Botón cancelar
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get btnCancel;

  /// Botón ir al siguiente paso
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get btnNext;

  /// Botón guardar
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get btnSave;

  /// Texto mientras se guarda
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get btnSaving;

  /// Indicador de paso actual
  ///
  /// In es, this message translates to:
  /// **'{current} de {total}'**
  String stepCounter(int current, int total);

  /// Mensaje de validación campos requeridos
  ///
  /// In es, this message translates to:
  /// **'Completa los campos requeridos'**
  String get msgRequiredFields;

  /// Mensaje de éxito al guardar compañía
  ///
  /// In es, this message translates to:
  /// **'Compañía \"{name}\" guardada exitosamente'**
  String companySavedSuccess(String name);

  /// Mensaje de error al guardar
  ///
  /// In es, this message translates to:
  /// **'Error al guardar: {error}'**
  String saveError(String error);

  /// No description provided for @companyDetails.
  ///
  /// In es, this message translates to:
  /// **'Datos de la empresa'**
  String get companyDetails;

  /// No description provided for @enteredSoFar.
  ///
  /// In es, this message translates to:
  /// **'Ingresado hasta ahora'**
  String get enteredSoFar;

  /// No description provided for @requiredSelect.
  ///
  /// In es, this message translates to:
  /// **'Seleccione el tipo (requerido)'**
  String get requiredSelect;

  /// No description provided for @requiredField.
  ///
  /// In es, this message translates to:
  /// **'Campo requerido'**
  String get requiredField;

  /// No description provided for @companyInformation.
  ///
  /// In es, this message translates to:
  /// **'Datos de la Empresa'**
  String get companyInformation;

  /// No description provided for @identificationType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de identificación'**
  String get identificationType;

  /// No description provided for @identificationNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de identificación'**
  String get identificationNumber;

  /// No description provided for @identificationNumberHint.
  ///
  /// In es, this message translates to:
  /// **'RUC / Cédula (requerido)'**
  String get identificationNumberHint;

  /// No description provided for @companyName.
  ///
  /// In es, this message translates to:
  /// **'Razón social'**
  String get companyName;

  /// No description provided for @companyNameHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la empresa (requerido)'**
  String get companyNameHint;

  /// No description provided for @address.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get address;

  /// No description provided for @addressHint.
  ///
  /// In es, this message translates to:
  /// **'Dirección de la empresa (requerido)'**
  String get addressHint;

  /// No description provided for @telephone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get telephone;

  /// No description provided for @telephoneHint.
  ///
  /// In es, this message translates to:
  /// **'Teléfono (opcional)'**
  String get telephoneHint;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In es, this message translates to:
  /// **'Email corporativo (requerido)'**
  String get emailHint;

  /// No description provided for @activeCompany.
  ///
  /// In es, this message translates to:
  /// **'Empresa activa'**
  String get activeCompany;

  /// No description provided for @initApplicationError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar los catálogos del sistema'**
  String get initApplicationError;

  /// No description provided for @invalidDataFormatForCatalogs.
  ///
  /// In es, this message translates to:
  /// **'Error en el formato de los catálogos del sistema'**
  String get invalidDataFormatForCatalogs;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
