import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:swiftlink/common/constants/firebase_table_name.dart';
import 'package:swiftlink/common/constants/local_storage_key.dart';
import 'package:swiftlink/models/service.dart';
import 'package:swiftlink/models/user_contact.dart';
import 'package:swiftlink/models/user_prefrence.dart';
import 'package:swiftlink/services/base_firebase_services.dart';

import '../models/entities/user.dart';

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

  static Future<Map<String, dynamic>> firebaseSubmitPhoneNumberCode({
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
      User? user = await BaseFirebaseServices.getCurrentUser(userId: userCredential.user?.uid ?? '');

      if (user != null) {
        user.jwtToken = await firebaseMessaging.getToken() ?? '';
        await createNewAccount(user);
        return {
          'data': {
            'statusCode': '300',
            'id': null,
          },
          'successMessgae': null,
          'errorMessage': null,
        };
      } else if (user == null) {
        return {
          'data': {
            'statusCode': '200',
            'id': userCredential.user?.uid,
          },
          'successMessgae': null,
          'errorMessage': null,
        };
      } else {
        return {
          'data': null,
          'successMessgae': null,
          'errorMessage': 'Create new user with phone number.',
        };
      }
    } on auth.FirebaseAuthException catch (e) {
      return {
        'data': null,
        'successMessgae': null,
        'errorMessage': e.code,
      };
    }
  }

  static Future<Map<String, dynamic>> checkIfUserNameAvailable(String userName) async {
    QuerySnapshot<Map<String, dynamic>> userDocument = await firestore
        .collection(FirebaseTable.user)
        .where(
          userName,
          isEqualTo: userName,
        )
        .get();
    debugPrint(userDocument.docs.isEmpty.toString() + 'USERNAME AVAILABLE');
    if (userDocument.docs.isEmpty) {
      return {
        'data': true,
        'successMessgae': null,
        'errorMessage': null,
      };
    } else {
      return {
        'data': false,
        'successMessgae': null,
        'errorMessage': 'This user name already taken !!',
      };
    }
  }

  static Future<Map<String, dynamic>> createNewAccount(User user) async {
    try {
      return await firestore.collection(FirebaseTable.user).doc(user.id).set(user.toJson()).then((document) {
        debugPrint('User Created : ${user.id}');
        return {
          'data': user,
          'successMessgae': 'Account Created succefully',
          'errorMessage': null,
        };
      });
    } on auth.FirebaseException catch (e) {
      debugPrint('Error User Created : ${e.message}');
      return {
        'data': null,
        'successMessgae': null,
        'errorMessage': e.message,
      };
    }
  }

  static Future<Map<String, dynamic>> getCurrentUser(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDocument = await firestore.collection(FirebaseTable.user).doc(uid).get();
      if (userDocument.data() != null && userDocument.exists) {
        debugPrint('Current User  : ${userDocument.data()}');
        return {
          'data': User.fromJson(userDocument.data()!),
          'successMessgae': 'Account Created succefully',
          'errorMessage': null,
        };
      } else {
        return {
          'data': null,
          'successMessgae': null,
          'errorMessage': 'Something Went Wrong',
        };
      }
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Get Current User : ${e.message}');
      return {
        'data': null,
        'successMessgae': null,
        'errorMessage': e.message,
      };
    }
  }

  static Future<Map<String, dynamic>> addUserContact(UserContact userContact, String id) async {
    try {
      return await firestore.collection(FirebaseTable.userContact).doc(id).set(userContact.toJson()).then((document) {
        debugPrint('Add User Contact : $userContact');
        return {
          'data': userContact,
          'successMessgae': null,
          'errorMessage': null,
        };
      });
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Add User Contact : ${e.message}');
      return {
        'data': null,
        'successMessgae': null,
        'errorMessage': e.message,
      };
    }
  }

  static Future<Map<String, dynamic>> getService() async {
    try {
      QuerySnapshot serviceCollection = await firestore.collection(FirebaseTable.service).get();
      return {
        'data': serviceCollection.docs.map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>)).toList(),
        'successMessgae': null,
        'errorMessage': null,
      };
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Get Service : ${e.message}');
      return {
        'data': null,
        'successMessgae': null,
        'errorMessage': e.message,
      };
    }
  }

  static Future<Map<String, dynamic>> setServiceList(UserPrefrence userPrefrence, String userId) async {
    try {
      return await firestore.collection(FirebaseTable.userPreferences).doc(userId).set(userPrefrence.toJson()).then((document) {
        debugPrint('Add User Prefrence : $userPrefrence');
        return {
          'data': userPrefrence,
          'successMessgae': null,
          'errorMessage': null,
        };
      });
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Add User Prefrence : ${e.message}');
      return {
        'data': null,
        'successMessgae': null,
        'errorMessage': e.message,
      };
    }
  }

  static Future<Map<String, dynamic>> ifServiceAdded(String userName) async {
    QuerySnapshot<Map<String, dynamic>> userDocument = await firestore
        .collection(FirebaseTable.userPreferences)
        .where(
          'userName',
          isEqualTo: userName,
        )
        .get();
    debugPrint(userDocument.docs.isEmpty.toString() + 'Service Not Added');
    if (userDocument.docs.isEmpty) {
      return {
        'data': true,
        'successMessgae': null,
        'errorMessage': null,
      };
    } else {
      return {
        'data': false,
        'successMessgae': null,
        'errorMessage': null,
      };
    }
  }

  // static Future<User?> getService(User user) async {
  //   //UserPreference.setUserId(userID: user.userID);
  //   return await firestore.collection(FirebaseTable.user).doc(user.id).set(user.toJson()).then((document) {
  //     return user;
  //   });
  // }

  static Future<String?> firebaseCreateNewUserWithEmail({required String email, required String password, required String serviceId}) async {
    try {
      auth.FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
        firestore.collection("User").doc(value.user!.uid).set({
          "uid": value.user!.uid,
          'email': email,
          'system_id': serviceId,
        });

        if (value.user != null && !value.user!.emailVerified) {
          await value.user!.sendEmailVerification();
        }

        return value;
      });
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("warrning", "The password provided is too weak.");
        // ignore: avoid_print
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("warrning", "The account already exists for that email.");
        // ignore: avoid_print
        print('The account already exists for that email.');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return null;
  }

  static Future<Map<String, dynamic>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore.collection(FirebaseTable.user).doc(result.user?.uid ?? '').get();
      User? user;
      if (documentSnapshot.exists) {
        user = User.fromJson(documentSnapshot.data() ?? {});
      }
      return {
        'data': user,
        'successMessage': null,
        'errorMessage': null,
      };
    } on auth.FirebaseAuthException catch (exception, _) {
      return {
        'data': null,
        'successMessgae': null,
        'errorMessage': exception.code,
      };
    } catch (e, _) {
      return {
        'data': null,
        'successMessgae': null,
        'errorMessage': 'Login failed, Please try again.',
      };
    }
  }

  static loginWithFacebook() async {
    /// creates a user for this facebook login when this user first time login
    /// and save the new user object to firebase and firebase auth
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
      ); // by default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        // you are logged
        AccessToken? token = await facebookAuth.accessToken;
        return await handleFacebookLogin(await facebookAuth.getUserData(), token!);
      }
    } else {
      AccessToken? token = await facebookAuth.accessToken;
      return await handleFacebookLogin(await facebookAuth.getUserData(), token!);
    }
  }

  static handleFacebookLogin(Map<String, dynamic> userData, AccessToken token) async {
    auth.UserCredential authResult = await auth.FirebaseAuth.instance.signInWithCredential(auth.FacebookAuthProvider.credential(token.token));
    User? user = await BaseFirebaseServices.getCurrentUser(userId: authResult.user?.uid ?? '');
    List<String> fullName = (userData['name'] as String).split(' ');
    String firstName = '';
    String lastName = '';
    if (fullName.isNotEmpty) {
      firstName = fullName.first;
      lastName = fullName.skip(1).join(' ');
    }
    if (user != null) {
      user.picture = userData['picture']['data']['url'];
      user.firstName = firstName;
      user.lastName = lastName;
      user.email = userData['email'];
      //user.active = true;
      user.jwtToken = await firebaseMessaging.getToken() ?? '';
      dynamic result = await createNewAccount(user);
      return result;
    } else if (user == null) {
      user = User(
        email: userData['email'] ?? '',
        firstName: firstName,
        picture: userData['picture']['data']['url'] ?? '',
        id: authResult.user?.uid ?? '',
        lastName: lastName,
        jwtToken: await firebaseMessaging.getToken() ?? '',
      );
      Map<String, dynamic> response = await createNewAccount(user);
      if (response['data'] != null) {
        return user;
      } else {
        return response['errorMessage'];
      }
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
        User? user = await BaseFirebaseServices.getCurrentUser(userId: userCredential.user?.uid ?? '');
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
}
