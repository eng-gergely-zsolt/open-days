class EventModel {
  bool isOnline;
  String dateTime;
  String location;
  String? imagePath;
  String description;
  String organizerId;
  String activityName;
  String? meetingLink;

  EventModel({
    this.dateTime = '',
    this.location = '',
    this.isOnline = false,
    this.description = '',
    this.organizerId = '',
    this.activityName = '',
  });

  Map<String, dynamic> toJson() => {
        'isOnline': isOnline,
        'dateTime': dateTime,
        'location': location,
        'imageLink': imagePath,
        'description': description,
        'meetingLink': meetingLink,
        'organizerId': organizerId,
        'activityName': activityName,
      };
}
