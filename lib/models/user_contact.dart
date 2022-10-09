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
    systemId = json['system_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['optAddressOne'] = optAddressOne;
    data['system_id'] = systemId;
    data['user_name'] = userName;
    return data;
  }
}
