import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/controller/language_change_controller/language_messages.dart';
import 'package:swiftlink/screens/splash_screen/splash_screen.dart';

class SwinkkDevApp extends StatelessWidget {
  const SwinkkDevApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      translations: LanguageMessages(),
      debugShowCheckedModeBanner: false,
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      home: const SplashScreen(),
    );
  }
}
// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:swiftlink/common/constants.dart';
// import 'package:swiftlink/common/theme/theme.dart';
// import 'package:swiftlink/screens/users/login_screen.dart';
// import 'package:swiftlink/screens/users/onboarding_screen.dart';
// import 'package:swiftlink/widgets/common/splash_screen.dart';

// import 'common/utils/logs.dart';
// import 'generated/l10n.dart';
// import 'generated/languages/index.dart';
// import 'models/index.dart';

//    final dataStorage = GetStorage();

// class App extends StatefulWidget {
//   final String languageCode;

//   const App({
//     Key? key,
//     required this.languageCode,
//   }) : super(key: key);

//   static final GlobalKey<NavigatorState> fluxStoreNavigatorKey = GlobalKey();

//   @override
//   State<StatefulWidget> createState() {
//     return AppState();
//   }
// }

// class AppState extends State<App> with WidgetsBindingObserver implements UserModelDelegate //,NotificationDelegate
// {
//   AppModel? _app;
//   final _user = UserModel();
//   // bool isFirstSeen = false;
//   bool isLoggedIn = false;

//   void appInitialModules() {
//     Future.delayed(
//       const Duration(milliseconds: 200),
//       () {
//         _user.delegate = this;
//       },
//     );
//   }

//   @override
//   void initState() {
//     printLog('[AppState] initState');
//     _app = AppModel(widget.languageCode);
//     WidgetsBinding.instance.addObserver(this);

//     appInitialModules();

//     super.initState();
//   }

//   @override
//   Future<void> onLoaded(User? user) async {}

//   @override
//   Future<void> onLoggedIn(User user) async => onLoaded(user);

//   @override
//   Future<void> onLogout(User? user) async {}

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.resumed) {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     printLog('[AppState] Build app.dart');
//     return GetMaterialApp(
//       initialRoute: '/',
//       getPages: [
//         GetPage(name: '/', page: () => const SplashScreen()),
//         GetPage(name: '/onboarding', page: () =>const OnboardingScreenFirst())

//       ],
//       debugShowCheckedModeBanner: false,
//       locale: const Locale('en'),
//       navigatorKey: App.fluxStoreNavigatorKey,
//       localizationsDelegates: const [
//         S.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         DefaultCupertinoLocalizations.delegate,
//         LocalWidgetLocalizations.delegate,
//       ],
//       supportedLocales: S.delegate.supportedLocales,
//       theme: Constants.lightTheme,
//       darkTheme: Constants.darkTheme,
//     );
//   }
// }

