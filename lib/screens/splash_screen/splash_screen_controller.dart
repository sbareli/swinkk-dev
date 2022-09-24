import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:swiftlink/common/constants/local_storage_key.dart';
import 'package:swiftlink/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:swiftlink/screens/authentication/sign_in/sign_in_screen_binding.dart';
import 'package:swiftlink/screens/users/onboarding_screen.dart';

class SplashScreenController extends GetxController {
  final GetStorage getStorage = GetStorage();

  @override
  void onInit() {
    startApp();
    super.onInit();
  }

  void startApp() async {
    Timer(const Duration(seconds: 3), () {
      if (getStorage.read(LocalStorageKey.isLogging) == true) {
        Get.offAll(
          () => const OnboardingScreenFirst(
              // login: userModel.login,
              // loginFB: userModel.loginFB,
              // loginApple: userModel.loginApple,
              // loginGoogle: userModel.loginGoogle,
              ),
        );
      } else {
        Get.offAll(
          () => SignInScreen(),
          binding: SigninScreenBindings(),
        );
      }
    });
  }
}
