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
