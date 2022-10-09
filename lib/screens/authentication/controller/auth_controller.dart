import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:swiftlink/common/constants/local_storage_key.dart';
import 'package:swiftlink/models/user_model.dart';
import 'package:swiftlink/screens/authentication/otp_verify/otp_verify_screen.dart';
import 'package:swiftlink/screens/authentication/otp_verify/otp_verify_screen_binding.dart';
import 'package:swiftlink/screens/authentication/registration/registration_screen.dart';
import 'package:swiftlink/screens/authentication/registration/registration_screen_binding.dart';
import 'package:swiftlink/screens/preference/preference.dart';
import 'package:swiftlink/screens/preference/preference_screen_binding.dart';
import 'package:swiftlink/services/base_firebase_services.dart';
import 'package:swiftlink/services/firebase_helper.dart';

class AuthController extends GetxController {
  User user = User();

  final TextEditingController phoneNumber = TextEditingController();
  GetStorage getStorage = GetStorage();

  @override
  void dispose() {
    phoneNumber.dispose();
    super.dispose();
  }

  Future<void> signupWithMobileNumber() async {
    user.phoneNumber = phoneNumber.text;
    await FireStoreUtils.signupWithMobileNumber(phoneNumber: phoneNumber.text);
    Get.to(
      () => const VerifyCode(),
      binding: OtpVerifyScreenBinding(user: user),
    );
  }

  Future<void> signupWithFacebook() async {
    User? user = await BaseFirebaseServices.signUpOrInWithFacebook();
    if (user != null) {
      handleUser(user);
    }
  }

  Future<void> signupWithGoogle() async {
    User? user = await BaseFirebaseServices.signUpOrInWithGoogle();
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
