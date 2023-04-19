class EventModificationRequest {
  bool isOnline;
  String? dateTime;
  String? location;
  String? imagePath;
  String? description;
  String? meetingLink;
  String? activityName;

  EventModificationRequest({
    this.isOnline = false,
  });
}
