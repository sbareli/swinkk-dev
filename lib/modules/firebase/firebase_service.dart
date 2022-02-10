import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swiftlink/common/utils/logs.dart';
import '../../services/base_firebase_services.dart';

class FirebaseServices extends BaseFirebaseServices {
  static final FirebaseServices _instance = FirebaseServices._internal();

  factory FirebaseServices() => _instance;
  FirebaseServices._internal();

  @override
  Future<void> init() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }

  /// Firebase Auth
  FirebaseAuth? _auth;

  FirebaseAuth? get auth => _auth;

  /// Firebase Cloud Firestore
  FirebaseFirestore? _firestore;

  FirebaseFirestore? get firestore => _firestore;

  @override
  Future loginFirebaseApple({authorizationCode, identityToken}) async {
    final AuthCredential credential = OAuthProvider('apple.com').credential(
      accessToken: String.fromCharCodes(authorizationCode),
      idToken: String.fromCharCodes(identityToken),
    );
    await FirebaseServices().auth!.signInWithCredential(credential);
  }

  @override
  Future loginFirebaseFacebook({token}) async {
    AuthCredential credential = FacebookAuthProvider.credential(token);
    await FirebaseServices().auth!.signInWithCredential(credential);
  }

  @override
  Future loginFirebaseGoogle({token}) async {
    AuthCredential credential = GoogleAuthProvider.credential(accessToken: token);
    await FirebaseServices().auth!.signInWithCredential(credential);
  }

  @override
  Future loginFirebaseEmail({email, password}) async {
    try {
      await auth!.signInWithEmailAndPassword(email: email, password: password);
      return auth!.currentUser;
      // await FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
      //   'name': email,
      //   'email': email
      // });
      // // _userFromFirebaseUser(user.user);
    } on FirebaseAuthException catch (e) {
      printLog(e.message);
      rethrow;
    } catch (e) {
      printLog(e);
    }
  }

  @override
  Future<User?>? loginFirebaseCredential({credential}) async {
    return (await FirebaseServices().auth!.signInWithCredential(credential)).user;
  }

  @override
  void saveUserToFirestore({user}) async {
    var usr = auth!.currentUser;
    await FirebaseServices().firestore!.collection('users').doc(usr!.uid).set(
      {
        'email': usr.email,
        'phonenumber': usr.phoneNumber,
        'username': user.username,
        'firstname': user.firstName,
        'lastname': user.lastName,
        'first_login': DateTime.now(),
        'last_login': DateTime.now(),
      },
      SetOptions(merge: true),
    );
    saveUserLocation(user);
  }

  saveUserLocation(user) async {
    var usr = auth!.currentUser;
    await FirebaseServices().firestore!.collection('User_Contact').doc(usr!.uid).set(
      {
        'opt_address_1': user.location,
      },
      SetOptions(merge: true),
    );
  }

  saveUserPreferences(preferences) async {
    var usr = auth!.currentUser;
    await FirebaseServices().firestore!.collection('User_Preferences').doc(usr!.uid).set(
      {
        'service_category': preferences,
      },
      SetOptions(merge: true),
    );
  }

  @override
  PhoneAuthCredential getFirebaseCredential({verificationId, smsCode}) {
    return PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  @override
  StreamController<PhoneAuthCredential> getFirebaseStream() {
    return StreamController<PhoneAuthCredential>.broadcast();
  }

  @override
  void verifyPhoneNumber({phoneNumber, codeAutoRetrievalTimeout, codeSent, verificationCompleted, verificationFailed}) async {
    await FirebaseServices().auth!.verifyPhoneNumber(
          phoneNumber: phoneNumber!,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          codeSent: codeSent,
          timeout: const Duration(seconds: 120),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
        );
  }

  @override
  Future createUserWithEmailAndPassword({email, password}) async {
    // if (isEnabled) {
    try {
      await FirebaseServices().auth?.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
    } on Exception catch (_) {
      rethrow;
    }
    // }
  }

  @override
  void sendPasswordResetEmail({email}) {
    try {
      FirebaseServices().auth?.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void signOut() async {
    await FirebaseServices().auth?.signOut();
  }

  bool get isEmailVerfied => FirebaseServices().auth?.currentUser?.emailVerified ?? false;

  Future<DocumentSnapshot> userExistInDB() async {
    var userDoc = await FirebaseServices().firestore!.collection('users').doc(auth!.currentUser!.uid).get();
    return userDoc;
  }

  Future updateUserLastLogin() async {
    return await FirebaseServices().firestore!.collection('users').doc(auth!.currentUser!.uid).update({
      'last_login': DateTime.now(),
    });
  }

  Future<QuerySnapshot> getServices() async {
    return await FirebaseServices().firestore!.collection('Service').get();
  }
}
