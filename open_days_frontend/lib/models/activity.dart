import '../utils/utils.dart';

class Activity {
  int id;
  String name;

  Activity({
    this.id = -1,
    this.name = "",
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? -1,
      name: Utils.getDecodedString(json['name'] ?? ''),
    );
  }
}
