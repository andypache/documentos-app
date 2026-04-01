import 'package:flutter/material.dart';

///Create thema app
class AppTheme {
  //Colors app

  //static const Color primary = Color(0xff2E305F);
  //static const Color primary = Color(0xff608CEE);

  //ok color red
  //static const Color primary1 = Color(0xff750404);
  //static const Color secondary2 = Color(0xff202333);

  //color hventas
  static const Color primary = Color(0xff16434D);
  static const Color secondary = Color(0xff202333);
  static const Color primaryButton = Color(0xff51cbce);
  static const Color secondaryButton = Color(0xff51cb90);

  static const Color white = Colors.white;
  static const Color blue = Colors.blue;
  static const Color pinkAccent = Colors.pinkAccent;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color pink = Colors.pink;
  static const Color red = Colors.red;
  static const Color transparent = Colors.transparent;

  // Colores de notificación empresarial
  static const Color notificationWarning = Color(0xFFFFA000);
  static const Color notificationErrorBg = Color(0xFF3B1A1A);
  static const Color notificationSuccessBg = Color(0xFF16311F);
  static const Color notificationWarningBg = Color(0xFF332600);
  static const Color notificationInfoBg = Color(0xFF0D2137);

  // Colores de acciones empresariales
  static const Color actionSave = Color(0xFF388E3C); // verde guardar
  static const Color actionSaveDark = Color(0xFF00695C); // teal guardar paso
  static const Color actionDanger = Color(0xFFC62828); // rojo peligro/logout

  // Colores de la pantalla de login
  static const Color loginCardBg =
      Color(0xFF1A3A42); // card oscuro sobre gradiente
  static const Color loginInputBorder = Color(0xFF2E6A78); // borde de inputs
  static const Color loginInputFill = Color(0xFF0F2B32); // fondo de inputs
  static const Color loginDivider = Color(0xFF2E6A78); // divisor

  // Colores del menú principal (swiper cards)
  static const Color menuBill = Color(0xFFFF8F00); // naranja facturar
  static const Color menuClient = Color(0xFF43A047); // verde clientes
  static const Color menuItem = Color(0xFFFFB300); // ámbar productos
  static const Color menuReport = Color(0xFF1E88E5); // azul reportes
  static const Color menuReview = Color(0xFFEC407A); // rosa revisión
  static const Color menuConfig = Color(0xFF26C6DA); // cyan configuración

  // Bottom navigation bar
  static const Color bottomNavBg = Color(0xFF1A2236); // fondo barra inferior

  static const Color primaryGradient = Color.fromRGBO(236, 98, 188, 1);
  static const Color secondaryGradient = Color.fromRGBO(251, 142, 172, 1);
  static const Color whiteGradient = Color.fromRGBO(255, 255, 255, 0.1);

  static const Color targetGradient = Color.fromRGBO(62, 66, 107, 0.7);

  static const Color primaryBottomGradient = Color.fromRGBO(55, 57, 84, 1);
  static const Color secondaryBottomGradient = Color.fromRGBO(116, 117, 152, 1);

  ///Overwrite theme
  static final ThemeData lightTheme = ThemeData.light().copyWith(
      //
      scaffoldBackgroundColor: primaryButton,
      //const Color.fromRGBO(150, 20, 45, 1), //Color(0xff1D2D42),
      // AppBar Theme
      appBarTheme: const AppBarTheme(color: primary, elevation: 0),
      // TextButton Theme
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primary)),
      // FloatingActionButtons
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary, elevation: 5),
      // ElevatedButtons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: const StadiumBorder(),
            elevation: 0),
      ),
      //Decoration text input
      inputDecorationTheme: const InputDecorationTheme(
          //floatingLabelStyle: TextStyle(color: primary),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10))),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10)))));
}
