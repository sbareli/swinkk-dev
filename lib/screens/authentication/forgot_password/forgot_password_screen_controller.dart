import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/services/validators.dart';

class ForgotPasswordScreenController extends GetxController {
  RxBool isSubmitting = false.obs;

  void onSubmitPassword(BuildContext context, String enterUserName) async {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    String? userName = Validators.validateEmail(enterUserName.trim());
    if (userName != null) {
      final SnackBar snackBar = SnackBar(
        content: Text(userName),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    isSubmitting.value = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Services().firebase.sendPasswordResetEmail(email: userName);
      isSubmitting.value = false;
      const snackBar = SnackBar(
        content: Text('Password reset email sent'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      isSubmitting.value = false;
      final snackBar = SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
  }
}
