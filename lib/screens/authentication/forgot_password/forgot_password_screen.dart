import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/common/constants/app_asset.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/screens/authentication/forgot_password/forgot_password_screen_controller.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordScreenController> {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  final TextEditingController forgotPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(AppAsset.forgotPasswordOne), fit: BoxFit.cover),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(color: Constants.appBlack, fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Enter the email address linked to your account.',
                      style: TextStyle(fontWeight: FontWeight.w300, color: Constants.grey02),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: forgotPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Email address',
                      helperText: '',
                      isDense: true,
                      prefixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Image.asset(
                          AppAsset.email,
                          scale: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      if (controller.isSubmitting.value) {
                      } else {
                        controller.onSubmitPassword(context, forgotPasswordController.text);
                      }
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Obx(
                      () => Text(
                        controller.isSubmitting.value ? 'loading...' : 'Continue',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text.rich(
                      TextSpan(
                        text: 'Back',
                        style: TextStyle(color: Constants.grey01, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
