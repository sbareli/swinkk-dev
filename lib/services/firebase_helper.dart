import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swiftlink/common/constants/firebase_table_name.dart';
import 'package:swiftlink/common/constants/local_storage_key.dart';
import 'package:swiftlink/models/service_model.dart';
import 'package:swiftlink/models/user_contact.dart';
import 'package:swiftlink/models/user_prefrence.dart';

import '../models/user_model.dart';

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static RxString smsVerificationId = ''.obs;
  static GetStorage getStorage = GetStorage();

  static Future<void> getSystem() async {
    QuerySnapshot<Map<String, dynamic>> systemDocument = await firestore.collection('System').where('active', isEqualTo: true).get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> element in systemDocument.docs) {
      Map<String, dynamic> system = element.data();
      getStorage.write(LocalStorageKey.systemId, system['system_id']);
    }
    debugPrint(getStorage.read(LocalStorageKey.systemId));
  }

  static Future<User?> signUpUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      await auth.FirebaseAuth.instance.currentUser!.updateEmail(email);

      return User(
        email: email,
        id: userCredential.user?.uid ?? '',
        systemId: getStorage.read(LocalStorageKey.systemId),
      );
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showError(title: 'Error', errorMessage: 'Password Provided is too weak');
        return null;
      } else if (e.code == 'email-already-in-use') {
        showError(title: 'Error', errorMessage: 'Email Provided already Exists');
        return null;
      } else {
        showError(title: 'Error', errorMessage: 'Failed to create account');
        return null;
      }
    } catch (e) {
      showError(title: 'Error', errorMessage: e.toString());
      return null;
    }
  }

  static Future<User?> signInUser({required String email, required String password, required BuildContext context}) async {
    try {
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      User? user = await FireStoreUtils.getCurrentUser(uid: userCredential.user?.uid ?? '');
      if (user != null) {
        return user;
      } else {
        showError(title: 'Error', errorMessage: 'Something went wrong');
        return null;
      }
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showError(title: 'Error', errorMessage: 'No user Found with this Email');
        return null;
      } else if (e.code == 'wrong-password') {
        showError(title: 'Error', errorMessage: 'Password did not match');
        return null;
      } else {
        showError(title: 'Error', errorMessage: e.toString());
        return null;
      }
    }
  }

  static Future<bool> resetPasswordLink({required String email, required BuildContext context}) async {
    try {
      await auth.FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      showSuccess(title: 'Sent link', sucessMessage: 'Password reset link sent! check your email');
      return true;
    } on auth.FirebaseAuthException catch (e) {
      showError(title: e.code, errorMessage: e.message.toString());
      return false;
    }
  }

  static Future<Map<String, dynamic>?> firebaseSubmitPhoneNumberCode({
    required String code,
    required String phoneNumber,
    String firstName = 'Anonymous',
    String lastName = FirebaseTable.user,
  }) async {
    try {
      auth.AuthCredential authCredential = auth.PhoneAuthProvider.credential(
        verificationId: FireStoreUtils.smsVerificationId.toString(),
        smsCode: code,
      );
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance.signInWithCredential(authCredential);
      User? user = await FireStoreUtils.getCurrentUser(uid: userCredential.user?.uid ?? '');

      if (user != null) {
        user.jwtToken = await firebaseMessaging.getToken() ?? '';
        return {
          'data': {
            'statusCode': '300',
            'user': user,
            'id': userCredential.user?.uid,
          },
        };
      } else if (user == null) {
        return {
          'data': {
            'statusCode': '200',
            'id': userCredential.user?.uid,
          },
        };
      } else {
        showError(title: 'Error', errorMessage: 'Create new user with phone number.');
        return null;
      }
    } on auth.FirebaseAuthException catch (e) {
      showError(title: e.code, errorMessage: e.message.toString());
      return null;
    }
  }

  static Future<bool> checkIfUserNameAvailable({required String userName}) async {
    QuerySnapshot<Map<String, dynamic>> userDocument = await firestore
        .collection(FirebaseTable.user)
        .where(
          'user_name',
          isEqualTo: userName,
        )
        .where(
          'system_id',
          isEqualTo: getStorage.read(LocalStorageKey.systemId),
        )
        .get();
    debugPrint(userDocument.docs.isEmpty.toString() + ' USERNAME AVAILABLE');
    if (userDocument.docs.isEmpty) {
      return true;
    } else {
      showError(
        title: 'Error',
        errorMessage: 'This user name already taken !!',
      );
      return false;
    }
  }

  static Future<User?> createNewAccount({required User user}) async {
    try {
      return await firestore.collection(FirebaseTable.user).doc(user.id).set(user.toJson()).then((document) {
        debugPrint('User Created : ${user.id}');
        return user;
      });
    } on auth.FirebaseException catch (e) {
      debugPrint('Error User Created : ${e.message}');
      showError(title: e.code, errorMessage: e.message.toString());
      return null;
    }
  }

  static Future<User?> getCurrentUser({required String uid}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userDocument = await firestore
          .collection(FirebaseTable.user)
          .where(
            'system_id',
            isEqualTo: getStorage.read(LocalStorageKey.systemId),
          )
          .where(
            'id',
            isEqualTo: uid,
          )
          .get();
      List<User> users = userDocument.docs.map((doc) => User.fromJson(doc.data())).toList();
      if (users.isNotEmpty) {
        debugPrint('Current User  : ${users.first.id}');
        return users.first;
      } else {
        showError(
          title: 'Error',
          errorMessage: 'Some thing went wrong',
        );
        return null;
      }
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Get Current User : ${e.message}');
      showError(title: 'Error', errorMessage: e.message.toString());
      return null;
    }
  }

  static Future<UserContact?> addUserContact({required UserContact userContact, required String userId}) async {
    try {
      return await firestore.collection(FirebaseTable.userContact).doc(userId).set(userContact.toJson()).then((document) {
        debugPrint('Add User Contact : $userContact');
        return userContact;
      });
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Add User Contact : ${e.message}');
      showError(title: 'Error', errorMessage: e.message.toString());
      return null;
    }
  }

  static Future<List<ServiceModel>> getService(String systemId) async {
    try {
      QuerySnapshot serviceCollection = await firestore
          .collection(FirebaseTable.service)
          .where(
            'system_id',
            isEqualTo: systemId,
          )
          .get();
      return serviceCollection.docs.map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Get Service : ${e.message}');
      showError(title: 'Error', errorMessage: e.message.toString());
      return [];
    }
  }

  static Future<UserPrefrence?> getSelectedService(String userName) async {
    try {
      QuerySnapshot userPrefrence = await firestore
          .collection(FirebaseTable.userPreferences)
          .where(
            'system_id',
            isEqualTo: getStorage.read(LocalStorageKey.systemId),
          )
          .where(
            'user_name',
            isEqualTo: userName,
          )
          .get();
      List<UserPrefrence> userPrefrenceList = userPrefrence.docs.map((doc) => UserPrefrence.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return userPrefrenceList.isNotEmpty
          ? userPrefrenceList.first
          : UserPrefrence(
              serviceCategory: null,
              systemId: null,
              userName: null,
            );
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Get Service : ${e.message}');
      showError(title: 'Error', errorMessage: e.message.toString());
      return null;
    }
  }

  static Future<UserPrefrence?> setServiceList(UserPrefrence userPrefrence, String userId) async {
    try {
      return await firestore.collection(FirebaseTable.userPreferences).doc(userId).set(userPrefrence.toJson()).then((document) {
        debugPrint('Add User Prefrence : $userPrefrence');
        return userPrefrence;
      });
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Add User Prefrence : ${e.message}');
      showError(title: 'Error', errorMessage: e.message.toString());
      return null;
    }
  }

  static Future<bool> ifServiceAdded(String userName) async {
    QuerySnapshot<Map<String, dynamic>> userDocument = await firestore
        .collection(FirebaseTable.userPreferences)
        .where(
          'user_name',
          isEqualTo: userName,
        )
        .where(
          'system_id',
          isEqualTo: getStorage.read(LocalStorageKey.systemId),
        )
        .get();
    debugPrint(userDocument.docs.isEmpty.toString() + 'Service Not Added');
    if (userDocument.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> signOut() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
      getStorage.erase();
      return true;
    } on auth.FirebaseAuthException catch (e) {
      debugPrint('Error Add User Prefrence : ${e.message}');
      showError(title: 'title', errorMessage: e.message.toString());
      return false;
    }
  }

  static Future<User?> loginWithFacebook() async {
    FacebookAuth facebookAuth = FacebookAuth.instance;
    bool isLogged = await facebookAuth.accessToken != null;
    if (!isLogged) {
      LoginResult result = await facebookAuth.login(
        permissions: [
          'public_profile',
          'email',
          'pages_show_list',
          'pages_messaging',
          'pages_manage_metadata'
        ],
      );
      if (result.status == LoginStatus.success) {
        AccessToken? token = await facebookAuth.accessToken;
        return await handleFacebookLogin(await facebookAuth.getUserData(), token!);
      } else {
        showError(title: 'Error', errorMessage: 'Facebook authentication failed, Please try again');
        return null;
      }
    } else {
      AccessToken? token = await facebookAuth.accessToken;
      return await handleFacebookLogin(await facebookAuth.getUserData(), token!);
    }
  }

  static Future<User?> handleFacebookLogin(Map<String, dynamic> userData, AccessToken token) async {
    try {
      auth.UserCredential authResult = await auth.FirebaseAuth.instance.signInWithCredential(auth.FacebookAuthProvider.credential(token.token));
      User? user = await FireStoreUtils.getCurrentUser(uid: authResult.user?.uid ?? '');

      if (user != null) {
        user.jwtToken = await firebaseMessaging.getToken();
        user.picture = authResult.user?.photoURL;
        user.systemId = getStorage.read(LocalStorageKey.systemId);
        return user;
      } else {
        user = User(
          id: authResult.user?.uid,
          email: userData['email'],
          picture: userData['picture']['data']['url'],
          systemId: getStorage.read(LocalStorageKey.systemId),
          jwtToken: await firebaseMessaging.getToken(),
        );
        User? result = await FireStoreUtils.createNewAccount(user: user);
        if (result != null) {
          return user;
        } else {
          showError(title: 'Error', errorMessage: 'Facebook authentication failed, Please try again');
          return null;
        }
      }
    } on auth.FirebaseAuthException catch (e) {
      debugPrint('Error Add User Prefrence : ${e.message}');
      showError(title: e.code, errorMessage: e.message.toString());
      return null;
    } catch (e) {
      showError(title: 'Error', errorMessage: 'Facebook authentication failed, Please try again');
      return null;
    }
  }

  static Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      auth.UserCredential authResult = await auth.FirebaseAuth.instance.signInWithCredential(credential);
      User? user = await FireStoreUtils.getCurrentUser(uid: authResult.user?.uid ?? '');
      if (user != null) {
        user.jwtToken = await firebaseMessaging.getToken();
        user.picture = authResult.user?.photoURL;
        user.systemId = getStorage.read(LocalStorageKey.systemId);
        return user;
      } else {
        String? jwtToken = await firebaseMessaging.getToken();
        user = User(
          id: authResult.user?.uid,
          email: authResult.user?.email,
          picture: authResult.user?.photoURL,
          systemId: getStorage.read(LocalStorageKey.systemId),
          jwtToken: jwtToken,
        );
        User? result = await FireStoreUtils.createNewAccount(user: user);
        if (result != null) {
          return result;
        } else {
          showError(title: 'Error', errorMessage: 'Google authentication failed, Please try again');
          return null;
        }
      }
    } on auth.FirebaseAuthException catch (e) {
      showError(title: e.code, errorMessage: e.message.toString());
      return null;
    } catch (e) {
      showError(title: 'Error', errorMessage: 'Google authentication failed, Please try again');
      return null;
    }
  }

  static Future<void> signupWithMobileNumber({
    required String phoneNumber,
  }) async {
    await FireStoreUtils.firebaseSubmitPhoneNumber(
      phoneNumber,
      (String verificationId) {},
      (String? verificationId, int? forceResendingToken) {
        smsVerificationId.value = verificationId.toString();
      },
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
        Get.snackbar('Error', message);
      },
      (auth.PhoneAuthCredential credential) async {
        auth.UserCredential userCredential = await auth.FirebaseAuth.instance.signInWithCredential(credential);
        User? user = await FireStoreUtils.getCurrentUser(uid: userCredential.user?.uid ?? '');
        if (user != null) {
          log(user.firstName.toString());
        } else {}
      },
    );
  }

  static firebaseSubmitPhoneNumber(
    String phoneNumber,
    auth.PhoneCodeAutoRetrievalTimeout? phoneCodeAutoRetrievalTimeout,
    auth.PhoneCodeSent? phoneCodeSent,
    auth.PhoneVerificationFailed? phoneVerificationFailed,
    auth.PhoneVerificationCompleted? phoneVerificationCompleted,
  ) {
    auth.FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(minutes: 2),
      phoneNumber: phoneNumber,
      verificationCompleted: phoneVerificationCompleted!,
      verificationFailed: phoneVerificationFailed!,
      codeSent: phoneCodeSent!,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout!,
    );
  }

  static void showSuccess({
    required String title,
    required String sucessMessage,
  }) {
    Get.snackbar(
      title,
      sucessMessage,
      margin: const EdgeInsets.all(15),
      backgroundColor: Colors.greenAccent.withOpacity(0.5),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showError({
    required String title,
    required String errorMessage,
  }) {
    Get.snackbar(
      title,
      errorMessage,
      backgroundColor: Colors.redAccent.withOpacity(0.5),
      margin: const EdgeInsets.all(15),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static String getErrorMessage(String exceptionCode) {
    switch (exceptionCode) {
      case 'invalid-email':
        return 'Email address is malformed.';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'wrong-password':
        return 'Wrong password.';
      case 'user-not-found':
        return 'No user corresponding to the given email address.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts to sign in as this user.';
    }
    return 'Unexpected firebase error, Please try again.';
  }
}
