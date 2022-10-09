class UserPrefrence {
  String? systemId;
  String? userName;
  List? serviceCategory;

  UserPrefrence({
    required this.systemId,
    required this.serviceCategory,
    required this.userName,
  });

  UserPrefrence.fromJson(Map<String, dynamic> json) {
    systemId = json['system_id'];
    userName = json['user_name'];
    serviceCategory = json['service_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['system_id'] = systemId;
    data['user_name'] = userName;
    data['service_category'] = serviceCategory;
    return data;
  }
}
