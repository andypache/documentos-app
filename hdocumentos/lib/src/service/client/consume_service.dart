import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hdocumentos/src/model/model.dart';

const storage = FlutterSecureStorage();
AuthService authService = AuthService();
const String _generalError =
    'No se puede comunicar con el servicio, por favor intente mas tarde';
const int _generalErrorStatus = 509;

//Create client for call service body data
postFetch(
    {required BuildContext context,
    required String url,
    required Object body}) async {
  ServiceResponseModel result;
  try {
    Map<String, String> header = {
      HttpHeaders.contentTypeHeader: "application/json",
      'Authorization': "Bearer ${await storage.read(key: 'access_token') ?? ''}"
    };
    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: jsonEncode(body),
    );
    result = getResponse(response);
    _refreshlLoginApp(context, result, url, body);
  } on Exception catch (e) {
    // ignore: avoid_print
    print('never reached');
    // ignore: avoid_print
    print(e);
    result = _getGeneralErrorResponse();
  }
  return result;
}

//Create re call to service when obtaint new token
_reCallPostFetch({required String url, required Object body}) async {
  ServiceResponseModel result;
  try {
    Map<String, String> header = {
      HttpHeaders.contentTypeHeader: "application/json",
      'Authorization': "Bearer ${await storage.read(key: 'access_token') ?? ''}"
    };
    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: jsonEncode(body),
    );
    result = getResponse(response);
  } on Exception catch (e) {
    // ignore: avoid_print
    print('never reached');
    // ignore: avoid_print
    print(e);
    result = _getGeneralErrorResponse();
  }
  return result;
}

//Create client for call service form data
postFormFetch(
    {required String url,
    required dynamic body,
    required dynamic header}) async {
  ServiceResponseModel result;
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: body,
    );
    result = getResponse(response);
  } on Exception catch (e) {
    // ignore: avoid_print
    print('never reached');
    // ignore: avoid_print
    print(e);
    result = _getGeneralErrorResponse();
  }
  return result;
}

//Get response for json parse pull
getResponse(dynamic response) {
  final status = response.statusCode;
  final data = json.decode(response.body);
  return ServiceResponseModel.fromJson(status, data);
}

//Get general response to call error message
_getGeneralErrorResponse() {
  NotificationService.showSnackbarError(_generalError);
  return ServiceResponseModel(
      statusHttp: _generalErrorStatus,
      status: '-1',
      message: _generalError,
      body: null);
}

//Call new token and create new session
_refreshlLoginApp(BuildContext context, ServiceResponseModel result, String url,
    Object body) async {
  if (result.statusHttp == 401 && Preferences.keepSession) {
    ServiceResponseModel resultRefresh = await AuthService.refreshLogin(
        Preferences.userSession.username,
        await storage.read(key: 'refresh_token') ?? '');
    await authService.createSession(resultRefresh);
    if (resultRefresh.statusHttp != 200) {
      _logoutApp(context);
    } else {
      return await _reCallPostFetch(url: url, body: body);
    }
  } else if (result.statusHttp == 401) {
    _logoutApp(context);
  }
}

//Logout app by unauthorized
_logoutApp(BuildContext context) async {
  NotificationService.showSnackbarError('Por favor inicie sesión nuevamente');
  sleep(const Duration(seconds: 3));
  await authService.logout();
  Navigator.pushReplacementNamed(context, 'login');
}
