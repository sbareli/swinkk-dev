// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'common/constants.dart';
// import 'common/utils/logs.dart';
// import 'screens/base_screen.dart';
// import 'services/index.dart';
// import 'widgets/common/splash_screen.dart';

// class AppInit extends StatefulWidget {
//   const AppInit({Key? key}) : super(key: key);

//   @override
//   _AppInitState createState() => _AppInitState();
// }

// class _AppInitState extends BaseScreen<AppInit> {
//   bool isLoggedIn = false;
//   bool hasLoadedData = false;
//   bool hasLoadedSplash = false;

//   /// Check if the App is Login
//   bool checkLogin() {
//     final hasLogin = injector<SharedPreferences>().getBool('loggedIn');
//     return hasLogin ?? false;
//   }

//   Future<void> loadInitData() async {
//     try {
//       printLog('[AppState] Init Data 💫');
//       // isFirstSeen = checkFirstSeen();
//       isLoggedIn = checkLogin();

//       Future.delayed(Duration.zero, () {
//         hasLoadedData = true;
//         if (hasLoadedSplash) {
//           goToNextScreen();
//         }
//       });

//       printLog('[AppState] InitData Finish');
//     } catch (e, trace) {
//       printLog(e.toString());
//       printLog(trace.toString());
//     }
//   }

//   void goToNextScreen() {
//     if (/*kLoginSetting['IsRequiredLogin'] && */ !isLoggedIn) {
//       Navigator.of(context).pushReplacementNamed(RouteList.login);
//       return;
//     }

//     Navigator.of(context).pushReplacementNamed(RouteList.onboarding);
//   }

//   void checkToShowNextScreen() {
//     /// If the config was load complete then navigate to Dashboard
//     hasLoadedSplash = true;
//     if (hasLoadedData) {
//       goToNextScreen();
//       return;
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   void afterFirstLayout(BuildContext context) async {
//     await loadInitData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var splashScreenType = '';
//     // dynamic splashScreenImage = kSplashScreen['image'];
//     var duration = 2000;
//     return SplashScreenIndex(
//       // imageUrl: splashScreenImage,
//       splashScreenType: splashScreenType,
//       actionDone: checkToShowNextScreen,
//       duration: duration,
//     );
//   }
// }
