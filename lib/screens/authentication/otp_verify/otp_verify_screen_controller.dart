import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/models/entities/user.dart';
import 'package:swiftlink/screens/authentication/registration/registration_screen.dart';
import 'package:swiftlink/screens/authentication/registration/registration_screen_binding.dart';
import 'package:swiftlink/services/base_firebase_services.dart';

class OtpVerifyScreenController extends GetxController {
  User user = User();
  OtpVerifyScreenController({
    required this.user,
  });

  RxBool isLoading = false.obs;

  final TextEditingController codeController = TextEditingController();
  RxBool hasError = false.obs;
  RxString currentText = ''.obs;
  late TapGestureRecognizer onTapRecognizer;

  Future<void> submitPhoneNumber() async {
    Map<String, dynamic>? responseCode = await BaseFirebaseServices.firebaseSubmitPhoneNumberCode(
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
      }
    }
  }
}