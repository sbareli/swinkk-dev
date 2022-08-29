import 'dart:ui';

import 'package:get/get.dart';

class LanguageController extends GetxController {
  void changeLanguage(var lanName) {
    var locale = Locale(lanName);
    Get.updateLocale(locale);
  }
}
