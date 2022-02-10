import 'package:flutter/material.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/common/utils/logs.dart';

import '../../generated/l10n.dart';
import '../../services/services.dart';
import 'verify.dart';

class LoginSMSScreen extends StatefulWidget {
  const LoginSMSScreen({Key? key}) : super(key: key);

  @override
  _LoginSMSState createState() => _LoginSMSState();
}

class _LoginSMSState extends State<LoginSMSScreen> {
  final TextEditingController _controller = TextEditingController(text: '');

  String? phoneNumber;
  String? _phone;
  bool isLoading = false;

  late final _verifySuccessStream;

  @override
  void initState() {
    super.initState();
    _verifySuccessStream = Services().firebase.getFirebaseStream();

    _phone = '';

    _controller.addListener(() {
      if (_controller.text != _phone && _controller.text != '') {
        _phone = _controller.text;
        if (_phone!.startsWith('+')) {
          phoneNumber = _phone;
        } else {
          phoneNumber = '+1' + _phone!;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _failMessage(message, context) {
    /// Showing Error messageSnackBarDemo
    /// Ability so close message
    final snackBar = SnackBar(
      content: Text('⚠️: $message'),
      duration: const Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<void> _loginSMS(context) async {
    if (phoneNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).cannotBeEmpty)));
    } else {
      Future autoRetrieve(String verId) {
        printLog('verification id $verId');
        return Future.delayed(const Duration(milliseconds: 100));
      }

      Future smsCodeSent(String verId, [int? forceCodeResend]) {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyCode(
              verId: verId,
              phoneNumber: phoneNumber,
              verifySuccessStream: _verifySuccessStream.stream,
            ),
          ),
        );
      }

      final verifiedSuccess = _verifySuccessStream.add;

      void verifyFailed(exception) {
        _failMessage(exception.message, context);
      }

      Services().firebase.verifyPhoneNumber(
            phoneNumber: phoneNumber!,
            codeAutoRetrievalTimeout: autoRetrieve,
            codeSent: smsCodeSent,
            verificationCompleted: verifiedSuccess,
            verificationFailed: verifyFailed,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/ForgotPassword3.png',
                ),
                fit: BoxFit.cover),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Login via Phone Number',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Enter your phone number to receive OTP',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  const SizedBox(height: 80.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(hintText: S.of(context).phoneNumber),
                          keyboardType: TextInputType.phone,
                          controller: _controller,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      if (!isLoading) {
                        _loginSMS(context);
                      }
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(S.of(context).send),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text.rich(
                    TextSpan(
                      text: S.of(context).back,
                      style: TextStyle(color: Constants.grey01, fontWeight: FontWeight.bold),
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
