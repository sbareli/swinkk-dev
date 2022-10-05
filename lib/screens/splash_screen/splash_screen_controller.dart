import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:swiftlink/models/entities/user.dart';
import 'package:swiftlink/screens/home/home_screen.dart';
import 'package:swiftlink/services/base_firebase_services.dart';
import 'package:swiftlink/services/firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:swiftlink/screens/preference/preference.dart';
import 'package:swiftlink/common/constants/local_storage_key.dart';
import 'package:swiftlink/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:swiftlink/screens/authentication/sign_in/sign_in_screen_binding.dart';
import 'package:swiftlink/screens/preference/preference_screen_binding.dart';

class SplashScreenController extends GetxController {
  final GetStorage getStorage = GetStorage();

  @override
  void onInit() {
    startApp();
    super.onInit();
  }

  void startApp() async {
    await FireStoreUtils.getSystem();
    Timer(const Duration(seconds: 3), () async {
      if (getStorage.read(LocalStorageKey.isLogging) == true) {
        auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          User? user = await BaseFirebaseServices.getCurrentUser(userId: firebaseUser.uid);
          if (user != null) {
            getStorage.write(LocalStorageKey.currentUser, user);
            bool? isServiceAdded = await BaseFirebaseServices.isServiceAdded(user.userName!);
            if (isServiceAdded == true) {
              Get.offAll(
                () => const PreferenceScreen(),
                binding: PreferenceScreenBindings(
                  user: user,
                ),
              );
            } else {
              Get.offAll(
                () => const HomeScreen(),
              );
            }
          } else {
            Get.offAll(
              () => const SignInScreen(),
              binding: SigninScreenBindings(),
            );
          }
        } else {
          Get.offAll(
            () => const SignInScreen(),
            binding: SigninScreenBindings(),
          );
        }
      } else {
        Get.offAll(
          () => const SignInScreen(),
          binding: SigninScreenBindings(),
        );
      }
    });
  }
}
