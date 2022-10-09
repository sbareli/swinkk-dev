import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/screens/authentication/controller/auth_bindings.dart';
import 'package:swiftlink/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:swiftlink/services/base_firebase_services.dart';
import 'package:swiftlink/services/firebase_helper.dart';

class HomeScreen extends GetView {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen'),
            ElevatedButton(
              onPressed: () async {
                await signOutOntap();
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOutOntap() async {
    bool? isSignOut = await BaseFirebaseServices.signOut();
    await FireStoreUtils.getSystem();
    if (isSignOut == true) {
      Get.offAll(
        () => SignInScreen(),
        binding: AuthBinding(),
      );
    }
  }
}
