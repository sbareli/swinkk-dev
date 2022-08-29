import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swiftlink/common/constants.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/common/utils/string_extensions.dart';
import 'package:swiftlink/generated/l10n.dart';
// import 'package:provider/provider.dart';

import '../../models/index.dart' show UserModel;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    if (value.contains('@') && !value.isValidEmailFormat) {
      return 'Not a valid email address';
    }
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    if (value != password.text) {
      return 'Passwords do not match';
    }
  }

  void _snackBar(String text) {
    if (mounted) {
      final snackBar = SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: S.of(context).close,
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      // ignore: deprecated_member_use
      _scaffoldKey.currentState!.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/Register1n2.png'), fit: BoxFit.cover),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/WelcometoSwinkk.png',
                    scale: 2,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Create account',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    // width: 400,
                    height: 402,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: username,
                            validator: _emailValidator,
                            // onChanged: (value) {
                            //   email = value;
                            // },
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
                          // const SizedBox(
                          //   height: 4,
                          // ),
                          TextFormField(
                            obscureText: true,
                            controller: password,
                            validator: _passwordValidator,
                            // onChanged: (value) {
                            //   password = value;
                            // },
                            decoration: InputDecoration(
                              hintText: S.of(context).password,
                              helperText: '',
                              isDense: true,
                              prefixIcon: Align(
                                widthFactor: 3.2,
                                heightFactor: 1,
                                child: Image.asset(
                                  'assets/images/lockIcon.png',
                                  scale: 2,
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(
                          //   height: 4,
                          // ),
                          TextFormField(
                            obscureText: true,
                            controller: confirmPassword,
                            validator: _confirmPasswordValidator,
                            // onChanged: (value) {
                            //   password = value;
                            // },
                            decoration: InputDecoration(
                              hintText: S.of(context).confirmPassword,
                              helperText: '',
                              isDense: true,
                              prefixIcon: Align(
                                widthFactor: 3.2,
                                heightFactor: 1,
                                child: Image.asset(
                                  'assets/images/lockIcon.png',
                                  scale: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // await Provider.of<UserModel>(context, listen: false).createUser(
                                //   username: username.text.trim(),
                                //   password: password.text.trim(),
                                //   success: () => Navigator.of(context).pushNamed(RouteList.verifyEmail),
                                //   fail: _snackBar,
                                // );
                              }
                            },
                            // onPressed: () =>
                            //     Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) => const RegisterThird(),
                            // )),
                            style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: Text(S.of(context).next),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text.rich(
                            TextSpan(
                              text: '${S.of(context).alreadyHaveAnAccount} ',
                              children: [
                                TextSpan(
                                  text: S.of(context).signIn,
                                  style: TextStyle(color: Constants.blue, fontWeight: FontWeight.bold, fontSize: 13),
                                  recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).popUntil((route) => route.settings.name == RouteList.login),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // final _auth = firebase_auth.FirebaseAuth.instance;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController _emailController = TextEditingController();

//   String? firstName, lastName, emailAddress, phoneNumber, password;
//   bool? isVendor = false;
//   bool isChecked = false;

//   final bool showPhoneNumberWhenRegister =
//       kLoginSetting['showPhoneNumberWhenRegister'] ?? false;
//   final bool requirePhoneNumberWhenRegister =
//       kLoginSetting['requirePhoneNumberWhenRegister'] ?? false;

//   final firstNameNode = FocusNode();
//   final lastNameNode = FocusNode();
//   final phoneNumberNode = FocusNode();
//   final emailNode = FocusNode();
//   final passwordNode = FocusNode();

//   void _welcomeDiaLog(User user) {
//     Provider.of<CartModel>(context, listen: false).setUser(user);
//     Provider.of<PointModel>(context, listen: false).getMyPoint(user.cookie);
//     final model = Provider.of<UserModel>(context, listen: false);

//     /// Show VendorOnBoarding.
//     if (kVendorConfig['VendorRegister'] == true &&
//         Provider.of<AppModel>(context, listen: false).vendorType ==
//             VendorType.multi &&
//         user.isVender) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (ctx) => VendorOnBoarding(
//             user: user,
//             onFinish: () {
//               model.getUser();
//               var email = user.email;
//               _snackBar(S.of(ctx).welcome + ' $email!');
//               var routeFound = false;
//               var routeNames = [RouteList.dashboard, RouteList.productDetail];
//               Navigator.popUntil(ctx, (route) {
//                 if (routeNames.any((element) =>
//                     route.settings.name?.contains(element) ?? false)) {
//                   routeFound = true;
//                 }
//                 return routeFound || route.isFirst;
//               });

//               if (!routeFound) {
//                 Navigator.of(ctx).pushReplacementNamed(RouteList.dashboard);
//               }
//             },
//           ),
//         ),
//       );
//       return;
//     }

//     var email = user.email;
//     _snackBar(S.of(context).welcome + ' $email!');
//     if (kLoginSetting['IsRequiredLogin'] ?? false) {
//       Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
//       return;
//     }
//     var routeFound = false;
//     var routeNames = [RouteList.dashboard, RouteList.productDetail];
//     Navigator.popUntil(context, (route) {
//       if (routeNames
//           .any((element) => route.settings.name?.contains(element) ?? false)) {
//         routeFound = true;
//       }
//       return routeFound || route.isFirst;
//     });

//     if (!routeFound) {
//       Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     firstNameNode.dispose();
//     lastNameNode.dispose();
//     emailNode.dispose();
//     passwordNode.dispose();
//     phoneNumberNode.dispose();
//     super.dispose();
//   }

//   void _snackBar(String text) {
//     if (mounted) {
//       final snackBar = SnackBar(
//         content: Text(text),
//         duration: const Duration(seconds: 10),
//         action: SnackBarAction(
//           label: S.of(context).close,
//           onPressed: () {
//             // Some code to undo the change.
//           },
//         ),
//       );
//       // ignore: deprecated_member_use
//       _scaffoldKey.currentState!.showSnackBar(snackBar);
//     }
//   }

//   Future<void> _submitRegister({
//     String? firstName,
//     String? lastName,
//     String? phoneNumber,
//     String? emailAddress,
//     String? password,
//     bool? isVendor,
//   }) async {
//     if (firstName == null ||
//         lastName == null ||
//         emailAddress == null ||
//         password == null ||
//         (showPhoneNumberWhenRegister &&
//             requirePhoneNumberWhenRegister &&
//             phoneNumber == null)) {
//       _snackBar(S.of(context).pleaseInputFillAllFields);
//     } else if (isChecked == false) {
//       _snackBar(S.of(context).pleaseAgreeTerms);
//     } else {
//       final emailValid = RegExp(
//           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

//       if (!emailValid.hasMatch(emailAddress)) {
//         _snackBar(S.of(context).errorEmailFormat);
//         return;
//       }

//       if (password.length < 8) {
//         _snackBar(S.of(context).errorPasswordFormat);
//         return;
//       }

//       await Provider.of<UserModel>(context, listen: false).createUser(
//         username: emailAddress,
//         password: password,
//         firstName: firstName,
//         lastName: lastName,
//         phoneNumber: phoneNumber,
//         success: _welcomeDiaLog,
//         fail: _snackBar,
//         isVendor: isVendor,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appModel = Provider.of<AppModel>(context, listen: true);
//     final themeConfig = appModel.themeConfig;

//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Theme.of(context).backgroundColor,
//       appBar: AppBar(
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//         backgroundColor: Theme.of(context).backgroundColor,
//         elevation: 0.0,
//       ),
//       body: SafeArea(
//         child: GestureDetector(
//           onTap: () => Tools.hideKeyboard(context),
//           child: ListenableProvider.value(
//             value: Provider.of<UserModel>(context),
//             child: Consumer<UserModel>(
//               builder: (context, value, child) {
//                 return SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                     child: AutofillGroup(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: <Widget>[
//                           const SizedBox(height: 10.0),
//                           Center(
//                             child: FluxImage(
//                               imageUrl: themeConfig.logo,
//                               width: MediaQuery.of(context).size.width / 2,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 30.0,
//                           ),
//                           CustomTextField(
//                             key: const Key('registerFirstNameField'),
//                             autofillHints: const [AutofillHints.givenName],
//                             onChanged: (value) => firstName = value,
//                             textCapitalization: TextCapitalization.words,
//                             nextNode: lastNameNode,
//                             showCancelIcon: true,
//                             decoration: InputDecoration(
//                               labelText: S.of(context).firstName,
//                               hintText: S.of(context).enterYourFirstName,
//                             ),
//                           ),
//                           const SizedBox(height: 20.0),
//                           CustomTextField(
//                             key: const Key('registerLastNameField'),
//                             autofillHints: const [AutofillHints.familyName],
//                             focusNode: lastNameNode,
//                             nextNode: showPhoneNumberWhenRegister
//                                 ? phoneNumberNode
//                                 : emailNode,
//                             showCancelIcon: true,
//                             textCapitalization: TextCapitalization.words,
//                             onChanged: (value) => lastName = value,
//                             decoration: InputDecoration(
//                               labelText: S.of(context).lastName,
//                               hintText: S.of(context).enterYourLastName,
//                             ),
//                           ),
//                           if (showPhoneNumberWhenRegister)
//                             const SizedBox(height: 20.0),
//                           if (showPhoneNumberWhenRegister)
//                             CustomTextField(
//                               key: const Key('registerPhoneField'),
//                               focusNode: phoneNumberNode,
//                               autofillHints: const [
//                                 AutofillHints.telephoneNumber
//                               ],
//                               nextNode: emailNode,
//                               showCancelIcon: true,
//                               onChanged: (value) => phoneNumber = value,
//                               decoration: InputDecoration(
//                                 labelText: S.of(context).phone,
//                                 hintText: S.of(context).enterYourPhoneNumber,
//                               ),
//                               keyboardType: TextInputType.phone,
//                             ),
//                           const SizedBox(height: 20.0),
//                           CustomTextField(
//                             key: const Key('registerEmailField'),
//                             focusNode: emailNode,
//                             autofillHints: const [AutofillHints.email],
//                             nextNode: passwordNode,
//                             controller: _emailController,
//                             onChanged: (value) => emailAddress = value,
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: InputDecoration(
//                                 labelText: S.of(context).enterYourEmail),
//                             hintText: S.of(context).enterYourEmail,
//                           ),
//                           const SizedBox(height: 20.0),
//                           CustomTextField(
//                             key: const Key('registerPasswordField'),
//                             focusNode: passwordNode,
//                             autofillHints: const [AutofillHints.password],
//                             showEyeIcon: true,
//                             obscureText: true,
//                             onChanged: (value) => password = value,
//                             decoration: InputDecoration(
//                               labelText: S.of(context).enterYourPassword,
//                               hintText: S.of(context).enterYourPassword,
//                             ),
//                           ),
//                           const SizedBox(height: 20.0),
//                           if (kVendorConfig['VendorRegister'] == true &&
//                               Provider.of<AppModel>(context, listen: false)
//                                       .vendorType ==
//                                   VendorType.multi)
//                             Row(
//                               children: <Widget>[
//                                 Checkbox(
//                                   value: isVendor,
//                                   activeColor: Theme.of(context).primaryColor,
//                                   checkColor: Colors.white,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       isVendor = value;
//                                     });
//                                   },
//                                 ),
//                                 Expanded(
//                                   child: InkWell(
//                                     onTap: () {
//                                       isVendor = !isVendor!;
//                                       setState(() {});
//                                     },
//                                     child: Text(
//                                       S.of(context).registerAsVendor,
//                                       maxLines: 2,
//                                       style:
//                                           Theme.of(context).textTheme.bodyText1,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           Row(
//                             children: <Widget>[
//                               Checkbox(
//                                 key: const Key('registerConfirmCheckbox'),
//                                 value: isChecked,
//                                 activeColor: Theme.of(context).primaryColor,
//                                 checkColor: Colors.white,
//                                 onChanged: (value) {
//                                   isChecked = !isChecked;
//                                   setState(() {});
//                                 },
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   isChecked = !isChecked;
//                                   setState(() {});
//                                 },
//                                 child: Text(
//                                   S.of(context).iwantToCreateAccount,
//                                   style: Theme.of(context).textTheme.bodyText1,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           InkWell(
//                             onTap: () {
//                               isChecked = !isChecked;
//                               setState(() {});
//                             },
//                             child: Row(
//                               children: <Widget>[
//                                 Checkbox(
//                                   value: isChecked,
//                                   activeColor: Theme.of(context).primaryColor,
//                                   checkColor: Colors.white,
//                                   onChanged: (value) {
//                                     isChecked = !isChecked;
//                                     setState(() {});
//                                   },
//                                 ),
//                                 Expanded(
//                                   child: RichText(
//                                     maxLines: 2,
//                                     text: TextSpan(
//                                       text: S.of(context).iAgree,
//                                       style:
//                                           Theme.of(context).textTheme.bodyText1,
//                                       children: <TextSpan>[
//                                         const TextSpan(text: ' '),
//                                         TextSpan(
//                                           text: S.of(context).agreeWithPrivacy,
//                                           style: TextStyle(
//                                               color: Theme.of(context)
//                                                   .primaryColor,
//                                               decoration:
//                                                   TextDecoration.underline),
//                                           recognizer: TapGestureRecognizer()
//                                             ..onTap = () => Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         PrivacyScreen(),
//                                                   ),
//                                                 ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 10.0),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 16.0),
//                             child: Material(
//                               color: Theme.of(context).primaryColor,
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(5.0)),
//                               elevation: 0,
//                               child: MaterialButton(
//                                 key: const Key('registerSubmitButton'),
//                                 onPressed: value.loading == true
//                                     ? null
//                                     : () async {
//                                         await _submitRegister(
//                                           firstName: firstName,
//                                           lastName: lastName,
//                                           phoneNumber: phoneNumber,
//                                           emailAddress: emailAddress,
//                                           password: password,
//                                           isVendor: isVendor,
//                                         );
//                                       },
//                                 minWidth: 200.0,
//                                 elevation: 0.0,
//                                 height: 42.0,
//                                 child: Text(
//                                   value.loading == true
//                                       ? S.of(context).loading
//                                       : S.of(context).createAnAccount,
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(
//                                   S.of(context).or + ' ',
//                                   style: const TextStyle(color: Colors.black45),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     final canPop =
//                                         ModalRoute.of(context)!.canPop;
//                                     if (canPop) {
//                                       Navigator.pop(context);
//                                     } else {
//                                       Navigator.of(context)
//                                           .pushReplacementNamed(
//                                               RouteList.login);
//                                     }
//                                   },
//                                   child: Text(
//                                     S.of(context).loginToYourAccount,
//                                     style: TextStyle(
//                                       color: Theme.of(context).primaryColor,
//                                       decoration: TextDecoration.underline,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PrivacyScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//         title: Text(
//           S.of(context).agreeWithPrivacy,
//           style: const TextStyle(
//             fontSize: 16.0,
//             color: Colors.white,
//           ),
//         ),
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Text(
//             S.of(context).privacyTerms,
//             style: const TextStyle(fontSize: 16.0, height: 1.4),
//             textAlign: TextAlign.justify,
//           ),
//         ),
//       ),
//     );
//   }
}
