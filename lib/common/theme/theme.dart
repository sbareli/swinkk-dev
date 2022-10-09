import 'package:flutter/material.dart';

class Constants {
  static String appName = "Swinkk";

  //Colors for theme
  static Color lightPrimary = const Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightBG = const Color(0xfffeffff);
  static Color darkBG = Colors.black;
  static Color grey08 = const Color(0xffEEF0F2);
  static Color grey07 = const Color(0xfff3f4f6);
  static Color grey06 = const Color(0xffD7DCE1);
  static Color grey05 = const Color(0xffB6BFC9);
  static Color grey04 = const Color(0xffA3AFBB);
  static Color grey03 = const Color(0xff6C757D);
  static Color grey02 = const Color(0xff495057);
  static Color grey01 = const Color(0xff343a40);
  static Color appBlack = const Color(0xff212529);
  static Color blue = const Color(0xff0869FC);

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: const AppBarTheme(),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          backgroundColor: blue,
          primary: lightPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 17,
          )),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 5.0,
        primary: lightPrimary,
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: grey07,
      hintStyle: TextStyle(color: grey04),
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    ),
  );
  static ThemeData darkTheme = lightTheme;
}
