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

  /// Validación: número decimal
  ///
  /// In es, this message translates to:
  /// **'Solo se permiten números decimales'**
  String get validatorDecimal;

  /// Validación: alfanumérico básico
  ///
  /// In es, this message translates to:
  /// **'Solo se permiten letras y números sin caracteres especiales'**
  String get validatorAlphanumericBasic;

  /// Validación: la fecha debe ser futura
  ///
  /// In es, this message translates to:
  /// **'La fecha debe ser posterior a hoy'**
  String get validatorDateMustBeFuture;

  /// Validación: fecha inválida
  ///
  /// In es, this message translates to:
  /// **'Fecha inválida'**
  String get validatorInvalidDate;

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

  /// Validación: valor mínimo numérico
  ///
  /// In es, this message translates to:
  /// **'El valor mínimo es {min}'**
  String validatorMinValue(int min);

  /// Botón guardar el paso actual en modo edición
  ///
  /// In es, this message translates to:
  /// **'Guardar este paso'**
  String get btnSaveStep;

  /// Etiqueta paso 1 del wizard de producto
  ///
  /// In es, this message translates to:
  /// **'Básica'**
  String get stepBasic;

  /// Etiqueta paso 2 del wizard de producto
  ///
  /// In es, this message translates to:
  /// **'Precios'**
  String get stepPrices;

  /// Etiqueta paso 3 del wizard de producto
  ///
  /// In es, this message translates to:
  /// **'Códigos'**
  String get stepCodes;

  /// Etiqueta paso 4 del wizard de producto
  ///
  /// In es, this message translates to:
  /// **'Impuestos'**
  String get stepTaxes;

  /// Etiqueta paso 1 del wizard de cliente
  ///
  /// In es, this message translates to:
  /// **'Datos'**
  String get stepCustomerData;

  /// Etiqueta paso 2 del wizard de cliente
  ///
  /// In es, this message translates to:
  /// **'Contacto'**
  String get stepCustomerContact;

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

  /// Toggle para cambiar la contraseña del certificado en edición
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña del certificado'**
  String get certChangePassword;

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

  /// Toggle para cambiar la contraseña SMTP en edición
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña de correo'**
  String get mailChangePassword;

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

  /// Título tarjeta guía de impuestos
  ///
  /// In es, this message translates to:
  /// **'Guía rápida'**
  String get step6TaxGuideTitle;

  /// Cuerpo tarjeta guía de impuestos
  ///
  /// In es, this message translates to:
  /// **'Selecciona los grupos de impuesto que aplican a los productos o servicios que vende tu empresa.'**
  String get step6TaxGuideBody;

  /// Botón para agregar nuevo punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Agregar punto'**
  String get emissionPointAddBtn;

  /// Botón editar punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get emissionPointEditBtn;

  /// Botón eliminar punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get emissionPointDeleteBtn;

  /// Botón guardar punto de emisión en el form
  ///
  /// In es, this message translates to:
  /// **'Guardar punto'**
  String get emissionPointSaveBtn;

  /// Botón cancelar edición de punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get emissionPointCancelBtn;

  /// Etiqueta para seleccionar el punto activo
  ///
  /// In es, this message translates to:
  /// **'Punto activo de facturación'**
  String get emissionPointSelectLabel;

  /// Mensaje cuando la lista de puntos está vacía
  ///
  /// In es, this message translates to:
  /// **'No hay puntos de emisión. Agrega al menos uno.'**
  String get emissionPointEmptyMsg;

  /// Título del formulario de nuevo punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Nuevo punto de emisión'**
  String get emissionPointFormTitle;

  /// Título del formulario de edición de punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Editar punto de emisión'**
  String get emissionPointEditFormTitle;

  /// Mensaje de confirmación para eliminar un punto de emisión
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar este punto de emisión?'**
  String get emissionPointDeleteConfirm;

  /// Chip de estado activo en la card del punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get emissionPointActiveChip;

  /// Chip de estado inactivo en la card del punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Inactivo'**
  String get emissionPointInactiveChip;

  /// Hint cuando el punto está seleccionado como activo
  ///
  /// In es, this message translates to:
  /// **'Seleccionado para facturación'**
  String get emissionPointSelectedHint;

  /// Texto de carga genérico
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// Botón para reintentar una operación
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get btnRetry;

  /// Botón para cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get btnLogout;

  /// Mensaje cuando un paso del wizard se guarda exitosamente
  ///
  /// In es, this message translates to:
  /// **'Paso guardado correctamente'**
  String get stepSavedSuccess;

  /// Título de la pantalla de login
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get loginTitle;

  /// Subtítulo de la pantalla de login
  ///
  /// In es, this message translates to:
  /// **'Ingresa tus credenciales para continuar'**
  String get loginSubtitle;

  /// Etiqueta campo usuario
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get loginFieldUser;

  /// Hint campo usuario
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu usuario'**
  String get loginFieldUserHint;

  /// Etiqueta campo contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get loginFieldPassword;

  /// Hint campo contraseña
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu contraseña'**
  String get loginFieldPasswordHint;

  /// Label checkbox mantener sesión
  ///
  /// In es, this message translates to:
  /// **'Mantener sesión iniciada'**
  String get loginKeepSession;

  /// Botón de login
  ///
  /// In es, this message translates to:
  /// **'Ingresar'**
  String get loginBtnSignIn;

  /// Botón mientras se procesa el login
  ///
  /// In es, this message translates to:
  /// **'Ingresando...'**
  String get loginBtnSigningIn;

  /// Enlace para ir al registro
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? Regístrate'**
  String get loginRegisterLink;

  /// Error campo usuario vacío
  ///
  /// In es, this message translates to:
  /// **'El usuario es requerido'**
  String get loginErrUserRequired;

  /// Error usuario muy corto
  ///
  /// In es, this message translates to:
  /// **'Mínimo 3 caracteres'**
  String get loginErrUserMin;

  /// Error campo contraseña vacío
  ///
  /// In es, this message translates to:
  /// **'La contraseña es requerida'**
  String get loginErrPasswordRequired;

  /// Error contraseña muy corta
  ///
  /// In es, this message translates to:
  /// **'Mínimo 4 caracteres'**
  String get loginErrPasswordMin;

  /// Error genérico de login
  ///
  /// In es, this message translates to:
  /// **'No se pudo iniciar sesión. Intente más tarde'**
  String get loginErrGeneral;

  /// Menú facturación
  ///
  /// In es, this message translates to:
  /// **'FACTURAR'**
  String get homeMenuBill;

  /// Descripción menú facturación
  ///
  /// In es, this message translates to:
  /// **'Genere sus facturas para un bien o servicio'**
  String get homeMenuBillDesc;

  /// Menú clientes
  ///
  /// In es, this message translates to:
  /// **'CLIENTES'**
  String get homeMenuClient;

  /// Descripción menú clientes
  ///
  /// In es, this message translates to:
  /// **'Gestione sus clientes, cree, edite o elimine'**
  String get homeMenuClientDesc;

  /// Menú productos
  ///
  /// In es, this message translates to:
  /// **'PRODUCTOS'**
  String get homeMenuItem;

  /// Descripción menú productos
  ///
  /// In es, this message translates to:
  /// **'Gestione sus productos, cree, edite o elimine'**
  String get homeMenuItemDesc;

  /// Menú reportes
  ///
  /// In es, this message translates to:
  /// **'REPORTES'**
  String get homeMenuReport;

  /// Descripción menú reportes
  ///
  /// In es, this message translates to:
  /// **'Genere sus facturas en pdf'**
  String get homeMenuReportDesc;

  /// Menú revisión
  ///
  /// In es, this message translates to:
  /// **'REVISIÓN'**
  String get homeMenuReview;

  /// Descripción menú revisión
  ///
  /// In es, this message translates to:
  /// **'Verifique sus facturas en el SRI'**
  String get homeMenuReviewDesc;

  /// Menú configuración
  ///
  /// In es, this message translates to:
  /// **'CONFIGURACIÓN'**
  String get homeMenuConfig;

  /// Descripción menú configuración
  ///
  /// In es, this message translates to:
  /// **'Configure su empresa, cambie su imagen y firma electrónica'**
  String get homeMenuConfigDesc;

  /// Título sección mis ventas
  ///
  /// In es, this message translates to:
  /// **'Mis Ventas'**
  String get homeSalesTitle;

  /// Título empty state mis ventas
  ///
  /// In es, this message translates to:
  /// **'Sin ventas registradas'**
  String get homeSalesEmpty;

  /// Descripción empty state mis ventas
  ///
  /// In es, this message translates to:
  /// **'Tus facturas aparecerán aquí una vez que generes tu primera venta.'**
  String get homeSalesEmptyDesc;

  /// Botón CTA empty state mis ventas
  ///
  /// In es, this message translates to:
  /// **'Crear factura'**
  String get homeSalesEmptyAction;

  /// Etiqueta nav factura
  ///
  /// In es, this message translates to:
  /// **'Factura'**
  String get navBill;

  /// Etiqueta nav reportes
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get navReports;

  /// Etiqueta nav configuración
  ///
  /// In es, this message translates to:
  /// **'Configurar'**
  String get navConfig;

  /// Etiqueta nav salir
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get navLogout;

  /// Título del diálogo de confirmación de recarga
  ///
  /// In es, this message translates to:
  /// **'Actualizar parámetros'**
  String get reloadDialogTitle;

  /// Cuerpo del diálogo de confirmación de recarga
  ///
  /// In es, this message translates to:
  /// **'¿Deseas actualizar nuevamente los parámetros del sistema y los datos de la empresa?'**
  String get reloadDialogBody;

  /// Botón confirmar recarga
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get reloadDialogConfirm;

  /// Botón cancelar recarga
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get reloadDialogCancel;

  /// Mensaje de éxito tras la recarga
  ///
  /// In es, this message translates to:
  /// **'Parámetros actualizados correctamente'**
  String get reloadSuccess;

  /// Error cuando no hay puntos de emisión en el paso 5
  ///
  /// In es, this message translates to:
  /// **'Debes agregar al menos un punto de emisión para continuar'**
  String get emissionPointRequired;

  /// Error cuando no hay ningún punto de emisión activo en el paso 5
  ///
  /// In es, this message translates to:
  /// **'Debes tener al menos un punto de emisión activo para continuar'**
  String get emissionPointSelectRequired;

  /// Error al duplicar código de punto de emisión
  ///
  /// In es, this message translates to:
  /// **'Ya existe un punto con ese código de establecimiento y emisión'**
  String get emissionPointDuplicateCode;

  /// Error al intentar activar más de un punto
  ///
  /// In es, this message translates to:
  /// **'Ya hay un punto activo. Desactívalo antes de activar otro.'**
  String get emissionPointOnlyOneActive;

  /// Error al procesar la respuesta de la compañía desde el API
  ///
  /// In es, this message translates to:
  /// **'Error al procesar los datos de la compañía'**
  String get companyDataProcessError;

  /// Error cuando el API devuelve un formato inválido al crear la compañía
  ///
  /// In es, this message translates to:
  /// **'Formato de datos inválido para la compañía creada'**
  String get companyCreatedInvalidFormat;

  /// Error genérico cuando no se puede cargar la información desde el API
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la información'**
  String get couldNotLoadInfo;

  /// Botón aceptar / confirmar
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get btnAccept;

  /// Botón salir sin guardar
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get btnExit;

  /// Botón agregar elemento
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get btnAdd;

  /// Botón buscar
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get btnSearch;

  /// Botón ver todos los registros
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get btnShowAll;

  /// Botón crear nuevo cliente
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get btnNewCustomer;

  /// Botón asignar consumidor final
  ///
  /// In es, this message translates to:
  /// **'C. Final'**
  String get btnConsumerFinal;

  /// Botón agregar impuesto al producto
  ///
  /// In es, this message translates to:
  /// **'Agregar Impuesto'**
  String get btnAddTax;

  /// Botón guardar / emitir factura
  ///
  /// In es, this message translates to:
  /// **'Guardar Factura'**
  String get btnSaveInvoice;

  /// Título pantalla de facturación
  ///
  /// In es, this message translates to:
  /// **'Facturar'**
  String get billTitle;

  /// Título del panel resumen de factura
  ///
  /// In es, this message translates to:
  /// **'Resumen de Factura'**
  String get billSummaryTitle;

  /// Título diálogo confirmación guardar factura
  ///
  /// In es, this message translates to:
  /// **'¿Guardar Factura?'**
  String get billConfirmTitle;

  /// Línea cliente en diálogo confirmación
  ///
  /// In es, this message translates to:
  /// **'Cliente: {name}'**
  String billConfirmCustomer(String name);

  /// Línea productos en diálogo confirmación
  ///
  /// In es, this message translates to:
  /// **'Productos: {count}'**
  String billConfirmProducts(int count);

  /// Línea total en diálogo confirmación
  ///
  /// In es, this message translates to:
  /// **'Total: \${amount}'**
  String billConfirmTotal(String amount);

  /// Título diálogo éxito factura guardada
  ///
  /// In es, this message translates to:
  /// **'¡Factura Guardada!'**
  String get billSavedTitle;

  /// Mensaje diálogo éxito factura guardada
  ///
  /// In es, this message translates to:
  /// **'La factura se guardó exitosamente'**
  String get billSavedMsg;

  /// Título diálogo confirmar salida sin guardar
  ///
  /// In es, this message translates to:
  /// **'¿Salir sin guardar?'**
  String get billExitTitle;

  /// Cuerpo diálogo confirmar salida sin guardar
  ///
  /// In es, this message translates to:
  /// **'Hay datos sin guardar que se perderán.'**
  String get billExitMsg;

  /// Título wizard crear producto
  ///
  /// In es, this message translates to:
  /// **'Crear Producto'**
  String get itemCreateTitle;

  /// Subtítulo wizard crear producto
  ///
  /// In es, this message translates to:
  /// **'Completa la información del nuevo producto'**
  String get itemCreateSubtitle;

  /// Título wizard editar producto
  ///
  /// In es, this message translates to:
  /// **'Editar Producto'**
  String get itemEditTitle;

  /// Subtítulo wizard editar producto
  ///
  /// In es, this message translates to:
  /// **'Actualiza la información del producto'**
  String get itemEditSubtitle;

  /// Título wizard crear cliente
  ///
  /// In es, this message translates to:
  /// **'Nuevo Cliente'**
  String get customerCreateTitle;

  /// Título wizard editar cliente
  ///
  /// In es, this message translates to:
  /// **'Editar Cliente'**
  String get customerEditTitle;

  /// Mensaje éxito al crear producto
  ///
  /// In es, this message translates to:
  /// **'Producto guardado exitosamente'**
  String get itemCreatedSuccess;

  /// Error genérico al procesar item
  ///
  /// In es, this message translates to:
  /// **'Error al procesar la operación del producto'**
  String get itemDataProcessError;

  /// Mensaje éxito al actualizar producto
  ///
  /// In es, this message translates to:
  /// **'Producto actualizado exitosamente'**
  String get itemUpdatedSuccess;

  /// Mensaje éxito al crear cliente
  ///
  /// In es, this message translates to:
  /// **'Cliente creado exitosamente'**
  String get customerCreatedSuccess;

  /// Mensaje éxito al actualizar cliente
  ///
  /// In es, this message translates to:
  /// **'Cliente actualizado exitosamente'**
  String get customerUpdatedSuccess;

  /// Etiqueta sección productos en factura
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get labelProducts;

  /// Etiqueta sección impuestos
  ///
  /// In es, this message translates to:
  /// **'Impuestos'**
  String get labelTaxes;

  /// Etiqueta campo cantidad
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get labelQuantity;

  /// Etiqueta campo precio unitario
  ///
  /// In es, this message translates to:
  /// **'Precio Unitario'**
  String get labelUnitPrice;

  /// Etiqueta campo descuento
  ///
  /// In es, this message translates to:
  /// **'Descuento'**
  String get labelDiscount;

  /// Etiqueta subtotal en cálculos
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get labelSubtotal;

  /// Etiqueta total en cálculos
  ///
  /// In es, this message translates to:
  /// **'TOTAL'**
  String get labelTotal;

  /// Etiqueta total de impuestos
  ///
  /// In es, this message translates to:
  /// **'Total impuestos'**
  String get labelTotalTaxes;

  /// Etiqueta descuento aplicado en resumen
  ///
  /// In es, this message translates to:
  /// **'Descuento aplicado'**
  String get labelDiscountApplied;

  /// Chip descuento disponible en tarjeta cliente
  ///
  /// In es, this message translates to:
  /// **'¡DESCUENTO DISPONIBLE!'**
  String get labelDiscountAvailable;

  /// Texto valor descuento del cliente
  ///
  /// In es, this message translates to:
  /// **'{value}% de descuento'**
  String labelDiscountValue(String value);

  /// Texto validez descuento del cliente
  ///
  /// In es, this message translates to:
  /// **'Válido hasta: {date}'**
  String labelDiscountValid(String date);

  /// Etiqueta sección selección de cliente en factura
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Cliente'**
  String get labelSelectCustomer;

  /// Título diálogo editar producto en factura
  ///
  /// In es, this message translates to:
  /// **'Editar Producto'**
  String get labelEditProduct;

  /// Hint búsqueda de productos
  ///
  /// In es, this message translates to:
  /// **'Nombre, código o barras'**
  String get searchProductHint;

  /// Hint búsqueda de clientes
  ///
  /// In es, this message translates to:
  /// **'Nombre o identificación'**
  String get searchCustomerHint;

  /// Título diálogo buscar producto
  ///
  /// In es, this message translates to:
  /// **'Buscar Producto'**
  String get searchProductTitle;

  /// Título diálogo buscar cliente
  ///
  /// In es, this message translates to:
  /// **'Buscar Cliente'**
  String get searchCustomerTitle;

  /// Mensaje cuando no hay productos en factura
  ///
  /// In es, this message translates to:
  /// **'No hay productos agregados'**
  String get noProductsAdded;

  /// Hint para agregar productos
  ///
  /// In es, this message translates to:
  /// **'Toca \"Agregar\" para buscar productos'**
  String get noProductsAddedHint;

  /// Mensaje cuando no hay impuestos en producto
  ///
  /// In es, this message translates to:
  /// **'No hay impuestos agregados'**
  String get noTaxesAdded;

  /// Nota informativa sobre impuestos en producto
  ///
  /// In es, this message translates to:
  /// **'Los impuestos son opcionales. Puede agregarlos ahora o más tarde.'**
  String get taxInfoNote;

  /// Título pantalla de registro
  ///
  /// In es, this message translates to:
  /// **'Registrar Usuario'**
  String get registerTitle;

  /// Enlace a login desde la pantalla de registro
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes una cuenta? Inicia sesión'**
  String get registerHaveAccount;

  /// Etiqueta campo usuario en registro
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get registerFieldUser;

  /// Hint campo usuario en registro
  ///
  /// In es, this message translates to:
  /// **'Nombre del usuario'**
  String get registerFieldUserHint;

  /// Etiqueta campo contraseña en registro
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get registerFieldPassword;

  /// Hint campo contraseña en registro
  ///
  /// In es, this message translates to:
  /// **'Contraseña de usuario'**
  String get registerFieldPasswordHint;

  /// Botón de registro
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registerBtn;

  /// Hint cuando no se puede guardar la factura
  ///
  /// In es, this message translates to:
  /// **'Completa todos los campos requeridos'**
  String get billRequiredFieldsHint;

  /// Botón eliminar
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get btnDelete;

  /// Botón cargar todos los registros
  ///
  /// In es, this message translates to:
  /// **'Ver Todos'**
  String get btnLoadAll;

  /// Botón cargar últimos registros
  ///
  /// In es, this message translates to:
  /// **'Ver Últimos'**
  String get btnLoadLast;

  /// Botón crear nuevo producto
  ///
  /// In es, this message translates to:
  /// **'Nuevo Producto'**
  String get btnNewProduct;

  /// Título diálogo eliminar producto
  ///
  /// In es, this message translates to:
  /// **'Eliminar Producto'**
  String get deleteItemTitle;

  /// Confirmación eliminar producto
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de eliminar el producto \"{name}\"?'**
  String deleteItemConfirm(String name);

  /// Título diálogo eliminar cliente
  ///
  /// In es, this message translates to:
  /// **'Eliminar Cliente'**
  String get deleteCustomerTitle;

  /// Confirmación eliminar cliente
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de eliminar a \"{name}\"?'**
  String deleteCustomerConfirm(String name);

  /// Mensaje éxito al eliminar
  ///
  /// In es, this message translates to:
  /// **'Eliminado exitosamente'**
  String get deleteSuccess;

  /// Mensaje error al eliminar
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar'**
  String get deleteError;

  /// Mensaje éxito al eliminar producto
  ///
  /// In es, this message translates to:
  /// **'Producto eliminado exitosamente'**
  String get itemDeletedSuccess;

  /// Mensaje error al eliminar producto
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar el producto'**
  String get itemDeletedError;

  /// Mensaje éxito al eliminar cliente
  ///
  /// In es, this message translates to:
  /// **'Cliente eliminado exitosamente'**
  String get customerDeletedSuccess;

  /// Conteo de productos encontrados
  ///
  /// In es, this message translates to:
  /// **'{count} producto(s) encontrado(s)'**
  String itemsFound(int count);

  /// Conteo de clientes encontrados
  ///
  /// In es, this message translates to:
  /// **'{count} cliente(s) encontrado(s)'**
  String customersFound(int count);

  /// Sin productos encontrados
  ///
  /// In es, this message translates to:
  /// **'Sin Resultados'**
  String get noItemsFound;

  /// Mensaje detallado sin productos
  ///
  /// In es, this message translates to:
  /// **'No se encontraron productos con ese criterio'**
  String get noItemsFoundMsg;

  /// Sin clientes encontrados
  ///
  /// In es, this message translates to:
  /// **'Sin Resultados'**
  String get noCustomersFound;

  /// Mensaje detallado sin clientes
  ///
  /// In es, this message translates to:
  /// **'No se encontraron clientes con ese criterio'**
  String get noCustomersFoundMsg;

  /// Estado inicial búsqueda de productos
  ///
  /// In es, this message translates to:
  /// **'Buscar Productos'**
  String get searchItemsTitle;

  /// Mensaje estado inicial productos
  ///
  /// In es, this message translates to:
  /// **'Usa el buscador para encontrar productos\no visualiza todos los productos disponibles'**
  String get searchItemsMsg;

  /// Estado inicial búsqueda de clientes
  ///
  /// In es, this message translates to:
  /// **'Buscar Clientes'**
  String get searchCustomersTitle;

  /// Mensaje estado inicial clientes
  ///
  /// In es, this message translates to:
  /// **'Usa el buscador para encontrar clientes\no visualiza los últimos clientes registrados'**
  String get searchCustomersMsg;

  /// Badge de descuento en tarjeta de cliente
  ///
  /// In es, this message translates to:
  /// **'Descuento {pct}%'**
  String discountBadge(String pct);

  /// Título diálogo selección de impuesto
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Impuesto'**
  String get selectTaxTitle;

  /// Subtítulo diálogo selección de impuesto
  ///
  /// In es, this message translates to:
  /// **'Solo puede agregar un impuesto por grupo'**
  String get selectTaxSubtitle;

  /// Nombre grupo IVA
  ///
  /// In es, this message translates to:
  /// **'IVA (Impuesto al Valor Agregado)'**
  String get taxGroupIVA;

  /// Nombre grupo ICE
  ///
  /// In es, this message translates to:
  /// **'ICE (Impuesto a Consumos Especiales)'**
  String get taxGroupICE;

  /// Nombre otros grupos de impuestos
  ///
  /// In es, this message translates to:
  /// **'Otros Impuestos'**
  String get taxGroupOther;

  /// Etiqueta grupo de impuesto ya asignado
  ///
  /// In es, this message translates to:
  /// **'Ya asignado'**
  String get taxAssigned;

  /// Etiqueta campo clave de búsqueda
  ///
  /// In es, this message translates to:
  /// **'Clave de búsqueda'**
  String get labelSearchKey;

  /// Etiqueta código de barras
  ///
  /// In es, this message translates to:
  /// **'Código de barras'**
  String get labelBarCode;

  /// Etiqueta precio
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get labelPrice;

  /// Etiqueta costo
  ///
  /// In es, this message translates to:
  /// **'Costo'**
  String get labelCost;

  /// Etiqueta stock
  ///
  /// In es, this message translates to:
  /// **'Stock'**
  String get labelStock;

  /// Stock con unidades
  ///
  /// In es, this message translates to:
  /// **'{qty} unidades'**
  String labelStockUnits(int qty);

  /// Etiqueta tipo servicio
  ///
  /// In es, this message translates to:
  /// **'Servicio'**
  String get labelService;

  /// Etiqueta tipo de identificación
  ///
  /// In es, this message translates to:
  /// **'Tipo de identificación'**
  String get labelIdentificationType;

  /// Etiqueta identificación
  ///
  /// In es, this message translates to:
  /// **'Identificación'**
  String get labelIdentification;

  /// Etiqueta correo electrónico
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get labelEmailAddress;

  /// Etiqueta teléfono
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get labelPhoneNumber;

  /// Etiqueta dirección
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get labelAddress;

  /// Etiqueta descripción
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get labelDescription;

  /// Valor por defecto sin descripción
  ///
  /// In es, this message translates to:
  /// **'Sin descripción'**
  String get noDescription;

  /// Título página de productos
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get pageProductsTitle;

  /// Título página de clientes
  ///
  /// In es, this message translates to:
  /// **'Clientes'**
  String get pageClientsTitle;

  /// Hint búsqueda de productos
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre, clave o código de barras'**
  String get searchItemsHint;

  /// Hint búsqueda de clientes
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre o identificación'**
  String get searchCustomersHint;

  /// Hint campo búsqueda en diálogo cliente
  ///
  /// In es, this message translates to:
  /// **'Nombre o identificación'**
  String get dialogSearchHint;

  /// Hint campo búsqueda en diálogo producto
  ///
  /// In es, this message translates to:
  /// **'Nombre, código o barras'**
  String get dialogSearchProductHint;

  /// Mensaje sin búsqueda aún para clientes
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre o identificación\npara buscar un cliente'**
  String get noSearchYetCustomers;

  /// Mensaje sin búsqueda aún para productos
  ///
  /// In es, this message translates to:
  /// **'Busca productos por nombre,\ncódigo o código de barras'**
  String get noSearchYetProducts;

  /// Sin clientes en diálogo
  ///
  /// In es, this message translates to:
  /// **'No se encontraron clientes'**
  String get noDialogCustomersFound;

  /// Sin productos en diálogo
  ///
  /// In es, this message translates to:
  /// **'No se encontraron productos'**
  String get noDialogProductsFound;

  /// Título pantalla demo de alertas
  ///
  /// In es, this message translates to:
  /// **'Centro de Alertas'**
  String get alertDemoTitle;

  /// Contenido demo de alerta
  ///
  /// In es, this message translates to:
  /// **'Esta es una alerta de demostración del sistema'**
  String get alertDemoContent;

  /// Botón mostrar alerta demo
  ///
  /// In es, this message translates to:
  /// **'Mostrar Alerta'**
  String get alertDemoButton;
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
