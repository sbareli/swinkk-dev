import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/screens/splash_screen/splash_screen.dart';

class SwinkkDevApp extends StatelessWidget {
  const SwinkkDevApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      home: const SplashScreen(),
    );
  }
}
