class EventModel {
  bool isOnline;
  String dateTime;
  String location;
  String organizerId;
  String activityName;
  String? meetingLink;

  EventModel({
    this.dateTime = '',
    this.location = '',
    this.isOnline = false,
    this.organizerId = '',
    this.activityName = '',
  });

  Map<String, dynamic> toJson() => {
        'isOnline': isOnline,
        'dateTime': dateTime,
        'location': location,
        'meetingLink': meetingLink,
        'organizerId': organizerId,
        'activityName': activityName,
      };
}
