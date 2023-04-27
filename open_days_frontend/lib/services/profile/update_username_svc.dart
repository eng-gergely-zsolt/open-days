import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../error/error_codes.dart';
import '../../error/error_messages.dart';
import '../../shared/secure_storage.dart';
import '../../models/responses/update_username_response.dart';
import '../../models/responses/base_error_response.dart';

Future<UpdateUsernameResponse> updateUsernameSvc(String id, String username) async {
  UpdateUsernameResponse response = UpdateUsernameResponse();
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/users/update-username';

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  final rawResponse = await http
      .put(
        Uri.parse(uri),
        headers: headers,
        body: jsonEncode(<String, Object?>{
          'publicId': id,
          'username': username,
        }),
      )
      .timeout(const Duration(seconds: 10));

  if (rawResponse.statusCode == 200) {
    response.isOperationSuccessful = true;

    for (var it in rawResponse.headers.entries) {
      if (it.key == 'authorization') {
        response.authorizationToken = it.value;
      }
    }
  } else if (rawResponse.statusCode == 500) {
    response.error = BaseErrorResponse.fromJson(jsonDecode(rawResponse.body));
  } else {
    response.error.errorCode = baseErrorCode;
    response.error.errorMessage = baseErrorMessage;
  }

  return response;
}
