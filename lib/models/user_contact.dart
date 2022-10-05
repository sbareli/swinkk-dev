class UserContact {
  String? optAddressOne;
  String? systemId;
  String? userName;

  UserContact({
    required this.optAddressOne,
    required this.systemId,
    required this.userName,
  });

  UserContact.fromJson(Map<String, dynamic> json) {
    optAddressOne = json['optAddressOne'];
    systemId = json['systemId'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['optAddressOne'] = optAddressOne;
    data['systemId'] = systemId;
    data['userName'] = userName;
    return data;
  }
}
