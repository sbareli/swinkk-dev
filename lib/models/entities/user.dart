// import 'package:flutter/cupertino.dart';

// import '../../common/constants.dart';
// import '../../common/tools.dart';
// import '../serializers/user.dart';
// import 'user_address.dart';

import 'package:swiftlink/common/utils/logs.dart';

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? phoneNumber;
  String? systemId;
  String? picture;
  String? jwtToken;
  User({
    this.id,
    this.systemId,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.picture,
    this.jwtToken,
  });

  User.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'].toString();
      phoneNumber = json['phoneNumber'];
      userName = json['userName'];
      systemId = json['system_id'];
      firstName = json['firstName'];
      lastName = json['lastName'];
      email = json['email'] ?? id;
    } catch (e) {
      printLog(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'system_id': systemId,
      'phoneNumber': phoneNumber,
      'email': email,
      'picture': picture,
      'jwtToken': jwtToken,
    };
  }

  User.fromLocalJson(Map<String, dynamic> json) {
    try {
      id = json['id'].toString();
      systemId = json['system_id'];
      phoneNumber = json['phoneNumber'];
      userName = json['userName'];
      firstName = json['firstName'];
      lastName = json['lastName'];
      email = json['email'];
      picture = json['picture'];
      jwtToken = json['jwtToken'];
    } catch (e) {
      printLog(e.toString());
    }
  }

  // from Create User
  User.fromAuthUser(Map<String, dynamic> json, String? _cookie) {
    try {
      id = json['id'].toString();
      userName = json['username'];
      firstName = json['firstname'];
      phoneNumber = json['phoneNumber'];
      systemId = json['system_id'];
      lastName = json['lastname'];
      email = json['email'];
      picture = json['avatar'];
    } catch (e) {
      printLog(e.toString());
    }
  }
}
