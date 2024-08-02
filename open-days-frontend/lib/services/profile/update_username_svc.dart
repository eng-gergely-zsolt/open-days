import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/base_error.dart';
import '../../error/error_codes.dart';
import '../../error/error_messages.dart';
import '../../shared/secure_storage.dart';
import '../../models/responses/update_username_response.dart';

Future<UpdateUsernameResponse> updateUsernameSvc(String username) async {
  UpdateUsernameResponse response = UpdateUsernameResponse();
  final userId = await SecureStorage.getUserId() ?? '';
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/user/update-username';

  Map<String, String> headers = {
    "User-Public-ID": userId,
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  try {
    final rawResponse = await http
        .put(
          Uri.parse(uri),
          headers: headers,
          body: jsonEncode(<String, Object?>{
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
      response.error = BaseError.fromJson(jsonDecode(rawResponse.body));
    } else {
      response.error.errorCode = baseErrorCode;
      response.error.errorMessage = baseErrorMessage;
    }
  } on TimeoutException catch (_) {
    response.error.errorCode = timeoutExceptionCode;
    response.error.errorMessage = timeoutExceptionMessage;
  } on Exception catch (error) {
    response.error.errorCode = baseErrorCode;
    response.error.errorMessage = error.toString();
  }

  return response;
}
