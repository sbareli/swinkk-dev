class Validators {
  static String? validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? value, {String? message}) {
    // String pattern =
    //     r'^.*(?=.{8,})((?=.*[!?@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$';
    // RegExp regExp = new RegExp(pattern);
    if (value == null || value.isEmpty) {
      return message ?? 'Password is required';
      // } else if (!regExp.hasMatch(value)) {
      //   return currentLanguage['valid_passwordRules'];
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String? value, {String? message}) {
    String pattern = r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return message ?? 'Phone number is required';
    } else if (!regExp.hasMatch(value)) {
      return message ?? 'Invalid phone number';
    } else {
      return null;
    }
  }

  static String? validatePhoneNumberAndEmail(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'Email or phone number is required';
    } else if (validatePhoneNumber(value) != null || validateEmail(value) != null) {
      return message ?? 'Invalid Email or Phone number';
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(String? value, {required String password, String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'Confirm password is required';
    } else if (password != value) {
      return 'Confirm password does not match with Password';
    } else {
      return null;
    }
  }
}
