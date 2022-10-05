import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swiftlink/models/entities/user.dart';
import 'package:swiftlink/services/base_firebase_services.dart';
import 'package:swiftlink/services/firebase_helper.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;

class SigninScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool isAvailableApple = false.obs;
  RxBool isActiveAudio = false.obs;
  auth.User? userdata;
  User? user;
  dynamic respose;

  void passwordVisible() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login(userName, password) async {
    respose = await FireStoreUtils.loginWithEmailAndPassword(email: userName, password: password);
  }

  Future<void> loginWithFacebook() async {
    try {
      dynamic result = await FireStoreUtils.loginWithFacebook();
      if (result != null && result is User) {
        log(result.toString());
      }
    } catch (e, s) {
      debugPrint('_LoginScreen.loginWithFacebook $e $s');
    }
  }

  submitPhoneNumber(String phoneNumber) async {
    await FireStoreUtils.firebaseSubmitPhoneNumber(
      phoneNumber,
      (String verificationId) {
        log(verificationId.toString());
      },
      (String? verificationId, int? forceResendingToken) {},
      (auth.FirebaseAuthException error) {
        String message = 'An error has occurred, please try again.';
        switch (error.code) {
          case 'invalid-verification-code':
            message = 'Invalid code or has been expired.';
            break;
          case 'user-disabled':
            message = 'This user has been disabled.';
            break;
          default:
            message = 'An error has occurred, please try again.';
            break;
        }
      },
      (auth.PhoneAuthCredential credential) async {
        auth.UserCredential userCredential = await auth.FirebaseAuth.instance.signInWithCredential(credential);
        User? user = await BaseFirebaseServices.getCurrentUser(
          userId: userCredential.user?.uid ?? '',
        );
        if (user != null) {
          log(user.toString());
        } else {}
      },
    );
  }

  Future<auth.UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await auth.FirebaseAuth.instance.signInWithCredential(credential).whenComplete(() async => {
          userdata = auth.FirebaseAuth.instance.currentUser,
          log(userdata.toString()),
          GetStorage().write("Uid", userdata!.uid),
          // firestore.collection("users").doc(userdata!.uid).set({
          //   "uid": user!.uid,
          //   "name": user!.displayName,
          //   "age": "0",
          //   "playerID": playerId,
          //   "bio": "Hey, i am using Meetup",
          //   "ProfileImage": user!.photoURL,
          //   "emjois": "😍"
          // }),
          // uid = user!.uid,
          // dataStorage.write("Uid", user!.uid),
          // dataStorage.write("isLogging", true),
          // dataStorage.write("name", user!.displayName),
          // dataStorage.write("image", user!.photoURL),
          // // Get.snackbar(
          // //     "Suceess", "Your account creat succesfully, please login "),
          // Get.offAll(() => const MainHomePage())
        });

    return await auth.FirebaseAuth.instance.signInWithCredential(credential);
  }
}
