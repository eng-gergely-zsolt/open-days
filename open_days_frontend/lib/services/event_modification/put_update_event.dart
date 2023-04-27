import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../shared/secure_storage.dart';
import '../../models/responses/base_response.dart';
import '../../models/event_modification_request.dart';

Future<BaseResponse> updateEventSvc(
    int eventId, EventModificationRequest updateEventPayload) async {
  final response = BaseResponse();
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  final uri =
      'https://open-days-thesis.herokuapp.com/open-days/event/update_event/' + eventId.toString();

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  final rawResponse = await http
      .put(Uri.parse(uri),
          headers: headers,
          body: jsonEncode(<String, Object?>{
            'dateTime': updateEventPayload.dateTime,
            'isOnline': updateEventPayload.isOnline,
            'location': updateEventPayload.location,
            'imageLink': updateEventPayload.imagePath,
            'description': updateEventPayload.description,
            'meetingLink': updateEventPayload.meetingLink,
            'activityName': updateEventPayload.activityName,
          }))
      .timeout(const Duration(seconds: 10));

  if (rawResponse.statusCode == 200) {
    response.isOperationSuccessful = true;
  }

  return response;
}
