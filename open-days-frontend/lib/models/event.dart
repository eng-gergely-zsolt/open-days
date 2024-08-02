import '../utils/utils.dart';

class Event {
  int id;
  bool isOnline;
  String location;
  String dateTime;
  String imagePath;
  String description;
  String organizerId;
  String activityName;
  String? meetingLink;
  String organizerLastName;
  String organizerFirstName;

  Event({
    this.id = -1,
    this.isOnline = false,
    this.location = '',
    this.dateTime = '',
    this.imagePath = '',
    this.description = '',
    this.organizerId = '',
    this.meetingLink = '',
    this.activityName = '',
    this.organizerLastName = '',
    this.organizerFirstName = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'isOnline': isOnline,
        'location': location,
        'dateTime': dateTime,
        'imagePath': imagePath,
        'description': description,
        'meetingLink': meetingLink,
        'activityName': activityName,
        'organizerPublicId': organizerId,
        'organizerLastName': organizerLastName,
        'organizerFirstName': organizerFirstName,
      };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? -1,
      isOnline: json['isOnline'] ?? false,
      dateTime: json['dateTime'] ?? '',
      imagePath: json['imagePath'] ?? '',
      meetingLink: json['meetingLink'] ?? '',
      organizerId: json['organizerPublicId'] ?? '',
      location: Utils.getDecodedString(json['location'] ?? ''),
      description: Utils.getDecodedString(json['description'] ?? ''),
      activityName: Utils.getDecodedString(json['activityName'] ?? ''),
      organizerLastName: Utils.getDecodedString(json['organizerLastName'] ?? ''),
      organizerFirstName: Utils.getDecodedString(json['organizerFirstName'] ?? ''),
    );
  }
}
