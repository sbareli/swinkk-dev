class UserContact {
  String? optAddressOne;
  String? country;
  String? postalCode;
  String? administrativeAreaLevel1;
  String? systemId;
  String? userName;

  UserContact({
    required this.optAddressOne,
    required this.country,
    required this.postalCode,
    required this.administrativeAreaLevel1,
    required this.systemId,
    required this.userName,
  });

  UserContact.fromJson(Map<String, dynamic> json) {
    optAddressOne = json['optAddressOne'];
    administrativeAreaLevel1 = json['administrativeAreaLevel1'];
    postalCode = json['postalCode'];
    country = json['country'];
    systemId = json['system_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['optAddressOne'] = optAddressOne;
    data['administrativeAreaLevel1'] = administrativeAreaLevel1;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['system_id'] = systemId;
    data['user_name'] = userName;
    return data;
  }
}
