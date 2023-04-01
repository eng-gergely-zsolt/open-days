import 'package:open_days_frontend/utils/utils.dart';

import '../../../constants/constants.dart';

class EventResponseModel {
  int id;
  bool isOnline;
  String location;
  String dateTime;
  String imageLink;
  String description;
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
    this.imageLink = '',
    this.description = '',
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
      dateTime: json['dateTime'] ?? '',
      imageLink: json['imageLink'] ?? '',
      meetingLink: json['meetingLink'] ?? '',
      organizerId: json['organizerId'] ?? '',
      location: Utils.getDecodedString(json['location'] ?? ''),
      description: Utils.getDecodedString(json['description'] ?? ''),
      activityName: Utils.getDecodedString(json['activityName'] ?? ''),
      organizerLastName: Utils.getDecodedString(json['organizerLastName'] ?? ''),
      organizerFirstName: Utils.getDecodedString(json['organizerFirstName'] ?? ''),
    );
  }
}
