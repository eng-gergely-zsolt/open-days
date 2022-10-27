import 'package:open_days_frontend/constants/constants.dart';

class EventResponseModel {
  bool isOnline;
  String location;
  String dateTime;
  String meetingLink;
  String organizerId;
  String activityName;
  String organizerLastName;
  String organizerFirstName;
  String operationResult = operationResultFailure;

  EventResponseModel({
    this.isOnline = false,
    this.location = '',
    this.dateTime = '',
    this.meetingLink = '',
    this.organizerId = '',
    this.activityName = '',
    this.organizerLastName = '',
    this.organizerFirstName = '',
  });

  factory EventResponseModel.fromJson(Map<String, dynamic> json) {
    return EventResponseModel(
      isOnline: json['isOnline'] ?? false,
      location: json['location'] ?? '',
      dateTime: json['dateTime'] ?? '',
      meetingLink: json['meetingLink'] ?? '',
      organizerId: json['organizerId'] ?? '',
      activityName: json['activityName'] ?? '',
      organizerLastName: json['organizerLastName'] ?? '',
      organizerFirstName: json['organizerFirstName'] ?? '',
    );
  }
}
