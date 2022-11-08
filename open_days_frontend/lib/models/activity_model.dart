class ActivityModel {
  int id;
  String name;

  ActivityModel({
    this.id = -1,
    this.name = "",
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] ?? -1,
      name: json['name'] ?? '',
    );
  }
}
