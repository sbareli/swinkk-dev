import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swiftlink/common/utils/logs.dart';
import 'package:swiftlink/generated/l10n.dart';
import 'package:swiftlink/modules/firebase/firebase_service.dart';
import 'package:swiftlink/screens/users/onboarding_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  var isEmailVerified = false;
  var canResendEmail = false;

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseServices().isEmailVerfied;

    if (!isEmailVerified) {
      sendVerificationEmail();
    }

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      checkEmailVerified();
    });
  }

  sendVerificationEmail() async {
    try {
      await FirebaseServices().auth!.currentUser!.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 10));
      setState(() => canResendEmail = true);
    } on Exception catch (e) {
      printLog(e.toString());
    }
  }

  checkEmailVerified() {
    FirebaseServices().auth!.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseServices().isEmailVerfied;
    });
    if (isEmailVerified) _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const OnboardingScreenFirst()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/Register3.png'), fit: BoxFit.cover),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Verification email sent',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'A verificaiton email has been sent to your email. Kindly check your email.',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        // const SizedBox(height: 30),
                        // TextField(
                        //   keyboardType: TextInputType.emailAddress,
                        //   onChanged: (value) {
                        //     email = value;
                        //   },
                        //   decoration: InputDecoration(
                        //     hintText: S.of(context).code,
                        //     isDense: true,
                        //   ),
                        // ),
                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: canResendEmail ? sendVerificationEmail : null,
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: Text('Resend Email'),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: FirebaseServices().auth!.signOut,
                          child: Text.rich(
                            TextSpan(
                              text: S.of(context).cancel,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
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
