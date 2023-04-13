class EventModificationRequest {
  bool isOnline;
  String? dateTime;
  String? location;
  String? imagePath;
  String? meetingLink;
  String? activityName;

  EventModificationRequest({
    this.isOnline = false,
  });
}
