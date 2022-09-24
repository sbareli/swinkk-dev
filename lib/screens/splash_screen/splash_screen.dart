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

import 'package:flutter/material.dart';
import 'package:swiftlink/common/constants/app_asset.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:get/get.dart';
import 'package:swiftlink/screens/splash_screen/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
      init: SplashScreenController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          body: Center(
            child: Image.asset(
              AppAsset.appLogo,
              gaplessPlayback: true,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
