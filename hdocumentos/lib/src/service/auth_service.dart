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

  /// Construye el header Basic Auth con las credenciales del cliente OAuth.
  static Map<String, String> _buildAuthHeader() {
    const base64 = Base64Codec();
    final bytes =
        utf8.encode('${Environment.clientName}:${Environment.clientSecret}');
    final encoded = base64.encode(bytes);
    return {
      'Authorization': 'Basic $encoded',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
  }

  //Function that call login service and save information
  Future<ServiceResponseModel> login(String username, String password) async {
    final request = {
      'grant_type': 'password',
      'username': username,
      'password': password,
    };

    final response = await postFormFetch(
        url: apiSecurityLogin, body: request, header: _buildAuthHeader());

    await createSession(response);
    return response;
  }

  //Function that call refresh access token for new login
  static Future<ServiceResponseModel> refreshLogin(
      String username, String refreshToken) async {
    final request = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
      'username': username,
    };

    return postFormFetch(
        url: apiSecurityLoginRefresh,
        body: request,
        header: _buildAuthHeader());
  }

  //Create session into security storage
  Future createSession(ServiceResponseModel response) async {
    if (response.statusHttp == 200) {
      ResponseModel responseModel = response.createDataResponse();
      String accessToken = responseModel.response['access_token'];
      String refreshToken = responseModel.response['refresh_token'];
      await storage.write(key: 'access_token', value: accessToken);
      await storage.write(key: 'refresh_token', value: refreshToken);
      Map<String, dynamic> payload = Jwt.parseJwt(accessToken);
      Preferences.userSession = UserSessionModel.fromJson(payload);
    }
  }

  //Detele session user
  Future logout() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
    await CompanyService.clearCache();
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
