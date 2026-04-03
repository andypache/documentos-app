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

  @override
  String get btnSaveStep => 'Guardar este paso';

  @override
  String get stepTaxes => 'Impuestos';

  @override
  String get step2Title => 'Logo y Configuración Web';

  @override
  String get step2LogoLabel => 'Logo de la empresa';

  @override
  String get step2Website => 'Sitio web';

  @override
  String get step2WebsiteHint => 'https://www.empresa.com (opcional)';

  @override
  String get step2MaxDiscount => 'Descuento máximo (%)';

  @override
  String get step2MaxDiscountHint => 'Ej: 10.00 (opcional)';

  @override
  String get step2ItemAddress => 'Dirección de artículos';

  @override
  String get step2ItemAddressHint => 'Dirección alternativa (opcional)';

  @override
  String get step2LogoLoaded => 'Logo cargado';

  @override
  String step2MaxDiscountSummary(String value) {
    return 'Descuento máx: $value%';
  }

  @override
  String get step3Title => 'Certificado Electrónico';

  @override
  String get step3CertButton => 'Cargar firma electrónica (.p12 / .cert)';

  @override
  String get step3CertLoaded => 'Certificado cargado ✓';

  @override
  String get step3CertRequired => 'El certificado es requerido';

  @override
  String get step3CertSummary => 'Certificado cargado';

  @override
  String get certificateUser => 'Usuario del certificado';

  @override
  String get certificateUserHint => 'Nombre del titular (requerido)';

  @override
  String get certificatePassword => 'Contraseña del certificado';

  @override
  String get certificatePasswordHint => 'Contraseña (requerido)';

  @override
  String get certChangePassword => 'Cambiar contraseña del certificado';

  @override
  String get certificateExpiration => 'Fecha de expiración';

  @override
  String get certificateExpirationHint => 'Fecha de caducidad (requerido)';

  @override
  String certificateExpiresSummary(String date) {
    return 'Expira: $date';
  }

  @override
  String get step4Title => 'Configuración de Correo';

  @override
  String get step4InfoNote => 'Campos opcionales. Se usan para el envío de facturas por correo.';

  @override
  String get mailServer => 'Servidor de correo';

  @override
  String get mailServerHint => 'smtp.gmail.com (opcional)';

  @override
  String get mailPort => 'Puerto';

  @override
  String get mailPortHint => '587 / 465 (opcional)';

  @override
  String mailPortSummary(String port) {
    return 'Puerto: $port';
  }

  @override
  String get mailAddress => 'Dirección de correo remitente';

  @override
  String get mailAddressHint => 'correo@empresa.com (opcional)';

  @override
  String get mailUser => 'Usuario de correo';

  @override
  String get mailUserHint => 'Usuario SMTP (opcional)';

  @override
  String get mailPassword => 'Contraseña de correo';

  @override
  String get mailPasswordHint => 'Contraseña SMTP (opcional)';

  @override
  String get mailChangePassword => 'Cambiar contraseña de correo';

  @override
  String get step5Title => 'Punto de Emisión';

  @override
  String get docType => 'Tipo de documento';

  @override
  String get docTypeHint => 'Seleccione el tipo (requerido)';

  @override
  String get establishmentCode => 'Código del establecimiento';

  @override
  String get establishmentCodeHint => 'Ej: 001 (requerido)';

  @override
  String get emissionPointCode => 'Código del punto de emisión';

  @override
  String get emissionPointCodeHint => 'Ej: 001 (requerido)';

  @override
  String get currentSequential => 'Secuencial actual';

  @override
  String get currentSequentialHint => 'Número inicial (requerido)';

  @override
  String get emissionDescription => 'Descripción';

  @override
  String get emissionDescriptionHint => 'Descripción del punto de emisión (opcional)';

  @override
  String get activeEmissionPoint => 'Punto de emisión activo';

  @override
  String get finalSummaryTitle => 'Resumen completo';

  @override
  String get summaryCompanyName => 'Razón social';

  @override
  String get summaryIdentification => 'Identificación';

  @override
  String get summaryAddress => 'Dirección';

  @override
  String get summaryEmail => 'Email';

  @override
  String get summaryWebsite => 'Web';

  @override
  String get summaryEstablishment => 'Establecimiento';

  @override
  String get summaryEmissionPoint => 'Pto. emisión';

  @override
  String get summaryCertificate => 'Certificado';

  @override
  String get summaryCertLoaded => 'Cargado ✓';

  @override
  String get summaryCertNotLoaded => 'No cargado';

  @override
  String get step6Title => 'Grupos de Impuesto';

  @override
  String get step6TaxGuideTitle => 'Guía rápida';

  @override
  String get step6TaxGuideBody => 'Selecciona los grupos de impuesto que aplican a los productos o servicios que vende tu empresa.';

  @override
  String get emissionPointAddBtn => 'Agregar punto';

  @override
  String get emissionPointEditBtn => 'Editar';

  @override
  String get emissionPointDeleteBtn => 'Eliminar';

  @override
  String get emissionPointSaveBtn => 'Guardar punto';

  @override
  String get emissionPointCancelBtn => 'Cancelar';

  @override
  String get emissionPointSelectLabel => 'Punto activo de facturación';

  @override
  String get emissionPointEmptyMsg => 'No hay puntos de emisión. Agrega al menos uno.';

  @override
  String get emissionPointFormTitle => 'Nuevo punto de emisión';

  @override
  String get emissionPointEditFormTitle => 'Editar punto de emisión';

  @override
  String get emissionPointDeleteConfirm => '¿Eliminar este punto de emisión?';

  @override
  String get emissionPointActiveChip => 'Activo';

  @override
  String get emissionPointInactiveChip => 'Inactivo';

  @override
  String get emissionPointSelectedHint => 'Seleccionado para facturación';

  @override
  String get loading => 'Cargando...';

  @override
  String get btnRetry => 'Reintentar';

  @override
  String get btnLogout => 'Salir';

  @override
  String get stepSavedSuccess => 'Paso guardado correctamente';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginSubtitle => 'Ingresa tus credenciales para continuar';

  @override
  String get loginFieldUser => 'Usuario';

  @override
  String get loginFieldUserHint => 'Ingresa tu usuario';

  @override
  String get loginFieldPassword => 'Contraseña';

  @override
  String get loginFieldPasswordHint => 'Ingresa tu contraseña';

  @override
  String get loginKeepSession => 'Mantener sesión iniciada';

  @override
  String get loginBtnSignIn => 'Ingresar';

  @override
  String get loginBtnSigningIn => 'Ingresando...';

  @override
  String get loginRegisterLink => '¿No tienes cuenta? Regístrate';

  @override
  String get loginErrUserRequired => 'El usuario es requerido';

  @override
  String get loginErrUserMin => 'Mínimo 3 caracteres';

  @override
  String get loginErrPasswordRequired => 'La contraseña es requerida';

  @override
  String get loginErrPasswordMin => 'Mínimo 4 caracteres';

  @override
  String get loginErrGeneral => 'No se pudo iniciar sesión. Intente más tarde';

  @override
  String get homeMenuBill => 'FACTURAR';

  @override
  String get homeMenuBillDesc => 'Genere sus facturas para un bien o servicio';

  @override
  String get homeMenuClient => 'CLIENTES';

  @override
  String get homeMenuClientDesc => 'Gestione sus clientes, cree, edite o elimine';

  @override
  String get homeMenuItem => 'PRODUCTOS';

  @override
  String get homeMenuItemDesc => 'Gestione sus productos, cree, edite o elimine';

  @override
  String get homeMenuReport => 'REPORTES';

  @override
  String get homeMenuReportDesc => 'Genere sus facturas en pdf';

  @override
  String get homeMenuReview => 'REVISIÓN';

  @override
  String get homeMenuReviewDesc => 'Verifique sus facturas en el SRI';

  @override
  String get homeMenuConfig => 'CONFIGURACIÓN';

  @override
  String get homeMenuConfigDesc => 'Configure su empresa, cambie su imagen y firma electrónica';

  @override
  String get homeSalesTitle => 'Mis Ventas';

  @override
  String get navBill => 'Factura';

  @override
  String get navReports => 'Reportes';

  @override
  String get navConfig => 'Configurar';

  @override
  String get navLogout => 'Salir';

  @override
  String get reloadDialogTitle => 'Actualizar parámetros';

  @override
  String get reloadDialogBody => '¿Deseas actualizar nuevamente los parámetros del sistema y los datos de la empresa?';

  @override
  String get reloadDialogConfirm => 'Actualizar';

  @override
  String get reloadDialogCancel => 'Cancelar';

  @override
  String get reloadSuccess => 'Parámetros actualizados correctamente';

  @override
  String get emissionPointRequired => 'Debes agregar al menos un punto de emisión para continuar';

  @override
  String get emissionPointSelectRequired => 'Debes tener al menos un punto de emisión activo para continuar';

  @override
  String get emissionPointDuplicateCode => 'Ya existe un punto con ese código de establecimiento y emisión';

  @override
  String get emissionPointOnlyOneActive => 'Ya hay un punto activo. Desactívalo antes de activar otro.';

  @override
  String get companyDataProcessError => 'Error al procesar los datos de la compañía';

  @override
  String get companyCreatedInvalidFormat => 'Formato de datos inválido para la compañía creada';

  @override
  String get couldNotLoadInfo => 'No se pudo cargar la información';
}
