import '../../../constants/constants.dart';

class EventResponseModel {
  int id;
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
    this.id = -1,
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
      id: json['id'] ?? -1,
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
