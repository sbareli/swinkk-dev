import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:swiftlink/common/constants/app_asset.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/common/utils/static_decoration.dart';
import 'package:swiftlink/screens/authentication/forgot_password/forgot_password_screen_controller.dart';
import 'package:swiftlink/services/validators.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordScreenController> {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                AppAsset.forgotPasswordOne,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password',
                      style: TextStyle(color: Constants.appBlack, fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    height20,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Enter your email and we will send you a password reset link',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w300, color: Constants.grey02),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: controller.email,
                      validator: (String? value) => Validators.validateEmail(value),
                      decoration: const InputDecoration(
                        hintText: 'Enter email',
                        helperText: '',
                        isDense: true,
                        prefixIcon: Align(
                            widthFactor: 2.5,
                            heightFactor: 1,
                            child: Icon(
                              Icons.email_outlined,
                              size: 20,
                              color: Color(0xffFB9A08),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          controller.sendResetlink(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Send'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text.rich(
                        TextSpan(
                          text: 'back',
                          style: TextStyle(color: Constants.grey01, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
