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
}
