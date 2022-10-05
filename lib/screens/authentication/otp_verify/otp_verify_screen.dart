import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/common/constants/app_asset.dart';
import 'package:swiftlink/screens/authentication/otp_verify/otp_verify_screen_controller.dart';

class VerifyCode extends GetView<OtpVerifyScreenController> {
  const VerifyCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  AppAsset.registerThree,
                ),
                fit: BoxFit.cover),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Enter verification code',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Enter the confirmation code we have sent on your email address or phone number.',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.codeController,
                    decoration: const InputDecoration(
                      hintText: 'Code',
                      isDense: true,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    onPressed: controller.submitPhoneNumber,
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Confirm'),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Cancel',
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

// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:swiftlink/common/constants/route_list.dart';
// // import 'package:provider/provider.dart';

// import '../../generated/l10n.dart';

// class VerifyCode extends StatefulWidget {
//   final String? phoneNumber;
//   final String? verId;
//   final verifySuccessStream;

//   const VerifyCode({
//     Key? key,
//     this.verId,
//     this.phoneNumber,
//     this.verifySuccessStream,
//   }) : super(key: key);

//   @override
//   _VerifyCodeState createState() => _VerifyCodeState();
// }

// class _VerifyCodeState extends State<VerifyCode> {
//   bool isLoading = false;

//   final TextEditingController _pinCodeController = TextEditingController();

//   bool hasError = false;
//   String currentText = '';
//   late TapGestureRecognizer onTapRecognizer;

//   Future<void> _verifySuccessStreamListener(credential) async {
//     if (mounted) {
//       setState(() {
//         _pinCodeController.text = credential.smsCode!;
//       });
//       // Tools.hideKeyboard(context);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     widget.verifySuccessStream?.listen(_verifySuccessStreamListener);

//     onTapRecognizer = TapGestureRecognizer()
//       ..onTap = () {
//         Get.back();
//       };
//   }

//   @override
//   void dispose() {
//     widget.verifySuccessStream?.listen(null);
//     _pinCodeController.dispose();
//     super.dispose();
//   }

//   void _welcomeMessage(context) {
//     var routeFound = false;
//     var routeNames = [
//       RouteList.onboarding,
//       // RouteList.productDetail
//     ];
//     Navigator.popUntil(context, (route) {
//       if (routeNames.any((element) => route.settings.name?.contains(element) ?? false)) {
//         routeFound = true;
//       }
//       return routeFound || route.isFirst;
//     });

//     if (!routeFound) {
//       Navigator.of(context).pushReplacementNamed(RouteList.onboarding);
//     }
//   }

//   void _failMessage(message, context) {
//     /// Showing Error messageSnackBarDemo
//     /// Ability so close message
//     var _message = message;
//     if (kReleaseMode) {
//       _message = S.of(context).couldNotVerifyCheckTheEnteredDetails;
//     }

//     final snackBar = SnackBar(
//       content: Text(_message),
//       duration: const Duration(seconds: 30),
//       action: SnackBarAction(
//         label: S.of(context).close,
//         onPressed: () {
//           // Some code to undo the change.
//         },
//       ),
//     );
//     // ignore: deprecated_member_use
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   void _loginSMS(String smsCode, context) async {
//     try {
//       if (smsCode.isEmpty) {
//         _failMessage('code cannot be empty', context);
//         return;
//       }
//       // final credential = Services().firebase.getFirebaseCredential(
//       //       verificationId: widget.verId!,
//       //       smsCode: smsCode,
//       //     );

//       // await _signInWithCredential(credential);
//     } catch (e) {
//       _failMessage(e.toString(), context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(image: AssetImage('assets/images/Register3.png'), fit: BoxFit.cover),
//           ),
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     'Enter verification code',
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   const SizedBox(height: 5),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Text(
//                       S.of(context).enterTheConfirmationCodeWeHaveSentOnYourEmail,
//                       style: Theme.of(context).textTheme.bodyText2,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   TextField(
//                     keyboardType: TextInputType.emailAddress,
//                     controller: _pinCodeController,
//                     // onChanged: (value) {
//                     //   email = value;
//                     // },
//                     decoration: InputDecoration(
//                       hintText: S.of(context).code,
//                       isDense: true,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   TextButton(
//                     onPressed: () => _loginSMS(_pinCodeController.text, context),
//                     style: TextButton.styleFrom(
//                       minimumSize: const Size.fromHeight(50),
//                     ),
//                     child: Text(S.of(context).confirm),
//                   ),
//                   const SizedBox(
//                     height: 50,
//                   ),
//                   GestureDetector(
//                     onTap: () => Navigator.of(context).pop(),
//                     child: Text.rich(
//                       TextSpan(
//                         text: S.of(context).cancel,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _signInWithCredential(credential) async {
//     // final user = await Services().firebase.loginFirebaseCredential(credential: credential);
//     // if (user != null) {
//     // await Provider.of<UserModel>(context, listen: false).loginFirebaseSMS(
//     //   phoneNumber: user.phoneNumber!.replaceAll('+', ''),
//     //   success: () {
//     //     // _stopAnimation();
//     //     _welcomeMessage(context);
//     //   },
//     //   fail: (message) {
//     //     // _stopAnimation();
//     //     _failMessage(message, context);
//     //   },
//     // );
//     // } else {
//     // await _stopAnimation();
//     //   _failMessage(S.of(context).codeEnteredIsNotCorrect, context);
//     // }
//   }
// }
