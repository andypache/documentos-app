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
String apiPrintingLogoRegisterCompany =
    "${apiCompany}company/printing-logo/register";

//Return Column error
Widget errorLoadContainer(error) {
  return Column(
      children: [const SizedBox(height: 30), Center(child: Text(error))]);
}

const String prefixError = "Por favor intente mas tarde, ";
const String successMessage = "Registro actualizado exitosamente";
const String generalError =
    'No se puede comunicar con el servicio, por favor intente mas tarde';
