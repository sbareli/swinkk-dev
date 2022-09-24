import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swiftlink/common/utils/logs.dart';
import 'package:swiftlink/modules/firebase/firebase_service.dart';
import 'package:swiftlink/services/services.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;
import '../generated/l10n.dart';
import 'entities/user.dart';

abstract class UserModelDelegate {
  void onLoaded(User? user);

  void onLoggedIn(User user);

  void onLogout(User? user);
}

class UserModel with ChangeNotifier {
  UserModel() {
    // getUser();
  }

  // final Services _service = Services();
  User? user;
  bool loggedIn = false;
  bool loading = false;
  UserModelDelegate? delegate;

  /// Login by apple, This function only test on iPhone
  Future<void> loginApple({Function? success, Function? fail, context}) async {
    try {
      final result = await apple.TheAppleSignIn.performRequests([
        const apple.AppleIdRequest(requestedScopes: [
          apple.Scope.email,
          apple.Scope.fullName
        ])
      ]);

      switch (result.status) {
        case apple.AuthorizationStatus.authorized:
          {
            // await Services().firebase.loginFirebaseApple(
            //       authorizationCode: result.credential!.authorizationCode!,
            //       identityToken: result.credential!.identityToken!,
            //     );

            await storeLoginStatus();
            success!();
          }
          break;

        case apple.AuthorizationStatus.error:
          fail!(S.of(context).error(result.error!));
          break;
        case apple.AuthorizationStatus.cancelled:
          fail!(S.of(context).loginCanceled);
          break;
      }
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  /// Login by Firebase phone
  Future<void> loginFirebaseSMS({String? phoneNumber, required Function success, Function? fail, context}) async {
    try {
      await storeLoginStatus();
      success();
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  /// Login by Facebook
  Future<void> loginFB({Function? success, Function? fail, context}) async {
    try {
      final result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final accessToken = await FacebookAuth.instance.accessToken;

          // await Services().firebase.loginFirebaseFacebook(token: accessToken!.token);

          await storeLoginStatus();
          success!();
          break;
        case LoginStatus.cancelled:
          fail!(S.of(context).loginCanceled);
          break;
        default:
          fail!(result.message);
          break;
      }
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  Future<void> loginGoogle({Function? success, Function? fail, context}) async {
    try {
      var _googleSignIn = GoogleSignIn(scopes: [
        'email'
      ]);
      var res = await _googleSignIn.signIn();

      var googleUser = User(username: res?.displayName.toString(), firstName: res?.displayName.toString(), lastName: res?.displayName.toString(), location: '');
      FirebaseServices().saveUserToFirestore(user: googleUser);

      if (res == null) {
        fail!(S.of(context).loginCanceled);
      } else {
        var auth = await res.authentication;
        // await Services().firebase.loginFirebaseGoogle(token: auth.accessToken);
        await storeLoginStatus();
        success!();
      }
    } catch (err, trace) {
      printLog(trace);
      printLog(err);
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  Future<void> saveUser(User? user) async {
    try {
      // save the user Info as local storage
      this.user = user;
      // await _storage.setItem(kLocalKey['userInfo']!, user);
      delegate?.onLoaded(user);
    } catch (err) {
      printLog(err);
    }
  }

  // Future<void> getUser() async {
  //   try {
  //     final json = _storage.getItem(kLocalKey['userInfo']!);
  //     if (json != null) {
  //       user = User.fromLocalJson(json);
  //       loggedIn = true;
  //       delegate?.onLoaded(user);
  //     }
  //   } catch (err) {
  //     printLog(err);
  //   }
  // }

  Future<void> createUser({
    String? username,
    String? password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    bool? isVendor,
    required Function success,
    Function? fail,
  }) async {
    try {
      loading = true;

      // await Services().firebase.createUserWithEmailAndPassword(email: username!, password: password!);

      await storeLoginStatus();
      success();

      loading = false;
    } catch (err) {
      fail!(err.toString());
      loading = false;
    }
  }

  // Future<void> logout() async {
  //   Services().firebase.signOut();

  //   await FacebookAuth.instance.logOut();

  //   delegate?.onLogout(user);
  //   user = null;
  //   loggedIn = false;
  //   try {
  //     await Future.wait([
  //       _storage.deleteItem(kLocalKey['userInfo']!),
  //       _storage.deleteItem(kLocalKey['shippingAddress']!),
  //       _storage.deleteItem(kLocalKey['recentSearches']!),
  //       _storage.deleteItem(kLocalKey['opencart_cookie']!),
  //       _storage.setItem(kLocalKey['userInfo']!, null),
  //     ]);

  //     var prefs = injector<SharedPreferences>();
  //     await prefs.setBool('loggedIn', false);
  //     await _service.api.logout();
  //   } catch (err) {
  //     printLog(err);
  //   }
  //
  // }

  Future<void> login({
    required String username,
    required String password,
    required Function(/*User user*/) success,
    required Function(String message) fail,
  }) async {
    try {
      loading = true;
      // var usr = await Services().firebase.loginFirebaseEmail(email: username, password: password);

      await storeLoginStatus();
      success();
      loading = false;
    } catch (err) {
      loading = false;
      fail(err.toString());
    }
  }

  storeLoginStatus() async {
    GetStorage().write('isLogging', true);
    // loggedIn = true;
    // // save to Preference
    // var prefs = injector<SharedPreferences>();
    // await prefs.setBool('loggedIn', true);
  }
}
