import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/enviroment.dart';

//URL for security
String apiSecurity =
    '${Environment.protocol}://${Environment.host}${Environment.portSecurity}/${Environment.prefixSecurity}${Environment.baseUrl}/security-service/';
String apiSecurityLogin = "${apiSecurity}oauth/token";
String apiSecurityLoginRefresh = "${apiSecurity}oauth/refresh";

//URL for company
String apiCompany =
    '${Environment.protocol}://${Environment.host}${Environment.portCompany}/${Environment.prefixCompany}${Environment.baseUrl}/company-service/';
String apiDataCompany = "${apiCompany}company/by-email";
String apiCompanyDefault = "${apiCompany}companies/company-user/default";
String apiCompanyCreate = "${apiCompany}companies/create";
String apiPrintingLogoRegisterCompany =
    "${apiCompany}company/printing-logo/register";

// Endpoints de actualización por paso del wizard
String apiCompanyBasic = "${apiCompany}company/update/basic";
String apiCompanyLogo = "${apiCompany}company/update/logo";
String apiCompanyCertificate = "${apiCompany}company/update/certificate";
String apiCompanyMail = "${apiCompany}company/update/mail";
String apiCompanyEmission = "${apiCompany}company/update/emission";
String apiCompanyTaxGroups = "${apiCompany}company/update/tax-groups";

//URL for common
String apiDataCatalog = "$apiCompany/catalogs";

//Return Column error
Widget errorLoadContainer(error) {
  return Column(
      children: [const SizedBox(height: 30), Center(child: Text(error))]);
}

const String prefixError = "Por favor intente mas tarde, ";
const String successMessage = "Registro actualizado exitosamente";
const String generalError =
    'No se puede comunicar con el servicio, por favor intente mas tarde';
