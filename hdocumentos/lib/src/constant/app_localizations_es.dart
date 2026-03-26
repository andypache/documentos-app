import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get configEditTitle => 'Editar Compañía';

  @override
  String get configNewTitle => 'Nueva Compañía';

  @override
  String get configEditSubtitle => 'Actualiza la información de tu empresa';

  @override
  String get configNewSubtitle => 'Configura tu empresa paso a paso';

  @override
  String get stepCompany => 'Empresa';

  @override
  String get stepLogo => 'Logo';

  @override
  String get stepCert => 'Cert.';

  @override
  String get stepMail => 'Correo';

  @override
  String get stepEmission => 'Emisión';

  @override
  String get btnPrevious => 'Anterior';

  @override
  String get btnCancel => 'Cancelar';

  @override
  String get btnNext => 'Siguiente';

  @override
  String get btnSave => 'Guardar';

  @override
  String get btnSaving => 'Guardando...';

  @override
  String stepCounter(int current, int total) {
    return '$current de $total';
  }

  @override
  String get msgRequiredFields => 'Completa los campos requeridos';

  @override
  String companySavedSuccess(String name) {
    return 'Compañía \"$name\" guardada exitosamente';
  }

  @override
  String saveError(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get companyDetails => 'Datos de la empresa';

  @override
  String get enteredSoFar => 'Ingresado hasta ahora';

  @override
  String get requiredSelect => 'Seleccione el tipo (requerido)';

  @override
  String get requiredField => 'Campo requerido';

  @override
  String get companyInformation => 'Datos de la Empresa';

  @override
  String get identificationType => 'Tipo de identificación';

  @override
  String get identificationNumber => 'Número de identificación';

  @override
  String get identificationNumberHint => 'RUC / Cédula (requerido)';

  @override
  String get companyName => 'Razón social';

  @override
  String get companyNameHint => 'Nombre de la empresa (requerido)';

  @override
  String get address => 'Dirección';

  @override
  String get addressHint => 'Dirección de la empresa (requerido)';

  @override
  String get telephone => 'Teléfono';

  @override
  String get telephoneHint => 'Teléfono (opcional)';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailHint => 'Email corporativo (requerido)';

  @override
  String get activeCompany => 'Empresa activa';

  @override
  String get initApplicationError => 'No se pudieron cargar los catálogos del sistema';

  @override
  String get invalidDataFormatForCatalogs => 'Error en el formato de los catálogos del sistema';

  @override
  String get validatorRequired => 'Campo requerido';

  @override
  String get validatorEmail => 'Ingresa un correo electrónico válido';

  @override
  String get validatorNumeric => 'Solo se permiten números';

  @override
  String get validatorAlphanumeric => 'Solo se permiten letras y números';

  @override
  String get validatorPhone => 'Ingresa un número de teléfono válido';

  @override
  String get validatorUrl => 'Ingresa una URL válida (http:// o https://)';

  @override
  String get validatorPort => 'Ingresa un puerto válido (1 - 65535)';

  @override
  String get validatorNoSpaces => 'No puede iniciar ni terminar con espacios';

  @override
  String validatorMinLength(int min) {
    return 'Mínimo $min caracteres';
  }

  @override
  String validatorMaxLength(int max) {
    return 'Máximo $max caracteres';
  }

  @override
  String validatorExactLength(int length) {
    return 'Debe tener exactamente $length caracteres';
  }
}
