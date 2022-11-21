import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/services/firebase_helper.dart';

class ForgotPasswordScreenController extends GetxController {
  final TextEditingController email = TextEditingController();

  Future<void> sendResetlink(BuildContext context) async {
    bool linkSended = await FireStoreUtils.resetPasswordLink(
      context: context,
      email: email.text.trim(),
    );
    if (linkSended) {
      Future.delayed(const Duration(seconds: 5), () {
        Get.back();
      });
    }
  }
}
