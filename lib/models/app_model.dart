import 'package:flutter/material.dart';
import 'package:swiftlink/common/constants.dart';

class AppModel with ChangeNotifier {
  /// Language Code
  // String? _langCode = Configurations.defaultLanguage;
  String? _langCode = kAdvanceConfig['DefaultLanguage'];
  String? get langCode => _langCode;

  /// App Model Constructor
  AppModel([String? lang]) {
    _langCode = lang ?? 'en';
  }
}
