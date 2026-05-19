import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get configEditTitle => 'Edit Company';

  @override
  String get configNewTitle => 'New Company';

  @override
  String get configEditSubtitle => 'Update your company information';

  @override
  String get configNewSubtitle => 'Set up your company step by step';

  @override
  String get stepCompany => 'Company';

  @override
  String get stepLogo => 'Logo';

  @override
  String get stepCert => 'Cert.';

  @override
  String get stepMail => 'Mail';

  @override
  String get stepEmission => 'Emission';

  @override
  String get btnPrevious => 'Previous';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnNext => 'Next';

  @override
  String get btnSave => 'Save';

  @override
  String get btnSaving => 'Saving...';

  @override
  String stepCounter(int current, int total) {
    return '$current of $total';
  }

  @override
  String get msgRequiredFields => 'Please complete the required fields';

  @override
  String companySavedSuccess(String name) {
    return 'Company \"$name\" saved successfully';
  }

  @override
  String saveError(String error) {
    return 'Error saving: $error';
  }

  @override
  String get companyDetails => 'Company details';

  @override
  String get enteredSoFar => 'Entered so far';

  @override
  String get requiredSelect => 'Select Type (Required)';

  @override
  String get requiredField => 'Required Field';

  @override
  String get companyInformation => 'Company Information';

  @override
  String get identificationType => 'Type of Identification';

  @override
  String get identificationNumber => 'Identification Number';

  @override
  String get identificationNumberHint => 'Tax ID Number (Required)';

  @override
  String get companyName => 'Company Name';

  @override
  String get companyNameHint => 'Company Name (Required)';

  @override
  String get address => 'Address';

  @override
  String get addressHint => 'Company Address (Required)';

  @override
  String get telephone => 'Telephone';

  @override
  String get telephoneHint => 'Telephone (Optional)';

  @override
  String get email => 'Email Address';

  @override
  String get emailHint => 'Corporate Email (Required)';

  @override
  String get activeCompany => 'Active Company';

  @override
  String get initApplicationError => 'The system catalogs could not be loaded';

  @override
  String get invalidDataFormatForCatalogs => 'Error in the format of the system catalogs';

  @override
  String get validatorRequired => 'Required field';

  @override
  String get validatorEmail => 'Enter a valid email address';

  @override
  String get validatorNumeric => 'Only numbers are allowed';

  @override
  String get validatorAlphanumeric => 'Only letters and numbers are allowed';

  @override
  String get validatorPhone => 'Enter a valid phone number';

  @override
  String get validatorUrl => 'Enter a valid URL (http:// or https://)';

  @override
  String get validatorDecimal => 'Only decimal numbers are allowed';

  @override
  String get validatorAlphanumericBasic => 'Only letters and numbers without special characters are allowed';

  @override
  String get validatorDateMustBeFuture => 'The date must be in the future';

  @override
  String get validatorInvalidDate => 'Invalid date';

  @override
  String get validatorPort => 'Enter a valid port (1 - 65535)';

  @override
  String get validatorNoSpaces => 'Cannot start or end with spaces';

  @override
  String validatorMinLength(int min) {
    return 'Minimum $min characters';
  }

  @override
  String validatorMaxLength(int max) {
    return 'Maximum $max characters';
  }

  @override
  String validatorExactLength(int length) {
    return 'Must be exactly $length characters';
  }

  @override
  String validatorMinValue(int min) {
    return 'The minimum value is $min';
  }

  @override
  String get btnSaveStep => 'Save this step';

  @override
  String get stepBasic => 'Basic';

  @override
  String get stepPrices => 'Prices';

  @override
  String get stepCodes => 'Codes';

  @override
  String get stepTaxes => 'Taxes';

  @override
  String get stepCustomerData => 'Data';

  @override
  String get stepCustomerContact => 'Contact';

  @override
  String get step2Title => 'Logo & Web Settings';

  @override
  String get step2LogoLabel => 'Company logo';

  @override
  String get step2Website => 'Website';

  @override
  String get step2WebsiteHint => 'https://www.company.com (optional)';

  @override
  String get step2MaxDiscount => 'Maximum discount (%)';

  @override
  String get step2MaxDiscountHint => 'E.g.: 10.00 (optional)';

  @override
  String get step2ItemAddress => 'Item address';

  @override
  String get step2ItemAddressHint => 'Alternative address (optional)';

  @override
  String get step2LogoLoaded => 'Logo loaded';

  @override
  String step2MaxDiscountSummary(String value) {
    return 'Max discount: $value%';
  }

  @override
  String get step3Title => 'Electronic Certificate';

  @override
  String get step3CertButton => 'Upload electronic signature (.p12 / .cert)';

  @override
  String get step3CertLoaded => 'Certificate loaded ✓';

  @override
  String get step3CertRequired => 'Certificate is required';

  @override
  String get step3CertSummary => 'Certificate loaded';

  @override
  String get certificateUser => 'Certificate user';

  @override
  String get certificateUserHint => 'Holder\'s name (required)';

  @override
  String get certificatePassword => 'Certificate password';

  @override
  String get certificatePasswordHint => 'Password (required)';

  @override
  String get certChangePassword => 'Change certificate password';

  @override
  String get certificateExpiration => 'Expiration date';

  @override
  String get certificateExpirationHint => 'Expiry date (required)';

  @override
  String certificateExpiresSummary(String date) {
    return 'Expires: $date';
  }

  @override
  String get step4Title => 'Email Configuration';

  @override
  String get step4InfoNote => 'Optional fields. Used to send invoices by email.';

  @override
  String get mailServer => 'Mail server';

  @override
  String get mailServerHint => 'smtp.gmail.com (optional)';

  @override
  String get mailPort => 'Port';

  @override
  String get mailPortHint => '587 / 465 (optional)';

  @override
  String mailPortSummary(String port) {
    return 'Port: $port';
  }

  @override
  String get mailAddress => 'Sender email address';

  @override
  String get mailAddressHint => 'mail@company.com (optional)';

  @override
  String get mailUser => 'Mail user';

  @override
  String get mailUserHint => 'SMTP user (optional)';

  @override
  String get mailPassword => 'Mail password';

  @override
  String get mailPasswordHint => 'SMTP password (optional)';

  @override
  String get mailChangePassword => 'Change mail password';

  @override
  String get step5Title => 'Emission Point';

  @override
  String get docType => 'Document type';

  @override
  String get docTypeHint => 'Select type (required)';

  @override
  String get establishmentCode => 'Establishment code';

  @override
  String get establishmentCodeHint => 'E.g.: 001 (required)';

  @override
  String get emissionPointCode => 'Emission point code';

  @override
  String get emissionPointCodeHint => 'E.g.: 001 (required)';

  @override
  String get currentSequential => 'Current sequential';

  @override
  String get currentSequentialHint => 'Starting number (required)';

  @override
  String get emissionDescription => 'Description';

  @override
  String get emissionDescriptionHint => 'Emission point description (optional)';

  @override
  String get activeEmissionPoint => 'Active emission point';

  @override
  String get finalSummaryTitle => 'Complete summary';

  @override
  String get summaryCompanyName => 'Company name';

  @override
  String get summaryIdentification => 'Identification';

  @override
  String get summaryAddress => 'Address';

  @override
  String get summaryEmail => 'Email';

  @override
  String get summaryWebsite => 'Website';

  @override
  String get summaryEstablishment => 'Establishment';

  @override
  String get summaryEmissionPoint => 'Em. point';

  @override
  String get summaryCertificate => 'Certificate';

  @override
  String get summaryCertLoaded => 'Loaded ✓';

  @override
  String get summaryCertNotLoaded => 'Not loaded';

  @override
  String get step6Title => 'Tax Groups';

  @override
  String get step6TaxGuideTitle => 'Quick guide';

  @override
  String get step6TaxGuideBody => 'Select the tax groups that apply to the products or services your company sells.';

  @override
  String get emissionPointAddBtn => 'Add point';

  @override
  String get emissionPointEditBtn => 'Edit';

  @override
  String get emissionPointDeleteBtn => 'Delete';

  @override
  String get emissionPointSaveBtn => 'Save point';

  @override
  String get emissionPointCancelBtn => 'Cancel';

  @override
  String get emissionPointSelectLabel => 'Active billing point';

  @override
  String get emissionPointEmptyMsg => 'No emission points. Add at least one.';

  @override
  String get emissionPointFormTitle => 'New emission point';

  @override
  String get emissionPointEditFormTitle => 'Edit emission point';

  @override
  String get emissionPointDeleteConfirm => 'Delete this emission point?';

  @override
  String get emissionPointActiveChip => 'Active';

  @override
  String get emissionPointInactiveChip => 'Inactive';

  @override
  String get emissionPointSelectedHint => 'Selected for billing';

  @override
  String get loading => 'Loading...';

  @override
  String get btnRetry => 'Retry';

  @override
  String get btnLogout => 'Logout';

  @override
  String get stepSavedSuccess => 'Step saved successfully';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginSubtitle => 'Enter your credentials to continue';

  @override
  String get loginFieldUser => 'Username';

  @override
  String get loginFieldUserHint => 'Enter your username';

  @override
  String get loginFieldPassword => 'Password';

  @override
  String get loginFieldPasswordHint => 'Enter your password';

  @override
  String get loginKeepSession => 'Keep me signed in';

  @override
  String get loginBtnSignIn => 'Sign In';

  @override
  String get loginBtnSigningIn => 'Signing in...';

  @override
  String get loginRegisterLink => 'Don\'t have an account? Register';

  @override
  String get loginErrUserRequired => 'Username is required';

  @override
  String get loginErrUserMin => 'Minimum 3 characters';

  @override
  String get loginErrPasswordRequired => 'Password is required';

  @override
  String get loginErrPasswordMin => 'Minimum 4 characters';

  @override
  String get loginErrGeneral => 'Could not sign in. Please try again later';

  @override
  String get homeMenuBill => 'BILLING';

  @override
  String get homeMenuBillDesc => 'Generate invoices for goods or services';

  @override
  String get homeMenuClient => 'CLIENTS';

  @override
  String get homeMenuClientDesc => 'Manage your clients, create, edit or delete';

  @override
  String get homeMenuItem => 'PRODUCTS';

  @override
  String get homeMenuItemDesc => 'Manage your products, create, edit or delete';

  @override
  String get homeMenuReport => 'REPORTS';

  @override
  String get homeMenuReportDesc => 'Generate your invoices as PDF';

  @override
  String get homeMenuReview => 'REVIEW';

  @override
  String get homeMenuReviewDesc => 'Verify your invoices with the SRI';

  @override
  String get homeMenuConfig => 'SETTINGS';

  @override
  String get homeMenuConfigDesc => 'Set up your company, change your logo and e-signature';

  @override
  String get homeSalesTitle => 'My Sales';

  @override
  String get homeSalesEmpty => 'No sales recorded yet';

  @override
  String get homeSalesEmptyDesc => 'Your invoices will appear here once you generate your first sale.';

  @override
  String get homeSalesEmptyAction => 'Create invoice';

  @override
  String get navBill => 'Invoice';

  @override
  String get navReports => 'Reports';

  @override
  String get navConfig => 'Settings';

  @override
  String get navLogout => 'Logout';

  @override
  String get reloadDialogTitle => 'Refresh parameters';

  @override
  String get reloadDialogBody => 'Do you want to refresh the system parameters and company data again?';

  @override
  String get reloadDialogConfirm => 'Refresh';

  @override
  String get reloadDialogCancel => 'Cancel';

  @override
  String get reloadSuccess => 'Parameters updated successfully';

  @override
  String get emissionPointRequired => 'You must add at least one emission point to continue';

  @override
  String get emissionPointSelectRequired => 'You must have at least one active emission point to continue';

  @override
  String get emissionPointDuplicateCode => 'A point with that establishment and emission code already exists';

  @override
  String get emissionPointOnlyOneActive => 'There is already an active point. Deactivate it before activating another.';

  @override
  String get companyDataProcessError => 'Error processing company data';

  @override
  String get companyCreatedInvalidFormat => 'Invalid data format for created company';

  @override
  String get couldNotLoadInfo => 'Could not load information';

  @override
  String get btnAccept => 'Accept';

  @override
  String get btnExit => 'Exit';

  @override
  String get btnAdd => 'Add';

  @override
  String get btnSearch => 'Search';

  @override
  String get btnShowAll => 'View all';

  @override
  String get btnNewCustomer => 'New';

  @override
  String get btnConsumerFinal => 'C. Final';

  @override
  String get btnAddTax => 'Add Tax';

  @override
  String get btnSaveInvoice => 'Save Invoice';

  @override
  String get billTitle => 'Invoice';

  @override
  String get billSummaryTitle => 'Invoice Summary';

  @override
  String get billConfirmTitle => 'Save Invoice?';

  @override
  String billConfirmCustomer(String name) {
    return 'Customer: $name';
  }

  @override
  String billConfirmProducts(int count) {
    return 'Products: $count';
  }

  @override
  String billConfirmTotal(String amount) {
    return 'Total: \$$amount';
  }

  @override
  String get billSavedTitle => 'Invoice Saved!';

  @override
  String get billSavedMsg => 'The invoice was saved successfully';

  @override
  String get billExitTitle => 'Exit without saving?';

  @override
  String get billExitMsg => 'There is unsaved data that will be lost.';

  @override
  String get itemCreateTitle => 'Create Product';

  @override
  String get itemCreateSubtitle => 'Fill in the new product information';

  @override
  String get itemEditTitle => 'Edit Product';

  @override
  String get itemEditSubtitle => 'Update the product information';

  @override
  String get customerCreateTitle => 'New Customer';

  @override
  String get customerEditTitle => 'Edit Customer';

  @override
  String get itemCreatedSuccess => 'Product saved successfully';

  @override
  String get itemDataProcessError => 'Error processing the product operation';

  @override
  String get itemUpdatedSuccess => 'Product updated successfully';

  @override
  String get customerCreatedSuccess => 'Customer created successfully';

  @override
  String get customerUpdatedSuccess => 'Customer updated successfully';

  @override
  String get labelProducts => 'Products';

  @override
  String get labelTaxes => 'Taxes';

  @override
  String get labelQuantity => 'Quantity';

  @override
  String get labelUnitPrice => 'Unit Price';

  @override
  String get labelDiscount => 'Discount';

  @override
  String get labelSubtotal => 'Subtotal';

  @override
  String get labelTotal => 'TOTAL';

  @override
  String get labelTotalTaxes => 'Total taxes';

  @override
  String get labelDiscountApplied => 'Applied discount';

  @override
  String get labelDiscountAvailable => 'DISCOUNT AVAILABLE!';

  @override
  String labelDiscountValue(String value) {
    return '$value% discount';
  }

  @override
  String labelDiscountValid(String date) {
    return 'Valid until: $date';
  }

  @override
  String get labelSelectCustomer => 'Select Customer';

  @override
  String get labelEditProduct => 'Edit Product';

  @override
  String get searchProductHint => 'Name, code or barcode';

  @override
  String get searchCustomerHint => 'Name or identification';

  @override
  String get searchProductTitle => 'Search Product';

  @override
  String get searchCustomerTitle => 'Search Customer';

  @override
  String get noProductsAdded => 'No products added';

  @override
  String get noProductsAddedHint => 'Tap \"Add\" to search for products';

  @override
  String get noTaxesAdded => 'No taxes added';

  @override
  String get taxInfoNote => 'Taxes are optional. You can add them now or later.';

  @override
  String get registerTitle => 'Register User';

  @override
  String get registerHaveAccount => 'Already have an account? Sign in';

  @override
  String get registerFieldUser => 'Username';

  @override
  String get registerFieldUserHint => 'Username';

  @override
  String get registerFieldPassword => 'Password';

  @override
  String get registerFieldPasswordHint => 'User password';

  @override
  String get registerBtn => 'Register';

  @override
  String get billRequiredFieldsHint => 'Complete all required fields';

  @override
  String get btnDelete => 'Delete';

  @override
  String get btnLoadAll => 'View All';

  @override
  String get btnLoadLast => 'View Latest';

  @override
  String get btnNewProduct => 'New Product';

  @override
  String get deleteItemTitle => 'Delete Product';

  @override
  String deleteItemConfirm(String name) {
    return 'Are you sure you want to delete the product \"$name\"?';
  }

  @override
  String get deleteCustomerTitle => 'Delete Customer';

  @override
  String deleteCustomerConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get deleteSuccess => 'Deleted successfully';

  @override
  String get deleteError => 'Error deleting';

  @override
  String get itemDeletedSuccess => 'Product deleted successfully';

  @override
  String get itemDeletedError => 'Error deleting the product';

  @override
  String get customerDeletedSuccess => 'Customer deleted successfully';

  @override
  String itemsFound(int count) {
    return '$count product(s) found';
  }

  @override
  String customersFound(int count) {
    return '$count customer(s) found';
  }

  @override
  String get noItemsFound => 'No Results';

  @override
  String get noItemsFoundMsg => 'No products found matching that criteria';

  @override
  String get noCustomersFound => 'No Results';

  @override
  String get noCustomersFoundMsg => 'No customers found matching that criteria';

  @override
  String get searchItemsTitle => 'Search Products';

  @override
  String get searchItemsMsg => 'Use the search bar to find products\nor view all available products';

  @override
  String get searchCustomersTitle => 'Search Customers';

  @override
  String get searchCustomersMsg => 'Use the search bar to find customers\nor view the latest registered customers';

  @override
  String discountBadge(String pct) {
    return 'Discount $pct%';
  }

  @override
  String get selectTaxTitle => 'Select Tax';

  @override
  String get selectTaxSubtitle => 'You can only add one tax per group';

  @override
  String get taxGroupIVA => 'VAT (Value Added Tax)';

  @override
  String get taxGroupICE => 'ICE (Special Consumption Tax)';

  @override
  String get taxGroupOther => 'Other Taxes';

  @override
  String get taxAssigned => 'Already assigned';

  @override
  String get labelSearchKey => 'Search key';

  @override
  String get labelBarCode => 'Barcode';

  @override
  String get labelQrCode => 'QR Code';

  @override
  String get labelPrice => 'Price';

  @override
  String get labelCost => 'Cost';

  @override
  String get labelStock => 'Stock';

  @override
  String labelStockUnits(int qty) {
    return '$qty units';
  }

  @override
  String get labelService => 'Service';

  @override
  String get labelIdentificationType => 'Identification type';

  @override
  String get labelIdentification => 'Identification';

  @override
  String get labelEmailAddress => 'Email address';

  @override
  String get labelPhoneNumber => 'Phone';

  @override
  String get labelAddress => 'Address';

  @override
  String get labelDescription => 'Description';

  @override
  String get noDescription => 'No description';

  @override
  String get pageProductsTitle => 'Products';

  @override
  String get pageClientsTitle => 'Customers';

  @override
  String get searchItemsHint => 'Search by name, key or barcode';

  @override
  String get searchCustomersHint => 'Search by name or identification';

  @override
  String get dialogSearchHint => 'Name or identification';

  @override
  String get dialogSearchProductHint => 'Name, code or barcode';

  @override
  String get noSearchYetCustomers => 'Enter name or identification\nto search for a customer';

  @override
  String get noSearchYetProducts => 'Search products by name,\ncode or barcode';

  @override
  String get noDialogCustomersFound => 'No customers found';

  @override
  String get noDialogProductsFound => 'No products found';

  @override
  String get alertDemoTitle => 'Alert Center';

  @override
  String get alertDemoContent => 'This is a system demo alert';

  @override
  String get alertDemoButton => 'Show Alert';

  @override
  String get stepBasicTitle => 'Basic Information';

  @override
  String get labelProductName => 'Product name *';

  @override
  String get hintProductName => 'Enter name';

  @override
  String get hintDescriptionOptional => 'Detailed description (optional)';

  @override
  String get hintSearchKeyOptional => 'Unique search key (optional)';

  @override
  String get labelIsService => 'Is it a service?';

  @override
  String get hintIsService => 'Check if it\'s a service instead of a product';

  @override
  String get validatorNameRequired => 'This field is required';

  @override
  String get validatorNameMinLength => 'Minimum 3 characters';

  @override
  String get stepPricesTitle => 'Prices & Stock';

  @override
  String get labelSalePrice => 'Sale price *';

  @override
  String get hintSalePrice => 'Enter price';

  @override
  String get labelCostRequired => 'Cost *';

  @override
  String get hintCost => 'Enter cost';

  @override
  String get labelDiscountPct => 'Discount (%)';

  @override
  String get hintDiscountPct => 'Optional discount (0-100)';

  @override
  String get labelAvailableStock => 'Available stock *';

  @override
  String get hintAvailableStock => 'Inventory quantity';

  @override
  String get validatorPriceRequired => 'Price is required';

  @override
  String get validatorPriceInvalid => 'Enter a valid price';

  @override
  String get validatorCostRequired => 'Cost is required';

  @override
  String get validatorCostInvalid => 'Enter a valid cost';

  @override
  String get validatorDiscountRange => 'Discount must be between 0 and 100';

  @override
  String get validatorStockRequired => 'Stock is required';

  @override
  String get validatorStockInvalid => 'Enter a valid stock value';

  @override
  String get stepCodesTitle => 'Codes & Image';

  @override
  String get hintBarCode => 'Enter barcode (optional)';

  @override
  String get hintQrCode => 'Enter QR code (optional)';

  @override
  String get labelServiceBadge => 'SERV.';

  @override
  String labelSearchKeyPrefix(String key) {
    return 'Key: $key';
  }

  @override
  String labelStockPrefix(Object qty) {
    return 'Stock: $qty';
  }

  @override
  String get itemStockTitle => 'Update Stock';

  @override
  String get labelCurrentStock => 'Current stock';

  @override
  String get labelNewStock => 'New stock';

  @override
  String get labelStockField => 'Inventory quantity *';

  @override
  String get hintStockNew => 'Enter the new quantity';

  @override
  String get itemStockSuccess => 'Stock updated successfully';

  @override
  String get itemStockError => 'Error updating stock';

  @override
  String get itemPriceTitle => 'Update Price';

  @override
  String get labelCurrentPrice => 'Current price';

  @override
  String get labelCurrentCost => 'Current cost';

  @override
  String get labelNewSalePrice => 'New sale price';

  @override
  String get labelNewCost => 'New cost';

  @override
  String get hintPriceExample => 'E.g.: 99.99';

  @override
  String get hintCostExample => 'E.g.: 60.00';

  @override
  String get validatorValueInvalid => 'Enter a valid value (0 or more)';

  @override
  String get itemPriceSuccess => 'Price updated successfully';

  @override
  String get itemPriceError => 'Error updating price';

  @override
  String errorGeneric(String message) {
    return 'Error: $message';
  }
}
