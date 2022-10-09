import 'package:get/get.dart';
import 'package:swiftlink/models/user_model.dart';
import 'package:swiftlink/models/service_model.dart';
import 'package:swiftlink/models/user_contact.dart';
import 'package:swiftlink/models/user_prefrence.dart';
import 'package:swiftlink/services/firebase_helper.dart';

class BaseFirebaseServices {
  static Future<Map<String, dynamic>?> firebaseSubmitPhoneNumberCode({
    required String code,
    required String phoneNumber,
  }) async {
    Map<String, dynamic> response = await FireStoreUtils.firebaseSubmitPhoneNumberCode(
      code: code,
      phoneNumber: phoneNumber,
    );
    return checkAuthResponse(response);
  }

  static Future<bool?> checkIfUserNameAvailable({
    required String userName,
  }) async {
    Map<String, dynamic> response = await FireStoreUtils.checkIfUserNameAvailable(
      userName,
    );
    return checkResponse(response);
  }

  static Future<User?> createNewUser({required User user}) async {
    Map<String, dynamic> response = await FireStoreUtils.createNewAccount(
      user,
    );
    return checkAuthResponse(response);
  }

  static Future<User?> signUpOrInWithFacebook() async {
    Map<String, dynamic> response = await FireStoreUtils.loginWithFacebook();
    return checkResponse(response);
  }

  static Future<User?> signUpOrInWithGoogle() async {
    Map<String, dynamic> response = await FireStoreUtils.loginWithGoogle();
    return checkResponse(response);
  }

  static Future<UserContact?> userContact({
    required UserContact userContact,
    required String userId,
  }) async {
    Map<String, dynamic> response = await FireStoreUtils.addUserContact(
      userContact,
      userId,
    );
    return checkResponse(response);
  }

  static Future<User?> getCurrentUser({required String userId}) async {
    Map<String, dynamic> response = await FireStoreUtils.getCurrentUser(
      userId,
    );
    return checkAuthResponse(response);
  }

  static Future<List<ServiceModel>> getService(String systemId) async {
    Map<String, dynamic> response = await FireStoreUtils.getService(systemId);
    return checkResponse(response);
  }

  static Future<UserPrefrence>? getSelectedService(String userName) async {
    Map<String, dynamic> response = await FireStoreUtils.getSelectedService(userName);
    return checkResponse(response);
  }

  static Future<UserPrefrence>? setServiceList(UserPrefrence userPrefrence, String userId) async {
    Map<String, dynamic> response = await FireStoreUtils.setServiceList(userPrefrence, userId);
    return checkResponse(response);
  }

  static Future<bool>? isServiceAdded(String userName) async {
    Map<String, dynamic> response = await FireStoreUtils.ifServiceAdded(userName);
    return checkResponse(response);
  }

  static Future<bool>? signOut() async {
    Map<String, dynamic> response = await FireStoreUtils.signOut();
    return checkAuthResponse(response);
  }

  // static Future<User?> loginFirebaseEmail({
  //   required String email,
  //   required String password,
  // }) async {
  //   Map<String, dynamic> response = await FireStoreUtils.loginWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //   return checkResponse(response);
  // }

  static checkResponse(Map<String, dynamic> response) {
    if (response['errorMessage'] == null) {
      if (response['successMessage'] != null) {
        showSuccess(
          title: 'Success',
          sucessMessage: response['successMessage'],
        );
      }
      return response['data'];
    } else {
      showError(
        title: 'Error',
        errorMessage: response['errorMessage'],
      );
      return null;
    }
  }

  static checkAuthResponse(Map<String, dynamic> response) {
    if (response['data'] != null || response['successMessage'] != null) {
      if (response['successMessage'] != null) {
        showSuccess(
          title: 'Success',
          sucessMessage: response['successMessage'],
        );
      }
      return response['data'];
    } else {
      if (response['errorMessage'] != null) {
        showError(
          title: 'Error',
          errorMessage: getErrorMessage(
            response['errorMessage'],
          ),
        );
      }
      return null;
    }
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

  static void showError({
    required String title,
    required String errorMessage,
  }) {
    Get.snackbar(title, errorMessage);
  }

  static void showSuccess({
    required String title,
    required String sucessMessage,
  }) {
    Get.snackbar(title, sucessMessage);
  }
}
