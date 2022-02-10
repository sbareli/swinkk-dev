// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(message) => "Error: ${message}";

  static String m1(message) =>
      "There is an issue with the app during request the data, please contact admin for fixing the issues: ${message}";

  static String m2(message) => "Warning: ${message}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Cannot be empty"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "code": MessageLookupByLibrary.simpleMessage("Code"),
        "codeEnteredIsNotCorrect":
            MessageLookupByLibrary.simpleMessage("Code entered is not correct"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmNewPassword":
            MessageLookupByLibrary.simpleMessage("Confirm New Password"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "continueText": MessageLookupByLibrary.simpleMessage("Continue"),
        "couldNotVerifyCheckTheEnteredDetails":
            MessageLookupByLibrary.simpleMessage(
                "Could not verify. Check the entered details."),
        "createAnAccount":
            MessageLookupByLibrary.simpleMessage("Create an account"),
        "createNewPassword":
            MessageLookupByLibrary.simpleMessage("Create New Password"),
        "createYourNewPassword":
            MessageLookupByLibrary.simpleMessage("Create your new password"),
        "dontHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "emailAddress": MessageLookupByLibrary.simpleMessage("Email address"),
        "emailOrPhoneNumber":
            MessageLookupByLibrary.simpleMessage("Email or phone number"),
        "enterTheConfirmationCodeWeHaveSentOnYourEmail":
            MessageLookupByLibrary.simpleMessage(
                "Enter the confirmation code we have sent on your email address or phone number."),
        "error": m0,
        "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "homeLocation": MessageLookupByLibrary.simpleMessage("Home Location"),
        "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
        "loading": MessageLookupByLibrary.simpleMessage("loading..."),
        "loginCanceled":
            MessageLookupByLibrary.simpleMessage("The login is cancelled"),
        "loginErrorServiceProvider": m1,
        "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "or": MessageLookupByLibrary.simpleMessage("Or"),
        "orSignInWithYourSocialMedia": MessageLookupByLibrary.simpleMessage(
            "or sign in with your social media"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "personalDetails":
            MessageLookupByLibrary.simpleMessage("Personal Details"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone number"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "tellUsWhatYoureInto":
            MessageLookupByLibrary.simpleMessage("Tell us what you’re into"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "verifySms": MessageLookupByLibrary.simpleMessage("Verify SMS"),
        "warning": m2,
        "youMayRecieveSmsOrOptOutAtAnyTime":
            MessageLookupByLibrary.simpleMessage(
                "You may recieve SMS or opt out at any time.")
      };
}
