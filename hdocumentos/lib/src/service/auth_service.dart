import 'dart:convert';
import 'package:flutter/material.dart';
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
  Future<ServiceResponse> login(String username, String password) async {
    const Base64Codec base64 = Base64Codec();
    var bytes = utf8.encode(clientName + ":" + clientSecret);
    var sendBase64 = base64.encode(bytes);

    Map<String, String> header = {
      "Authorization": "Basic " + sendBase64,
      "Content-Type": "application/x-www-form-urlencoded",
    };

    Map<String, dynamic> request = {
      'grant_type': 'password',
      'username': username,
      'password': password,
    };

    ServiceResponse response = await postFormFetch(
        url: apiSecurityLogin, body: request, header: header);
    if (response.statusHttp == 200) {
      await storage.write(
          key: 'access_token', value: response.body['access_token']);
      await storage.write(
          key: 'refresh_token', value: response.body['refresh_token']);

      Map<String, dynamic> payload =
          Jwt.parseJwt(response.body['access_token']);

      Preferences.userSession = UserSession.fromJson(payload['user']);
    }
    return response;
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
}
