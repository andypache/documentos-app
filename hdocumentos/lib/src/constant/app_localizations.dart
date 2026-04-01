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

  /// Validación: campo obligatorio
  ///
  /// In es, this message translates to:
  /// **'Campo requerido'**
  String get validatorRequired;

  /// Validación: formato de email inválido
  ///
  /// In es, this message translates to:
  /// **'Ingresa un correo electrónico válido'**
  String get validatorEmail;

  /// Validación: solo dígitos
  ///
  /// In es, this message translates to:
  /// **'Solo se permiten números'**
  String get validatorNumeric;

  /// Validación: alfanumérico
  ///
  /// In es, this message translates to:
  /// **'Solo se permiten letras y números'**
  String get validatorAlphanumeric;

  /// Validación: formato de teléfono
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número de teléfono válido'**
  String get validatorPhone;

  /// Validación: formato de URL
  ///
  /// In es, this message translates to:
  /// **'Ingresa una URL válida (http:// o https://)'**
  String get validatorUrl;

  /// Validación: rango de puerto de red
  ///
  /// In es, this message translates to:
  /// **'Ingresa un puerto válido (1 - 65535)'**
  String get validatorPort;

  /// Validación: espacios extremos
  ///
  /// In es, this message translates to:
  /// **'No puede iniciar ni terminar con espacios'**
  String get validatorNoSpaces;

  /// Validación: longitud mínima
  ///
  /// In es, this message translates to:
  /// **'Mínimo {min} caracteres'**
  String validatorMinLength(int min);

  /// Validación: longitud máxima
  ///
  /// In es, this message translates to:
  /// **'Máximo {max} caracteres'**
  String validatorMaxLength(int max);

  /// Validación: longitud exacta
  ///
  /// In es, this message translates to:
  /// **'Debe tener exactamente {length} caracteres'**
  String validatorExactLength(int length);

  /// Botón guardar el paso actual en modo edición
  ///
  /// In es, this message translates to:
  /// **'Guardar este paso'**
  String get btnSaveStep;

  /// Etiqueta paso 6 del wizard
  ///
  /// In es, this message translates to:
  /// **'Impuestos'**
  String get stepTaxes;

  /// Título sección paso 2
  ///
  /// In es, this message translates to:
  /// **'Logo y Configuración Web'**
  String get step2Title;

  /// Etiqueta para el selector de logo
  ///
  /// In es, this message translates to:
  /// **'Logo de la empresa'**
  String get step2LogoLabel;

  /// Etiqueta campo sitio web
  ///
  /// In es, this message translates to:
  /// **'Sitio web'**
  String get step2Website;

  /// Hint campo sitio web
  ///
  /// In es, this message translates to:
  /// **'https://www.empresa.com (opcional)'**
  String get step2WebsiteHint;

  /// Etiqueta campo descuento máximo
  ///
  /// In es, this message translates to:
  /// **'Descuento máximo (%)'**
  String get step2MaxDiscount;

  /// Hint campo descuento máximo
  ///
  /// In es, this message translates to:
  /// **'Ej: 10.00 (opcional)'**
  String get step2MaxDiscountHint;

  /// Etiqueta campo dirección artículos
  ///
  /// In es, this message translates to:
  /// **'Dirección de artículos'**
  String get step2ItemAddress;

  /// Hint campo dirección artículos
  ///
  /// In es, this message translates to:
  /// **'Dirección alternativa (opcional)'**
  String get step2ItemAddressHint;

  /// Texto cuando hay logo cargado en resumen
  ///
  /// In es, this message translates to:
  /// **'Logo cargado'**
  String get step2LogoLoaded;

  /// Texto en resumen con el descuento máximo
  ///
  /// In es, this message translates to:
  /// **'Descuento máx: {value}%'**
  String step2MaxDiscountSummary(String value);

  /// Título sección paso 3
  ///
  /// In es, this message translates to:
  /// **'Certificado Electrónico'**
  String get step3Title;

  /// Texto botón cuando no hay certificado cargado
  ///
  /// In es, this message translates to:
  /// **'Cargar firma electrónica (.p12 / .cert)'**
  String get step3CertButton;

  /// Texto botón cuando hay certificado cargado
  ///
  /// In es, this message translates to:
  /// **'Certificado cargado ✓'**
  String get step3CertLoaded;

  /// Mensaje de error cuando no hay certificado
  ///
  /// In es, this message translates to:
  /// **'El certificado es requerido'**
  String get step3CertRequired;

  /// Texto en resumen cuando hay certificado
  ///
  /// In es, this message translates to:
  /// **'Certificado cargado'**
  String get step3CertSummary;

  /// Etiqueta campo usuario del certificado
  ///
  /// In es, this message translates to:
  /// **'Usuario del certificado'**
  String get certificateUser;

  /// Hint campo usuario del certificado
  ///
  /// In es, this message translates to:
  /// **'Nombre del titular (requerido)'**
  String get certificateUserHint;

  /// Etiqueta campo contraseña del certificado
  ///
  /// In es, this message translates to:
  /// **'Contraseña del certificado'**
  String get certificatePassword;

  /// Hint campo contraseña del certificado
  ///
  /// In es, this message translates to:
  /// **'Contraseña (requerido)'**
  String get certificatePasswordHint;

  /// Etiqueta campo fecha expiración del certificado
  ///
  /// In es, this message translates to:
  /// **'Fecha de expiración'**
  String get certificateExpiration;

  /// Hint campo fecha expiración del certificado
  ///
  /// In es, this message translates to:
  /// **'Fecha de caducidad (requerido)'**
  String get certificateExpirationHint;

  /// Texto resumen fecha de expiración
  ///
  /// In es, this message translates to:
  /// **'Expira: {date}'**
  String certificateExpiresSummary(String date);

  /// Título sección paso 4
  ///
  /// In es, this message translates to:
  /// **'Configuración de Correo'**
  String get step4Title;

  /// Nota informativa paso 4
  ///
  /// In es, this message translates to:
  /// **'Campos opcionales. Se usan para el envío de facturas por correo.'**
  String get step4InfoNote;

  /// Etiqueta campo servidor de correo
  ///
  /// In es, this message translates to:
  /// **'Servidor de correo'**
  String get mailServer;

  /// Hint campo servidor de correo
  ///
  /// In es, this message translates to:
  /// **'smtp.gmail.com (opcional)'**
  String get mailServerHint;

  /// Etiqueta campo puerto SMTP
  ///
  /// In es, this message translates to:
  /// **'Puerto'**
  String get mailPort;

  /// Hint campo puerto SMTP
  ///
  /// In es, this message translates to:
  /// **'587 / 465 (opcional)'**
  String get mailPortHint;

  /// Texto resumen del puerto de correo
  ///
  /// In es, this message translates to:
  /// **'Puerto: {port}'**
  String mailPortSummary(String port);

  /// Etiqueta campo dirección de correo
  ///
  /// In es, this message translates to:
  /// **'Dirección de correo remitente'**
  String get mailAddress;

  /// Hint campo dirección de correo
  ///
  /// In es, this message translates to:
  /// **'correo@empresa.com (opcional)'**
  String get mailAddressHint;

  /// Etiqueta campo usuario SMTP
  ///
  /// In es, this message translates to:
  /// **'Usuario de correo'**
  String get mailUser;

  /// Hint campo usuario SMTP
  ///
  /// In es, this message translates to:
  /// **'Usuario SMTP (opcional)'**
  String get mailUserHint;

  /// Etiqueta campo contraseña SMTP
  ///
  /// In es, this message translates to:
  /// **'Contraseña de correo'**
  String get mailPassword;

  /// Hint campo contraseña SMTP
  ///
  /// In es, this message translates to:
  /// **'Contraseña SMTP (opcional)'**
  String get mailPasswordHint;

  /// Título sección paso 5
  ///
  /// In es, this message translates to:
  /// **'Punto de Emisión'**
  String get step5Title;

  /// Etiqueta campo tipo de documento
  ///
  /// In es, this message translates to:
  /// **'Tipo de documento'**
  String get docType;

  /// Hint campo tipo de documento
  ///
  /// In es, this message translates to:
  /// **'Seleccione el tipo (requerido)'**
  String get docTypeHint;

  /// Etiqueta campo código establecimiento
  ///
  /// In es, this message translates to:
  /// **'Código del establecimiento'**
  String get establishmentCode;

  /// Hint campo código establecimiento
  ///
  /// In es, this message translates to:
  /// **'Ej: 001 (requerido)'**
  String get establishmentCodeHint;

  /// Etiqueta campo código punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Código del punto de emisión'**
  String get emissionPointCode;

  /// Hint campo código punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Ej: 001 (requerido)'**
  String get emissionPointCodeHint;

  /// Etiqueta campo secuencial actual
  ///
  /// In es, this message translates to:
  /// **'Secuencial actual'**
  String get currentSequential;

  /// Hint campo secuencial actual
  ///
  /// In es, this message translates to:
  /// **'Número inicial (requerido)'**
  String get currentSequentialHint;

  /// Etiqueta campo descripción punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get emissionDescription;

  /// Hint campo descripción punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Descripción del punto de emisión (opcional)'**
  String get emissionDescriptionHint;

  /// Etiqueta switch punto de emisión activo
  ///
  /// In es, this message translates to:
  /// **'Punto de emisión activo'**
  String get activeEmissionPoint;

  /// Título del widget resumen final (paso 5)
  ///
  /// In es, this message translates to:
  /// **'Resumen completo'**
  String get finalSummaryTitle;

  /// Etiqueta razón social en resumen
  ///
  /// In es, this message translates to:
  /// **'Razón social'**
  String get summaryCompanyName;

  /// Etiqueta identificación en resumen
  ///
  /// In es, this message translates to:
  /// **'Identificación'**
  String get summaryIdentification;

  /// Etiqueta dirección en resumen
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get summaryAddress;

  /// Etiqueta email en resumen
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get summaryEmail;

  /// Etiqueta web en resumen
  ///
  /// In es, this message translates to:
  /// **'Web'**
  String get summaryWebsite;

  /// Etiqueta establecimiento en resumen
  ///
  /// In es, this message translates to:
  /// **'Establecimiento'**
  String get summaryEstablishment;

  /// Etiqueta punto de emisión en resumen
  ///
  /// In es, this message translates to:
  /// **'Pto. emisión'**
  String get summaryEmissionPoint;

  /// Etiqueta certificado en resumen
  ///
  /// In es, this message translates to:
  /// **'Certificado'**
  String get summaryCertificate;

  /// Valor certificado cargado en resumen
  ///
  /// In es, this message translates to:
  /// **'Cargado ✓'**
  String get summaryCertLoaded;

  /// Valor certificado no cargado en resumen
  ///
  /// In es, this message translates to:
  /// **'No cargado'**
  String get summaryCertNotLoaded;

  /// Título sección paso 6
  ///
  /// In es, this message translates to:
  /// **'Grupos de Impuesto'**
  String get step6Title;
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
