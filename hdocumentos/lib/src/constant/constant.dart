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

//Return Column error
Widget errorLoadContainer(error) {
  return Column(
      children: [const SizedBox(height: 30), Center(child: Text(error))]);
}
