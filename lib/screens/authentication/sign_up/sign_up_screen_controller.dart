import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/models/entities/user.dart';
import 'package:swiftlink/screens/authentication/otp_verify/otp_verify_screen.dart';
import 'package:swiftlink/screens/authentication/otp_verify/otp_verify_screen_binding.dart';
import 'package:swiftlink/services/firebase_helper.dart';

class SignUpScreenController extends GetxController {
  User user = User();

  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneNumber.dispose();
    password.dispose();
    confirmPassword.dispose();
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
}
