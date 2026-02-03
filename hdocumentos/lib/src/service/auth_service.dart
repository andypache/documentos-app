import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/enviroment.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/service/service.dart';

///Create class provider service for authentication
class AuthService extends ChangeNotifier {
  //Loas secure storage
  final storage = const FlutterSecureStorage();

  //Function that call login service and save information
  Future<ServiceResponseModel> login(String username, String password) async {
    ServiceResponseModel response = ServiceResponseModel.createEmpty();

    const Base64Codec base64 = Base64Codec();
    var bytes =
        utf8.encode("${Environment.clientName}:${Environment.clientSecret}");
    var sendBase64 = base64.encode(bytes);

    Map<String, String> header = {
      "Authorization": "Basic $sendBase64",
      "Content-Type": "application/x-www-form-urlencoded",
    };

    Map<String, dynamic> request = {
      'grant_type': 'password',
      'username': username,
      'password': password,
    };

    response = await postFormFetch(
        url: apiSecurityLogin, body: request, header: header);
    await createSession(response);
    return response;
  }

  //Function that call refresh access token for new login
  static Future<ServiceResponseModel> refreshLogin(
      String username, String refreshToken) async {
    const Base64Codec base64 = Base64Codec();
    var bytes =
        utf8.encode("${Environment.clientName}:${Environment.clientSecret}");
    var sendBase64 = base64.encode(bytes);

    Map<String, String> header = {
      "Authorization": "Basic $sendBase64",
      "Content-Type": "application/x-www-form-urlencoded",
    };

    Map<String, dynamic> request = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
      'username': username
    };

    return await postFormFetch(
        url: apiSecurityLoginRefresh, body: request, header: header);
  }

  //Create session into security storage
  Future createSession(ServiceResponseModel response) async {
    if (response.statusHttp == 200) {
      await storage.write(
          key: 'access_token',
          value: response.body['response']['access_token']);
      await storage.write(
          key: 'refresh_token',
          value: response.body['response']['refresh_token']);
      Map<String, dynamic> payload =
          Jwt.parseJwt(response.body['response']['access_token']);
      Preferences.userSession = UserSessionModel.fromJson(payload);
    }
  }

  //Detele session user
  Future logout() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
    Preferences.removeUser();
  }

  //Read token
  Future<String> readToken() async {
    return await storage.read(key: 'access_token') ?? '';
  }

  //Read refresh token
  Future<String> readRefreshToken() async {
    return await storage.read(key: 'refresh_token') ?? '';
  }
}
