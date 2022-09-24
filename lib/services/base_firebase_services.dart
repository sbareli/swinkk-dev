class BaseFirebaseServices {
  static void loginFirebaseApple({authorizationCode, identityToken}) {}

  static void loginFirebaseFacebook({token}) {}

  static void loginFirebaseGoogle({token}) {}

  static void loginFirebaseEmail({email, password}) {}

  static void loginFirebaseCredential({credential}) {}

  static void getFirebaseCredential({verificationId, smsCode}) {}

  static void saveUserToFirestore({user}) {}

  static void getFirebaseStream() {}

  static void verifyPhoneNumber({phoneNumber, codeAutoRetrievalTimeout, codeSent, verificationCompleted, verificationFailed}) {}

  static void createUserWithEmailAndPassword({email, password}) {}

  static void sendPasswordResetEmail({email}) {}

  static void signOut() {}
}
