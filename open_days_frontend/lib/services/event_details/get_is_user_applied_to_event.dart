import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../shared/secure_storage.dart';
import '../../screens/event_details/models/is_user_applied_for_event.dart';

Future<IsUserAppliedForEvent> isUserAppliedForEventSvc(int eventId) async {
  final response = IsUserAppliedForEvent();
  final userPublicId = await SecureStorage.getUserId() ?? '';
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  final uri = 'https://open-days-thesis.herokuapp.com/open-days/event/is-user-applied-for-event/' +
      eventId.toString() +
      '/' +
      userPublicId;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  final rawResponse = await http
      .get(
        Uri.parse(uri),
        headers: headers,
      )
      .timeout(const Duration(seconds: 5));

  if (rawResponse.statusCode == 200) {
    response.isOperationSuccessful = true;
    response.isUserAppliedForEvent = jsonDecode(rawResponse.body);
  }

  return response;
}
