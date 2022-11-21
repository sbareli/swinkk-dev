import 'package:flutter/gestures.dart';
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

class OtpVerifyScreenController extends GetxController {
  User user = User();
  OtpVerifyScreenController({
    required this.user,
  });

  RxBool isLoading = false.obs;
  GetStorage getStorage = GetStorage();
  final TextEditingController codeController = TextEditingController();
  RxBool hasError = false.obs;
  RxString currentText = ''.obs;
  late TapGestureRecognizer onTapRecognizer;

  Future<void> submitPhoneNumber() async {
    Map<String, dynamic>? responseCode = await FireStoreUtils.firebaseSubmitPhoneNumberCode(
      code: codeController.text,
      phoneNumber: user.phoneNumber.toString(),
    );

    if (responseCode != null) {
      if (responseCode['statusCode'] == '200') {
        user.id = responseCode['id'];
        Get.to(
          () => const RegistrationScreen(),
          binding: RegistrationScreenBinding(
            user: user,
          ),
        );
      } else if (responseCode['statusCode'] == '300') {
        User currentUser = responseCode['user'];
        getStorage.write(LocalStorageKey.currentUser, currentUser);
        getStorage.write(LocalStorageKey.currentUserUid, currentUser.id);
        getStorage.write(LocalStorageKey.currentUserUsereName, currentUser.userName);
        getStorage.write(LocalStorageKey.isLogging, true);

        Get.to(
          () => const PreferenceScreen(),
          binding: PreferenceScreenBindings(
            user: currentUser,
          ),
        );
      }
    }
  }
}
