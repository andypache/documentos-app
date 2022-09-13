import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

///Create environment config
class Environment {
  //Generate properties from file enviroment
  static String get protocol => dotenv.env['PROTOCOL'] ?? '';
  static String get host => dotenv.env['HOST'] ?? '';
  static String get portSecurity => dotenv.env['PORT_SECURITY'] ?? '';
  static String get portCompany => dotenv.env['PORT_COMPANY'] ?? '';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get clientName => dotenv.env['CLIENT_NAME'] ?? '';
  static String get clientSecret => dotenv.env['CLIENT_SECRET'] ?? '';
  static String get prefixSecurity => dotenv.env['PREFIX_SECURITY'] ?? '';
  static String get prefixCompany => dotenv.env['PREFIX_COMPANY'] ?? '';

  //Load enviroment file
  static Future init() async {
    await dotenv.load(
        fileName: kReleaseMode
            ? "assets/.env.production"
            : "assets/.env.development");
  }
}
