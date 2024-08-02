class UpdateEventRequest {
  bool? isOnline;
  String? location;
  String? dateTime;
  String? imagePath;
  String? description;
  String? meetingLink;
  String? activityName;

  UpdateEventRequest({
    this.isOnline = false,
  });

  Map<String, dynamic> toJson() => {
        'isOnline': isOnline,
        'location': location,
        'dateTime': dateTime,
        'imagePath': imagePath,
        'description': description,
        'meetingLink': meetingLink,
        'activityName': activityName,
      };
}
