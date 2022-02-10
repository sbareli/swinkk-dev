import 'package:flutter/material.dart';
import 'package:swiftlink/common/theme/theme.dart';

import '../../generated/l10n.dart';
import '../../services/index.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final TextEditingController forgotPasswordController = TextEditingController();

  bool isSubmitting = false;

  void onSubmitPassword(BuildContext context) async {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    var userName = forgotPasswordController.text.trim();
    if (userName.isEmpty) {
      final snackBar = SnackBar(
        content: Text(S.of(context).cannotBeEmpty),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    setState(() {
      isSubmitting = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      Services().firebase.sendPasswordResetEmail(email: userName);
      setState(() {
        isSubmitting = false;
      });
      const snackBar = SnackBar(
        content: Text('Password reset email sent'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      setState(() {
        isSubmitting = false;
      });
      final snackBar = SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    forgotPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/ForgotPassword1.png'), fit: BoxFit.cover),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    S.of(context).forgotPassword,
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
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: forgotPasswordController,
                    // validator: _emailValidator,
                    decoration: InputDecoration(
                      hintText: S.of(context).emailAddress,
                      helperText: '',
                      isDense: true,
                      prefixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Image.asset(
                          'assets/images/envelopIcon.png',
                          scale: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () => isSubmitting ? null : onSubmitPassword(context),
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(isSubmitting ? S.of(context).loading : S.of(context).continueText),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text.rich(
                      TextSpan(
                        text: S.of(context).back,
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
