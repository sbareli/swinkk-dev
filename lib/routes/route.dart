// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:swiftlink/common/utils/logs.dart';
// import 'package:swiftlink/common/utils/string_extensions.dart';
// import 'package:swiftlink/screens/users/onboarding_screen.dart';

// import '../common/constants.dart';
// import '../models/index.dart' show UserModel;
// import '../screens/index.dart';

// class Routes {
//   static Map<String, WidgetBuilder> getAll() => _routes;

//   static final Map<String, WidgetBuilder> _routes = {
//     RouteList.register: (context) => const RegistrationScreen(),
//     RouteList.login: (context) {
//       final userModel = Provider.of<UserModel>(context, listen: false);
//       return LoginScreen(
//         login: userModel.login,
//         loginFB: userModel.loginFB,
//         loginApple: userModel.loginApple,
//         loginGoogle: userModel.loginGoogle,
//       );
//     },
//     RouteList.loginSMS: (context) => const LoginSMSScreen(),
//     RouteList.verifyEmail: (context) => const VerifyEmailScreen(),
//     RouteList.onboarding: (context) => const OnboardingScreenFirst(),
//   };

//   static Route getRouteGenerate(RouteSettings settings) {
//     var routingData = settings.name!.getRoutingData;

//     printLog('[🧬Builder RouteGenerate] ${routingData.route}');

//     switch (routingData.route) {
//       case RouteList.home:
//         return _buildRoute(
//           settings,
//           (context) => const HomeScreen(),
//         );
//       default:
//         final allRoutes = {
//           ...getAll(),
//         };
//         if (allRoutes.containsKey(settings.name)) {
//           return _buildRoute(
//             settings,
//             allRoutes[settings.name!]!,
//           );
//         }

//         return _errorRoute();
//     }
//   }

//   static Route _errorRoute([String message = 'Page not founds']) {
//     return MaterialPageRoute(builder: (_) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Error'),
//         ),
//         body: Center(
//           child: Text(message),
//         ),
//       );
//     });
//   }

//   static MaterialPageRoute _buildRoute(RouteSettings settings, WidgetBuilder builder, {bool fullscreenDialog = false}) {
//     return MaterialPageRoute(
//       settings: settings,
//       builder: builder,
//       fullscreenDialog: fullscreenDialog,
//     );
//   }
// }
