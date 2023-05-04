import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../error/error_codes.dart';
import '../../models/base_error.dart';
import '../../error/error_messages.dart';
import '../../models/requests/login_user_request.dart';
import '../../models/responses/login_user_response.dart';

Future<LoginUserResponse> loginUserSvc(LoginUserRequest user) async {
  final body = jsonEncode(user);
  final response = LoginUserResponse();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/user/login';

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  try {
    final rawResponse = await http.post(
      Uri.parse(uri),
      headers: headers,
      body: body,
    );

    if (rawResponse.statusCode == 200) {
      response.isOperationSuccessful = true;

      for (var it in rawResponse.headers.entries) {
        if (it.key == 'user-public-id') {
          response.id = it.value;
        }
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
