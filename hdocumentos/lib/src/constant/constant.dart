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
String apiCompanyUpdate = "${apiCompany}companies/update";
String apiPrintingLogoRegisterCompany =
    "${apiCompany}company/printing-logo/register";

// Endpoints de actualización por paso del wizard
String apiCompanyBasic = "${apiCompany}company/update/basic";
String apiCompanyLogo = "${apiCompany}company/update/logo";
String apiCompanyCertificate = "${apiCompany}company/update/certificate";
String apiCompanyMail = "${apiCompany}company/update/mail";
String apiCompanyEmission = "${apiCompany}company/update/emission";
String apiCompanyTaxGroups = "${apiCompany}company/update/tax-groups";

// Endpoint últimas ventas
String apiLastSales = "${apiCompany}bills/last-sales";

//URL for common
String apiDataCatalog = "$apiCompany/catalogs";

//URL for item (document-service)
String apiItem =
    '${Environment.protocol}://${Environment.host}${Environment.portItem}/${Environment.baseUrl}/';
String apiItemCreate = '${apiItem}item-service/items/create';
String apiItemUpdate = '${apiItem}item-service/items/update';
String apiItemUpdatePrice = '${apiItem}item-service/items/update';
String apiItemUpdateStock = '${apiItem}item-service/items/update';
String apiItemDelete = '${apiItem}item-service/items/delete';
String apiItemPaginationAll = '${apiItem}item-service/items/pagination/all';
String apiItemPaginationFilter =
    '${apiItem}item-service/items/pagination/filter';

//URL for sale (document-service)
String apiSale =
    '${Environment.protocol}://${Environment.host}${Environment.portSale}/${Environment.baseUrl}/';
String apiSaleCreate = '${apiSale}sale-service/sale/create';
String apiSaleCalculate = '${apiSale}sale-service/sale/calculate';

//Return Column error
Widget errorLoadContainer(error) {
  return Column(
      children: [const SizedBox(height: 30), Center(child: Text(error))]);
}

const String prefixError = "Por favor intente mas tarde, ";
const String successMessage = "Registro actualizado exitosamente";
const String generalError =
    'No se puede comunicar con el servicio, por favor intente mas tarde';
