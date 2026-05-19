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
  String get validatorDecimal => 'Solo se permiten números decimales';

  @override
  String get validatorAlphanumericBasic => 'Solo se permiten letras y números sin caracteres especiales';

  @override
  String get validatorDateMustBeFuture => 'La fecha debe ser posterior a hoy';

  @override
  String get validatorInvalidDate => 'Fecha inválida';

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
  String validatorMinValue(int min) {
    return 'El valor mínimo es $min';
  }

  @override
  String get btnSaveStep => 'Guardar este paso';

  @override
  String get stepBasic => 'Básica';

  @override
  String get stepPrices => 'Precios';

  @override
  String get stepCodes => 'Códigos';

  @override
  String get stepTaxes => 'Impuestos';

  @override
  String get stepCustomerData => 'Datos';

  @override
  String get stepCustomerContact => 'Contacto';

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
  String get homeSalesEmpty => 'Sin ventas registradas';

  @override
  String get homeSalesEmptyDesc => 'Tus facturas aparecerán aquí una vez que generes tu primera venta.';

  @override
  String get homeSalesEmptyAction => 'Crear factura';

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

  @override
  String get btnAccept => 'Aceptar';

  @override
  String get btnExit => 'Salir';

  @override
  String get btnAdd => 'Agregar';

  @override
  String get btnSearch => 'Buscar';

  @override
  String get btnShowAll => 'Ver todos';

  @override
  String get btnNewCustomer => 'Nuevo';

  @override
  String get btnConsumerFinal => 'C. Final';

  @override
  String get btnAddTax => 'Agregar Impuesto';

  @override
  String get btnSaveInvoice => 'Guardar Factura';

  @override
  String get billTitle => 'Facturar';

  @override
  String get billSummaryTitle => 'Resumen de Factura';

  @override
  String get billConfirmTitle => '¿Guardar Factura?';

  @override
  String billConfirmCustomer(String name) {
    return 'Cliente: $name';
  }

  @override
  String billConfirmProducts(int count) {
    return 'Productos: $count';
  }

  @override
  String billConfirmTotal(String amount) {
    return 'Total: \$$amount';
  }

  @override
  String get billSavedTitle => '¡Factura Guardada!';

  @override
  String get billSavedMsg => 'La factura se guardó exitosamente';

  @override
  String get billExitTitle => '¿Salir sin guardar?';

  @override
  String get billExitMsg => 'Hay datos sin guardar que se perderán.';

  @override
  String get itemCreateTitle => 'Crear Producto';

  @override
  String get itemCreateSubtitle => 'Completa la información del nuevo producto';

  @override
  String get itemEditTitle => 'Editar Producto';

  @override
  String get itemEditSubtitle => 'Actualiza la información del producto';

  @override
  String get customerCreateTitle => 'Nuevo Cliente';

  @override
  String get customerEditTitle => 'Editar Cliente';

  @override
  String get itemCreatedSuccess => 'Producto guardado exitosamente';

  @override
  String get itemDataProcessError => 'Error al procesar la operación del producto';

  @override
  String get itemUpdatedSuccess => 'Producto actualizado exitosamente';

  @override
  String get customerCreatedSuccess => 'Cliente creado exitosamente';

  @override
  String get customerUpdatedSuccess => 'Cliente actualizado exitosamente';

  @override
  String get labelProducts => 'Productos';

  @override
  String get labelTaxes => 'Impuestos';

  @override
  String get labelQuantity => 'Cantidad';

  @override
  String get labelUnitPrice => 'Precio Unitario';

  @override
  String get labelDiscount => 'Descuento';

  @override
  String get labelSubtotal => 'Subtotal';

  @override
  String get labelTotal => 'TOTAL';

  @override
  String get labelTotalTaxes => 'Total impuestos';

  @override
  String get labelDiscountApplied => 'Descuento aplicado';

  @override
  String get labelDiscountAvailable => '¡DESCUENTO DISPONIBLE!';

  @override
  String labelDiscountValue(String value) {
    return '$value% de descuento';
  }

  @override
  String labelDiscountValid(String date) {
    return 'Válido hasta: $date';
  }

  @override
  String get labelSelectCustomer => 'Seleccionar Cliente';

  @override
  String get labelEditProduct => 'Editar Producto';

  @override
  String get searchProductHint => 'Nombre, código o barras';

  @override
  String get searchCustomerHint => 'Nombre o identificación';

  @override
  String get searchProductTitle => 'Buscar Producto';

  @override
  String get searchCustomerTitle => 'Buscar Cliente';

  @override
  String get noProductsAdded => 'No hay productos agregados';

  @override
  String get noProductsAddedHint => 'Toca \"Agregar\" para buscar productos';

  @override
  String get noTaxesAdded => 'No hay impuestos agregados';

  @override
  String get taxInfoNote => 'Los impuestos son opcionales. Puede agregarlos ahora o más tarde.';

  @override
  String get registerTitle => 'Registrar Usuario';

  @override
  String get registerHaveAccount => '¿Ya tienes una cuenta? Inicia sesión';

  @override
  String get registerFieldUser => 'Usuario';

  @override
  String get registerFieldUserHint => 'Nombre del usuario';

  @override
  String get registerFieldPassword => 'Contraseña';

  @override
  String get registerFieldPasswordHint => 'Contraseña de usuario';

  @override
  String get registerBtn => 'Registrarse';

  @override
  String get billRequiredFieldsHint => 'Completa todos los campos requeridos';

  @override
  String get btnDelete => 'Eliminar';

  @override
  String get btnLoadAll => 'Ver Todos';

  @override
  String get btnLoadLast => 'Ver Últimos';

  @override
  String get btnNewProduct => 'Nuevo Producto';

  @override
  String get deleteItemTitle => 'Eliminar Producto';

  @override
  String deleteItemConfirm(String name) {
    return '¿Está seguro de eliminar el producto \"$name\"?';
  }

  @override
  String get deleteCustomerTitle => 'Eliminar Cliente';

  @override
  String deleteCustomerConfirm(String name) {
    return '¿Está seguro de eliminar a \"$name\"?';
  }

  @override
  String get deleteSuccess => 'Eliminado exitosamente';

  @override
  String get deleteError => 'Error al eliminar';

  @override
  String get itemDeletedSuccess => 'Producto eliminado exitosamente';

  @override
  String get itemDeletedError => 'Error al eliminar el producto';

  @override
  String get customerDeletedSuccess => 'Cliente eliminado exitosamente';

  @override
  String itemsFound(int count) {
    return '$count producto(s) encontrado(s)';
  }

  @override
  String customersFound(int count) {
    return '$count cliente(s) encontrado(s)';
  }

  @override
  String get noItemsFound => 'Sin Resultados';

  @override
  String get noItemsFoundMsg => 'No se encontraron productos con ese criterio';

  @override
  String get noCustomersFound => 'Sin Resultados';

  @override
  String get noCustomersFoundMsg => 'No se encontraron clientes con ese criterio';

  @override
  String get searchItemsTitle => 'Buscar Productos';

  @override
  String get searchItemsMsg => 'Usa el buscador para encontrar productos\no visualiza todos los productos disponibles';

  @override
  String get searchCustomersTitle => 'Buscar Clientes';

  @override
  String get searchCustomersMsg => 'Usa el buscador para encontrar clientes\no visualiza los últimos clientes registrados';

  @override
  String discountBadge(String pct) {
    return 'Descuento $pct%';
  }

  @override
  String get selectTaxTitle => 'Seleccionar Impuesto';

  @override
  String get selectTaxSubtitle => 'Solo puede agregar un impuesto por grupo';

  @override
  String get taxGroupIVA => 'IVA (Impuesto al Valor Agregado)';

  @override
  String get taxGroupICE => 'ICE (Impuesto a Consumos Especiales)';

  @override
  String get taxGroupOther => 'Otros Impuestos';

  @override
  String get taxAssigned => 'Ya asignado';

  @override
  String get labelSearchKey => 'Clave de búsqueda';

  @override
  String get labelBarCode => 'Código de barras';

  @override
  String get labelQrCode => 'Código QR';

  @override
  String get labelPrice => 'Precio';

  @override
  String get labelCost => 'Costo';

  @override
  String get labelStock => 'Stock';

  @override
  String labelStockUnits(int qty) {
    return '$qty unidades';
  }

  @override
  String get labelService => 'Servicio';

  @override
  String get labelIdentificationType => 'Tipo de identificación';

  @override
  String get labelIdentification => 'Identificación';

  @override
  String get labelEmailAddress => 'Correo electrónico';

  @override
  String get labelPhoneNumber => 'Teléfono';

  @override
  String get labelAddress => 'Dirección';

  @override
  String get labelDescription => 'Descripción';

  @override
  String get noDescription => 'Sin descripción';

  @override
  String get pageProductsTitle => 'Productos';

  @override
  String get pageClientsTitle => 'Clientes';

  @override
  String get searchItemsHint => 'Buscar por nombre, clave o código de barras';

  @override
  String get searchCustomersHint => 'Buscar por nombre o identificación';

  @override
  String get dialogSearchHint => 'Nombre o identificación';

  @override
  String get dialogSearchProductHint => 'Nombre, código o barras';

  @override
  String get noSearchYetCustomers => 'Ingresa el nombre o identificación\npara buscar un cliente';

  @override
  String get noSearchYetProducts => 'Busca productos por nombre,\ncódigo o código de barras';

  @override
  String get noDialogCustomersFound => 'No se encontraron clientes';

  @override
  String get noDialogProductsFound => 'No se encontraron productos';

  @override
  String get alertDemoTitle => 'Centro de Alertas';

  @override
  String get alertDemoContent => 'Esta es una alerta de demostración del sistema';

  @override
  String get alertDemoButton => 'Mostrar Alerta';

  @override
  String get stepBasicTitle => 'Información Básica';

  @override
  String get labelProductName => 'Nombre del producto *';

  @override
  String get hintProductName => 'Ingrese el nombre';

  @override
  String get hintDescriptionOptional => 'Descripción detallada (opcional)';

  @override
  String get hintSearchKeyOptional => 'Clave única para buscar (opcional)';

  @override
  String get labelIsService => '¿Es un servicio?';

  @override
  String get hintIsService => 'Marque si es un servicio en lugar de un producto';

  @override
  String get validatorNameRequired => 'Este campo es requerido';

  @override
  String get validatorNameMinLength => 'Mínimo 3 caracteres';

  @override
  String get stepPricesTitle => 'Precios y Stock';

  @override
  String get labelSalePrice => 'Precio de venta *';

  @override
  String get hintSalePrice => 'Ingrese el precio';

  @override
  String get labelCostRequired => 'Costo *';

  @override
  String get hintCost => 'Ingrese el costo';

  @override
  String get labelDiscountPct => 'Descuento (%)';

  @override
  String get hintDiscountPct => 'Descuento opcional (0-100)';

  @override
  String get labelAvailableStock => 'Stock disponible *';

  @override
  String get hintAvailableStock => 'Cantidad en inventario';

  @override
  String get validatorPriceRequired => 'El precio es requerido';

  @override
  String get validatorPriceInvalid => 'Ingrese un precio válido';

  @override
  String get validatorCostRequired => 'El costo es requerido';

  @override
  String get validatorCostInvalid => 'Ingrese un costo válido';

  @override
  String get validatorDiscountRange => 'El descuento debe estar entre 0 y 100';

  @override
  String get validatorStockRequired => 'El stock es requerido';

  @override
  String get validatorStockInvalid => 'Ingrese un stock válido';

  @override
  String get stepCodesTitle => 'Códigos e Imagen';

  @override
  String get hintBarCode => 'Ingrese código de barras (opcional)';

  @override
  String get hintQrCode => 'Ingrese código QR (opcional)';

  @override
  String get labelServiceBadge => 'SERV.';

  @override
  String labelSearchKeyPrefix(String key) {
    return 'Clave: $key';
  }

  @override
  String labelStockPrefix(Object qty) {
    return 'Stock: $qty';
  }

  @override
  String get itemStockTitle => 'Cambiar Stock';

  @override
  String get labelCurrentStock => 'Stock actual';

  @override
  String get labelNewStock => 'Nuevo stock';

  @override
  String get labelStockField => 'Cantidad en inventario *';

  @override
  String get hintStockNew => 'Ingrese la nueva cantidad';

  @override
  String get itemStockSuccess => 'Stock actualizado correctamente';

  @override
  String get itemStockError => 'Error al actualizar el stock';

  @override
  String get itemPriceTitle => 'Actualizar Precio';

  @override
  String get labelCurrentPrice => 'Precio actual';

  @override
  String get labelCurrentCost => 'Costo actual';

  @override
  String get labelNewSalePrice => 'Nuevo precio de venta';

  @override
  String get labelNewCost => 'Nuevo costo';

  @override
  String get hintPriceExample => 'Ej: 99.99';

  @override
  String get hintCostExample => 'Ej: 60.00';

  @override
  String get validatorValueInvalid => 'Ingrese un valor válido (0 o mayor)';

  @override
  String get itemPriceSuccess => 'Precio actualizado correctamente';

  @override
  String get itemPriceError => 'Error al actualizar el precio';

  @override
  String errorGeneric(String message) {
    return 'Error: $message';
  }
}
