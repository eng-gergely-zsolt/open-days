import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../shared/secure_storage.dart';
import '../../domain/models/base_response_model.dart';
import '../../domain/models/event_modification_request.dart';

Future<BaseResponseModel> updateEventSvc(
    int eventId, EventModificationRequest updateEventPayload) async {
  final response = BaseResponseModel();
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  final uri = 'http://10.0.2.2:8081/open-days/event/update_event/' + eventId.toString();

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
            'meetingLink': updateEventPayload.meetingLink,
            'activityName': updateEventPayload.activityName,
          }))
      .timeout(const Duration(seconds: 5));

  if (rawResponse.statusCode == 200) {
    response.isOperationSuccessful = true;
  }

  return response;
}