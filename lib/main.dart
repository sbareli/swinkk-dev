import 'export.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const SwinkkDevApp());
}

// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/foundation.dart' as foundation;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'app.dart';
// import 'common/constants.dart';
// import 'common/utils/logs.dart';
// import 'services/dependency_injection.dart';
// import 'services/locale_service.dart';
// import 'services/services.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     systemNavigationBarColor: Colors.black,
//   ));

//   var languageCode = 'en';

//   runZonedGuarded(() async {
//     if (!foundation.kIsWeb) {
//       /// Enable network traffic logging.
//       HttpClient.enableTimelineLogging = !foundation.kReleaseMode;

//       /// Lock portrait mode.
//       unawaited(SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp
//       ]));
//     }

//     if (isMobile) {
//       await Services().firebase.init();
//     }
//     await DependencyInjection.inject();

//     if (isMobile) {
//       final lang = injector<SharedPreferences>().getString('language');

//       if (lang?.isEmpty ?? true) {
//         languageCode = await LocaleService().getDeviceLanguage();
//       } else {
//         languageCode = lang.toString();
//       }
//     }

//     ResponsiveSizingConfig.instance.setCustomBreakpoints(
//       const ScreenBreakpoints(
//         desktop: 900,
//         tablet: 600,
//         watch: 100,
//       ),
//     );
//     runApp(App(languageCode: languageCode));
//   }, (e, stack) {
//     printLog(e);
//     printLog(stack);
//   });
// }
