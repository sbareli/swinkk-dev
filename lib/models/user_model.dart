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
    id = json['id'].toString();
    phoneNumber = json['phone_number'];
    userName = json['user_name'];
    systemId = json['system_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName,
      'system_id': systemId,
      'phone_number': phoneNumber,
      'email': email,
      'picture': picture,
      'jwtToken': jwtToken,
    };
  }

  User.fromLocalJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    systemId = json['system_id'];
    phoneNumber = json['phone_number'];
    userName = json['user_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    picture = json['picture'];
    jwtToken = json['jwtToken'];
  }

  User.fromAuthUser(Map<String, dynamic> json, String? _cookie) {
    id = json['id'].toString();
    userName = json['username'];
    firstName = json['firstname'];
    phoneNumber = json['phone_number'];
    systemId = json['system_id'];
    lastName = json['lastname'];
    email = json['email'];
    picture = json['avatar'];
  }
}
