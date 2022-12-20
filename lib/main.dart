import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:swiftlink/app.dart';

/*
  bsb: testing under HEAD:new-main with branch refactor-phase-1
*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const SwinkkDevApp());
}
