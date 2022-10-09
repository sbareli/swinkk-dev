import 'package:flutter/material.dart';
import 'package:swiftlink/common/constants/app_asset.dart';
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
