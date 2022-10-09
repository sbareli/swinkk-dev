class ServiceModel {
  int? rank;
  String? systemId;
  List? serviceName;
  String? serviceCategory;

  ServiceModel({
    required this.rank,
    required this.systemId,
    required this.serviceCategory,
    required this.serviceName,
  });

  ServiceModel.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    systemId = json['system_id'];
    serviceName = json['service_name'];
    serviceCategory = json['service_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['system_id'] = systemId;
    data['serviceName'] = serviceName;
    data['service_category'] = serviceCategory;
    return data;
  }
}
