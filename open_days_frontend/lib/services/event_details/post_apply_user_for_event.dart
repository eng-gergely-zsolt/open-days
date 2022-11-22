import 'package:http/http.dart' as http;

import '../../shared/secure_storage.dart';
import '../../models/base_response_model.dart';

Future<BaseResponseModel> applyUserForEventSvc(int eventId) async {
  final response = BaseResponseModel();
  final userPublicId = await SecureStorage.getUserId() ?? '';
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  final uri = 'http://10.0.2.2:8081/open-days/event/apply_user_for_event/' +
      eventId.toString() +
      '/' +
      userPublicId;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  final rawResponse = await http
      .post(
        Uri.parse(uri),
        headers: headers,
      )
      .timeout(const Duration(seconds: 5));

  if (rawResponse.statusCode == 200) {
    response.isOperationSuccessful = true;
  }

  return response;
}
