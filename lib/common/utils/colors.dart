import 'package:flutter/material.dart';
import 'dart:ui';

Map<String, Color> colorStyles = {
  'primary': Colors.blue,
  'ligth_font': Colors.black54,
  'gray': Colors.black45,
  'white': Colors.white
};
const Color appColor = Color(0xff0259CB);
const Color darkblue = Color(0xff003E8F);
const Color offWhite = Color(0xffF8F8F8);
const Color whiteColor = Color(0xffFFFFFF);
const Color blackColor = Color(0xff000000);
const Color textfieldcolor = Color(0xff468AFF);

const Color backgroundGrey = Color(0xffECEFF3);
const Color lightGrey = Color(0xffF4F4F5);
const Color hintGrey = Color(0xffBABABA);
const Color contentGrey = Color(0xff969498);
const Color regularGrey = Color(0xff7F7D89);
const Color darkGreyBlue = Color(0xff2B2C36); //505050
const Color titleBlack = Color(0xff333333);

const Color lightappColor = Color(0xffFFE7E7);
const Color red = Color(0xffE8001B);
const Color orange = Color(0xffF27121);
const Color redcolor = Color(0xffE94057);
const Color success = Color(0xff5FB924);
const Color infoDialog = Color(0xff79B3E4);
const Color blue = Color(0xff068AEC);
const Color yellow = Color(0xffFFCC00);
const Color borderGrey = Color(0xffDBDBDB);

Color lightSilver = const Color(0xffF7F7F7);
Color darkSilver = const Color(0xffE4E4E4);
Color grey = const Color(0xff999999);

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

const MaterialColor primaryWhite = MaterialColor(
  _whitePrimaryValue,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(_whitePrimaryValue),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);
const int _whitePrimaryValue = 0xFFFFFFFF;

const int _scaffoldValue = 0xFFFAFAFA;
const MaterialColor scaffoldColor = MaterialColor(
  _scaffoldValue,
  <int, Color>{
    50: Color(0xFFFAFAFA),
    100: Color(0xFFFAFAFA),
    200: Color(0xFFFAFAFA),
    300: Color(0xFFFAFAFA),
    400: Color(0xFFFAFAFA),
    500: Color(_whitePrimaryValue),
    600: Color(0xFFFAFAFA),
    700: Color(0xFFFAFAFA),
    800: Color(0xFFFAFAFA),
    900: Color(0xFFFAFAFA),
  },
);
