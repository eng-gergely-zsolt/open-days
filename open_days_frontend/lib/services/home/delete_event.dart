import 'package:http/http.dart' as http;

import '../../shared/secure_storage.dart';
import '../../models/responses/base_response.dart';

/// It deletes the event with the given id.
Future<BaseResponse> deleteEventSvc(int eventId) async {
  final response = BaseResponse();
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  final uri =
      'https://open-days-thesis.herokuapp.com/open-days/event/delete_event/' + eventId.toString();

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  final rawResponse = await http
      .delete(
        Uri.parse(uri),
        headers: headers,
      )
      .timeout(const Duration(seconds: 10));

  if (rawResponse.statusCode == 200) {
    response.isOperationSuccessful = true;
  }

  return response;
}
