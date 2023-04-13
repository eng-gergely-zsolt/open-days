import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../shared/secure_storage.dart';
import '../../models/base_response_model.dart';
import '../../models/event_modification_request.dart';

Future<BaseResponseModel> updateEventSvc(
    int eventId, EventModificationRequest updateEventPayload) async {
  final response = BaseResponseModel();
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
            'meetingLink': updateEventPayload.meetingLink,
            'activityName': updateEventPayload.activityName,
          }))
      .timeout(const Duration(seconds: 10));

  if (rawResponse.statusCode == 200) {
    response.isOperationSuccessful = true;
  }

  return response;
}
