import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../error/error_codes.dart';
import '../../error/error_messages.dart';
import '../../shared/secure_storage.dart';
import '../../models/responses/user_response.dart';
import '../../models/responses/base_error_response.dart';

Future<UserResponse> getUserByIdSvc() async {
  var result = UserResponse();
  final userId = await SecureStorage.getUserId() ?? '';
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  final uri = 'https://open-days-thesis.herokuapp.com/open-days/users/' + userId;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  final rawResponse = await http
      .get(
        Uri.parse(uri),
        headers: headers,
      )
      .timeout(const Duration(seconds: 10));

  if (rawResponse.statusCode == 200) {
    result = UserResponse.fromJson(jsonDecode(rawResponse.body));
    result.isOperationSuccessful = true;
  } else if (rawResponse.statusCode == 500) {
    result.error = BaseErrorResponse.fromJson(jsonDecode(rawResponse.body));
  } else {
    result.error.errorCode = baseErrorCode;
    result.error.errorMessage = baseErrorMessage;
  }

  return result;
}
