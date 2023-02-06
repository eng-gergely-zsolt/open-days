import 'package:http/http.dart' as http;

import '../../shared/secure_storage.dart';
import '../../models/base_response_model.dart';

/// It deletes the event with the given id.
Future<BaseResponseModel> deleteEventSvc(int eventId) async {
  final response = BaseResponseModel();
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  final uri = 'http://10.0.2.2:8081/open-days/event/delete_event/' + eventId.toString();

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  final rawResponse = await http
      .delete(
        Uri.parse(uri),
        headers: headers,
      )
      .timeout(const Duration(seconds: 5));

  if (rawResponse.statusCode == 200) {
    response.isOperationSuccessful = true;
  }

  return response;
}
