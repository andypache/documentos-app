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
  String get btnSaveStep => 'Save this step';

  @override
  String get stepTaxes => 'Taxes';

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
}
