import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/common/constants/app_asset.dart';
import 'package:swiftlink/common/utils/colors.dart';
import 'package:swiftlink/common/utils/static_decoration.dart';
import 'package:swiftlink/screens/authentication/forgot_password/forgot_password_screen.dart';
import 'package:swiftlink/screens/authentication/forgot_password/forgot_password_screen_bindings.dart';
import 'package:swiftlink/screens/authentication/sign_in/sign_in_screen_controller.dart';
import 'package:swiftlink/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:swiftlink/screens/authentication/sign_up/sign_up_screen_bindings.dart';
import 'package:swiftlink/services/validators.dart';

class SignInScreen extends GetView<SignInScreenController> {
  SignInScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAsset.signInBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: AutofillGroup(
            child: SizedBox(
              height: Get.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
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
                      TextFormField(
                        obscureText: true,
                        controller: controller.password,
                        validator: (String? value) => Validators.validatePassword(value),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          helperText: '',
                          isDense: true,
                          prefixIcon: Align(
                            widthFactor: 3.2,
                            heightFactor: 1,
                            child: Image.asset(
                              AppAsset.lockIcon,
                              scale: 2,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => ForgotPasswordScreen(),
                              binding: ForgotPasswordScreenBinding(),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: appColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      height20,
                      TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            controller.signIpWithEmailPassword(context);
                          }
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Continue'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'or sign up with your social media',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          authButtons(
                            imagePath: 'assets/images/google.png',
                            function: () async {
                              controller.signupWithGoogle();
                            },
                          ),
                          authButtons(
                            imagePath: 'assets/images/facebook.png',
                            function: () async {
                              await controller.signupWithFacebook();
                            },
                          ),
                          if (Platform.isIOS)
                            authButtons(
                              imagePath: 'assets/images/apple.png',
                              function: () {},
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Dont have an account? '),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => SignUpScreen(),
                                binding: SignUpScreenBinding(),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(color: Constants.blue, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget authButtons({
    required String imagePath,
    required Function() function,
  }) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(0, 2.0),
            ),
          ],
        ),
        child: Image.asset(
          imagePath,
          height: 45,
          width: 45,
        ),
      ),
    );
  }
}


// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:swiftlink/common/theme/theme.dart';
// import 'package:swiftlink/common/utils/logs.dart';
// import 'package:swiftlink/common/utils/string_extensions.dart';
// import 'package:swiftlink/generated/l10n.dart';
// import 'package:swiftlink/screens/home/home_screen.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';

// import '../../common/config.dart';
// import '../../common/constants.dart';

// import '../base_screen.dart';
// import 'forgot_password_screen.dart';

// typedef LoginSocialFunction = Future<void> Function({
//   required Function() success,
//   required Function(String) fail,
//   BuildContext context,
// });

// typedef LoginFunction = Future<void> Function({
//   required String username,
//   required String password,
//   required Function() success,
//   required Function(String) fail,
// });

// class LoginScreen extends StatefulWidget {
//   final LoginFunction login;
//   final LoginSocialFunction loginFB;
//   final LoginSocialFunction loginApple;
//   final LoginSocialFunction loginGoogle;
//   final VoidCallback? loginSms;

//   const LoginScreen({
//     Key? key,
//     required this.login,
//     required this.loginFB,
//     required this.loginApple,
//     required this.loginGoogle,
//     this.loginSms,
//   }) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends BaseScreen<LoginScreen> with TickerProviderStateMixin {
//   bool isPasswordVisible = false;

//   String? _emailValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Cannot be empty';
//     }
//     if (value.contains('@') && !value.isValidEmailFormat) {
//       return 'Not a valid email address';
//     }
//   }

//   String? _passwordValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Cannot be empty';
//     }
//   }

//   final TextEditingController username = TextEditingController();
//   final TextEditingController password = TextEditingController();

//   bool isLoading = false;
//   bool isAvailableApple = false;
//   bool isActiveAudio = false;
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Future<void> afterFirstLayout(BuildContext context) async {
//     try {
//       isAvailableApple = (await TheAppleSignIn.isAvailable());
//       setState(() {});
//     } catch (e) {
//       printLog('[Login] afterFirstLayout error');
//     }
//   }

//   @override
//   void dispose() async {
//     username.dispose();
//     password.dispose();
//     super.dispose();
//   }

//   Future _welcomeMessage() async {
//     Get.to(() => const HomeScreen());
//   }

//   void _failMessage(String message) {
//     /// Showing Error messageSnackBarDemo
//     /// Ability so close message
//     if (message.isEmpty) return;

//     var _message = message;

//     final snackBar = SnackBar(
//       content: Text(S.of(context).warning(_message)),
//       duration: const Duration(seconds: 30),
//       action: SnackBarAction(
//         label: S.of(context).close,
//         onPressed: () {
//           // Some code to undo the change.
//         },
//       ),
//     );

//     ScaffoldMessenger.of(context)
//       ..removeCurrentSnackBar()
//       ..showSnackBar(snackBar);
//   }

//   void _loginFacebook(context) async {
//     showLoading();
//     await widget.loginFB(
//       success: () {
//         hideLoading();
//         _welcomeMessage();
//       },
//       fail: (message) {
//         hideLoading();
//         _failMessage(message);
//       },
//       context: context,
//     );
//   }

//   void _loginApple(context) async {
//     showLoading();
//     await widget.loginApple(
//         success: () {
//           hideLoading();
//           _welcomeMessage();
//         },
//         fail: (message) {
//           hideLoading();
//           _failMessage(message);
//         },
//         context: context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     void launchForgetPasswordURL() async {
//       await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
//       );
//     }

//     void _login(context) async {
//       if (_formKey.currentState!.validate()) {
//         showLoading();
//         await widget.login(
//           username: username.text.trim(),
//           password: password.text.trim(),
//           success: () {
//             hideLoading();
//             username.clear();
//             password.clear();
//             _welcomeMessage();
//           },
//           fail: (message) {
//             hideLoading();
//             _failMessage(message);
//           },
//         );
//       }
//     }

//     void _loginSMS(context) {
//       if (widget.loginSms != null) {
//         widget.loginSms!();
//         return;
//       }

//       Navigator.of(context).pushNamed(RouteList.loginSMS);
//     }

//     void _loginGoogle(context) async {
//       // await _playAnimation();
//       showLoading();
//       await widget.loginGoogle(
//           success: () {
//             hideLoading();
//             // _stopAnimation();
//             _welcomeMessage();
//           },
//           fail: (message) {
//             hideLoading();
//             // _stopAnimation();
//             _failMessage(message);
//           },
//           context: context);
//     }

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/signin2x.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: AutofillGroup(
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       TextFormField(
//                         keyboardType: TextInputType.emailAddress,
//                         controller: username,
//                         validator: _emailValidator,
//                         decoration: InputDecoration(
//                           hintText: S.of(context).emailAddress,
//                           helperText: '',
//                           isDense: true,
//                           prefixIcon: Align(
//                             widthFactor: 1.0,
//                             heightFactor: 1.0,
//                             child: Image.asset(
//                               'assets/images/envelopIcon.png',
//                               scale: 2,
//                             ),
//                           ),
//                         ),
//                       ),
//                       TextFormField(
//                         obscureText: !isPasswordVisible,
//                         controller: password,
//                         validator: _passwordValidator,
//                         decoration: InputDecoration(
//                           hintText: S.of(context).password,
//                           helperText: '',
//                           isDense: true,
//                           prefixIcon: Align(
//                             widthFactor: 3.2,
//                             heightFactor: 1,
//                             child: Image.asset(
//                               'assets/images/lockIcon.png',
//                               scale: 2,
//                             ),
//                           ),
//                           suffixIcon: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 isPasswordVisible = !isPasswordVisible;
//                               });
//                             },
//                             child: !isPasswordVisible
//                                 ? Image.asset(
//                                     'assets/images/eye_off_icon.png',
//                                     scale: 2,
//                                   )
//                                 : const SizedBox(
//                                     height: 24,
//                                     width: 24,
//                                   ),
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: GestureDetector(
//                           onTap: () {
//                             launchForgetPasswordURL();
//                           },
//                           behavior: HitTestBehavior.opaque,
//                           child: Text(
//                             S.of(context).forgotPassword,
//                             style: TextStyle(color: Constants.blue, fontWeight: FontWeight.bold, fontSize: 13),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: screenSize.height * 0.03),
//                       TextButton(
//                         onPressed: () {
//                           if (!isLoading) {
//                             _login(context);
//                           }
//                         },
//                         style: TextButton.styleFrom(
//                           minimumSize: const Size.fromHeight(50),
//                         ),
//                         child: Text(S.of(context).continueText),
//                       ),
//                       SizedBox(height: screenSize.height * 0.01),
//                       Text(
//                         S.of(context).or,
//                         style: TextStyle(color: Constants.grey03),
//                       ),
//                       SizedBox(height: screenSize.height * 0.02),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: <Widget>[
//                           // if (kLoginSetting['showAppleLogin'] && isAvailableApple)
//                           if (isAvailableApple)
//                             InkWell(
//                               onTap: () => _loginApple(context),
//                               child: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(40),
//                                   color: Colors.black87,
//                                 ),
//                                 child: Image.asset(
//                                   'assets/images/Apple.png',
//                                   width: 26,
//                                   height: 26,
//                                 ),
//                               ),
//                             ),

//                           InkWell(
//                             onTap: () => _loginFacebook(context),
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(40),
//                                 color: const Color(0xFF4267B2),
//                               ),
//                               child: const Icon(
//                                 Icons.facebook_rounded,
//                                 color: Colors.white,
//                                 size: 34.0,
//                               ),
//                             ),
//                           ),

//                           InkWell(
//                             onTap: () => _loginGoogle(context),
//                             child: Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(40),
//                                 color: Colors.grey.shade300,
//                               ),
//                               child: Image.asset(
//                                 'assets/images/Google.png',
//                                 width: 28,
//                                 height: 28,
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () => _loginSMS(context),
//                             child: Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(40),
//                                 color: Colors.lightBlue.shade50,
//                               ),
//                               child: Image.asset(
//                                 'assets/images/sms.png',
//                                 width: 28,
//                                 height: 28,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: screenSize.height * 0.03),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Text(S.of(context).dontHaveAnAccount),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).pushNamed(RouteList.register);
//                             },
//                             child: Text(
//                               ' ${S.of(context).signUp}',
//                               style: TextStyle(color: Constants.blue, fontWeight: FontWeight.bold, fontSize: 13),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: screenSize.height * 0.01),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void showLoading() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Center(
//             child: Container(
//           padding: const EdgeInsets.all(50.0),
//           child: kLoadingWidget(context),
//         ));
//       },
//     );
//   }

//   void hideLoading() {
//     Navigator.of(context).pop();
//   }
// }
