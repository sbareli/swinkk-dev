import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:swiftlink/common/constants/local_storage_key.dart';
import 'package:swiftlink/models/user_model.dart';
import 'package:swiftlink/screens/authentication/registration/registration_screen.dart';
import 'package:swiftlink/screens/authentication/registration/registration_screen_binding.dart';
import 'package:swiftlink/screens/preference/preference.dart';
import 'package:swiftlink/screens/preference/preference_screen_binding.dart';
import 'package:swiftlink/services/firebase_helper.dart';

class SignUpScreenController extends GetxController {
  User user = User();
  GetStorage getStorage = GetStorage();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  Future<void> signupWithEmailPassword(BuildContext context) async {
    if (password.text == confirmPassword.text) {
      User? user = await FireStoreUtils.signUpUser(
        context: context,
        email: email.text.trim(),
        password: password.text.trim(),
      );
      if (user != null) {
        handleUser(user);
      }
    }
  }

  Future<void> signupWithFacebook() async {
    User? user = await FireStoreUtils.loginWithFacebook();
    if (user != null) {
      handleUser(user);
    }
  }

  Future<void> signupWithGoogle() async {
    User? user = await FireStoreUtils.loginWithFacebook();
    if (user != null) {
      handleUser(user);
    }
  }

  void handleUser(User user) {
    if (user.userName != null) {
      getStorage.write(LocalStorageKey.currentUser, user);
      getStorage.write(LocalStorageKey.currentUserUid, user.id);
      getStorage.write(LocalStorageKey.currentUserUsereName, user.userName);
      getStorage.write(LocalStorageKey.isLogging, true);
      Get.to(
        () => const PreferenceScreen(),
        binding: PreferenceScreenBindings(
          user: user,
        ),
      );
    } else {
      Get.to(
        () => const RegistrationScreen(),
        binding: RegistrationScreenBinding(user: user),
      );
    }
  }
}
