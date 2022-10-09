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
import 'package:swiftlink/services/base_firebase_services.dart';

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
        return {
          'data': {
            'statusCode': '300',
            'user': user,
            'id': userCredential.user?.uid,
          },
          'successMessage': null,
          'errorMessage': null,
        };
      } else if (user == null) {
        return {
          'data': {
            'statusCode': '200',
            'id': userCredential.user?.uid,
          },
          'successMessage': null,
          'errorMessage': null,
        };
      } else {
        return {
          'data': null,
          'successMessage': null,
          'errorMessage': 'Create new user with phone number.',
        };
      }
    } on auth.FirebaseAuthException catch (e) {
      return {
        'data': null,
        'successMessage': null,
        'errorMessage': e.code,
      };
    }
  }

  static Future<Map<String, dynamic>> checkIfUserNameAvailable(String userName) async {
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
      return {
        'data': true,
        'successMessage': null,
        'errorMessage': null,
      };
    } else {
      return {
        'data': false,
        'successMessage': null,
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
          'successMessage': null,
          'errorMessage': null,
        };
      });
    } on auth.FirebaseException catch (e) {
      debugPrint('Error User Created : ${e.message}');
      return {
        'data': null,
        'successMessage': null,
        'errorMessage': e.code,
      };
    }
  }

  static Future<Map<String, dynamic>> getCurrentUser(String uid) async {
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
        return {
          'data': users.first,
          'successMessage': null,
          'errorMessage': null,
        };
      } else {
        return {
          'data': null,
          'successMessage': null,
          'errorMessage': null,
        };
      }
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Get Current User : ${e.message}');
      return {
        'data': null,
        'successMessage': null,
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
          'successMessage': null,
          'errorMessage': null,
        };
      });
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Add User Contact : ${e.message}');
      return {
        'data': null,
        'successMessage': null,
        'errorMessage': e.message,
      };
    }
  }

  static Future<Map<String, dynamic>> getService(String systemId) async {
    try {
      QuerySnapshot serviceCollection = await firestore
          .collection(FirebaseTable.service)
          .where(
            'system_id',
            isEqualTo: systemId,
          )
          .get();
      return {
        'data': serviceCollection.docs.map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>)).toList(),
        'successMessage': null,
        'errorMessage': null,
      };
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Get Service : ${e.message}');
      return {
        'data': null,
        'successMessage': null,
        'errorMessage': e.message,
      };
    }
  }

  static Future<Map<String, dynamic>> getSelectedService(String userName) async {
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
      return {
        'data': userPrefrenceList.isNotEmpty
            ? userPrefrenceList.first
            : UserPrefrence(
                serviceCategory: null,
                systemId: null,
                userName: null,
              ),
        'successMessage': null,
        'errorMessage': null,
      };
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Get Service : ${e.message}');
      return {
        'data': null,
        'successMessage': null,
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
          'successMessage': null,
          'errorMessage': null,
        };
      });
    } on auth.FirebaseException catch (e) {
      debugPrint('Error Add User Prefrence : ${e.message}');
      return {
        'data': null,
        'successMessage': null,
        'errorMessage': e.message,
      };
    }
  }

  static Future<Map<String, dynamic>> ifServiceAdded(String userName) async {
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
      return {
        'data': true,
        'successMessage': null,
        'errorMessage': null,
      };
    } else {
      return {
        'data': false,
        'successMessage': null,
        'errorMessage': null,
      };
    }
  }

  static Future<Map<String, dynamic>> signOut() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
      getStorage.erase();
      return {
        'data': true,
        'successMessage': null,
        'errorMessage': null,
      };
    } on auth.FirebaseAuthException catch (e) {
      debugPrint('Error Add User Prefrence : ${e.message}');
      return {
        'data': false,
        'successMessage': null,
        'errorMessage': e.message,
      };
    }
  }

  static Future<Map<String, dynamic>> loginWithFacebook() async {
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
        return {
          'data': null,
          'successMessage': null,
          'errorMessage': 'Facebook authentication failed, Please try again',
        };
      }
    } else {
      AccessToken? token = await facebookAuth.accessToken;
      return await handleFacebookLogin(await facebookAuth.getUserData(), token!);
    }
  }

  static Future<Map<String, dynamic>> handleFacebookLogin(Map<String, dynamic> userData, AccessToken token) async {
    try {
      auth.UserCredential authResult = await auth.FirebaseAuth.instance.signInWithCredential(auth.FacebookAuthProvider.credential(token.token));
      User? user = await BaseFirebaseServices.getCurrentUser(userId: authResult.user?.uid ?? '');

      if (user != null) {
        user.jwtToken = await firebaseMessaging.getToken();
        user.picture = authResult.user?.photoURL;
        user.systemId = getStorage.read(LocalStorageKey.systemId);
        return {
          'data': user,
          'successMessage': null,
          'errorMessage': null,
        };
      } else {
        user = User(
          id: authResult.user?.uid,
          email: userData['email'],
          picture: userData['picture']['data']['url'],
          systemId: getStorage.read(LocalStorageKey.systemId),
          jwtToken: await firebaseMessaging.getToken(),
        );
        User? result = await BaseFirebaseServices.createNewUser(user: user);
        if (result != null) {
          return {
            'data': user,
            'successMessage': null,
            'errorMessage': null,
          };
        } else {
          return {
            'data': null,
            'successMessage': null,
            'errorMessage': 'Facebook authentication failed, Please try again',
          };
        }
      }
    } catch (e) {
      return {
        'data': null,
        'successMessage': null,
        'errorMessage': 'Facebook authentication failed, Please try again',
      };
    }
  }

  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      auth.UserCredential authResult = await auth.FirebaseAuth.instance.signInWithCredential(credential);
      User? user = await BaseFirebaseServices.getCurrentUser(userId: authResult.user?.uid ?? '');
      if (user != null) {
        user.jwtToken = await firebaseMessaging.getToken();
        user.picture = authResult.user?.photoURL;
        user.systemId = getStorage.read(LocalStorageKey.systemId);
        return {
          'data': user,
          'successMessage': null,
          'errorMessage': null,
        };
      } else {
        String? jwtToken = await firebaseMessaging.getToken();
        user = User(
          id: authResult.user?.uid,
          email: authResult.user?.email,
          picture: authResult.user?.photoURL,
          systemId: getStorage.read(LocalStorageKey.systemId),
          jwtToken: jwtToken,
        );
        User? result = await BaseFirebaseServices.createNewUser(user: user);
        if (result != null) {
          return {
            'data': result,
            'successMessage': null,
            'errorMessage': null,
          };
        } else {
          return {
            'data': null,
            'successMessage': null,
            'errorMessage': 'Google authentication failed, Please try again',
          };
        }
      }
    } on auth.FirebaseAuthException catch (_) {
      return {
        'data': null,
        'successMessage': null,
        'errorMessage': _.message,
      };
    } catch (e) {
      return {
        'data': null,
        'successMessage': null,
        'errorMessage': 'Google authentication failed, Please try again',
      };
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
