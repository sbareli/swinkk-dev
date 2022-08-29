// import 'package:flutter/material.dart';
// import 'package:swiftlink/common/theme/theme.dart';

// import '../../common/config.dart';
// import '../../common/constants.dart';
// import '../../screens/base_screen.dart';

// class SplashScreenIndex extends StatelessWidget {
//   final Function actionDone;
//   final String splashScreenType;
//   // final String imageUrl;
//   final int duration;

//   const SplashScreenIndex({
//     Key? key,
//     required this.actionDone,
//     // required this.imageUrl,
//     this.splashScreenType = SplashScreenTypeConstants.static,
//     this.duration = 2000,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     switch (splashScreenType) {
//       case SplashScreenTypeConstants.static:
//       default:
//         return CustomFlash(
//           duration: duration,
//           onNextScreen: actionDone,
//         );
//       // return StaticSplashScreen(
//       //   imagePath: imageUrl,
//       //   onNextScreen: actionDone,
//       //   duration: duration,
//       // );
//     }
//   }
// }

// class _EmptySplashScreen extends StatefulWidget {
//   final Function? onNextScreen;
//   const _EmptySplashScreen({Key? key, this.onNextScreen}) : super(key: key);

//   @override
//   _EmptySplashScreenState createState() => _EmptySplashScreenState();
// }

// class _EmptySplashScreenState extends BaseScreen<_EmptySplashScreen> {
//   @override
//   void afterFirstLayout(BuildContext context) {
//     widget.onNextScreen!();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return kLoadingWidget(context);
//   }
// }

// class CustomFlash extends StatefulWidget {
//   final Function? onNextScreen;
//   final int duration;
//   const CustomFlash({required this.onNextScreen, required this.duration, Key? key}) : super(key: key);

//   @override
//   _CustomFlashState createState() => _CustomFlashState();
// }

// class _CustomFlashState extends BaseScreen<CustomFlash> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void afterFirstLayout(BuildContext context) {
//     Future.delayed(Duration(milliseconds: widget.duration, seconds: 2), () {
//       widget.onNextScreen!();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Constants.blue,
//         body: Center(
//           child: Image.asset(
//             "assets/images/Swinkk.png",
//             gaplessPlayback: true,
//             fit: BoxFit.contain,
//           ),
//         ));
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swiftlink/app.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/models/user_model.dart';
import 'package:get/get.dart';
import 'package:swiftlink/screens/home/home_screen.dart';
import 'package:swiftlink/screens/users/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final userModel = UserModel();

  @override
  void initState() {
    startTime();
    super.initState();
  }

  startTime() async {
    return Timer(
        const Duration(seconds: 3),
        () => Get.offAll(() => dataStorage.read('isLogging') == true
            ? LoginScreen()
            : LoginScreen(
                // login: userModel.login,
                // loginFB: userModel.loginFB,
                // loginApple: userModel.loginApple,
                // loginGoogle: userModel.loginGoogle,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.blue,
        body: Center(
          child: Image.asset(
            "assets/images/Swinkk.png",
            gaplessPlayback: true,
            fit: BoxFit.contain,
          ),
        ));
  }
}
