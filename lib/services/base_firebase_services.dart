class BaseFirebaseServices {
  Future<void> init() async {}

  void loginFirebaseApple({authorizationCode, identityToken}) {}

  void loginFirebaseFacebook({token}) {}

  void loginFirebaseGoogle({token}) {}

  void loginFirebaseEmail({email, password}) {}

  dynamic loginFirebaseCredential({credential}) {}

  dynamic getFirebaseCredential({verificationId, smsCode}) {}

  /// save user to firebase
  void saveUserToFirestore({user}) {}

  /// verify SMS login
  dynamic getFirebaseStream() {}

  void verifyPhoneNumber({phoneNumber, codeAutoRetrievalTimeout, codeSent, verificationCompleted, verificationFailed}) {}

  void createUserWithEmailAndPassword({email, password}) {}

  void sendPasswordResetEmail({email}) {}

  void signOut() {}
}
