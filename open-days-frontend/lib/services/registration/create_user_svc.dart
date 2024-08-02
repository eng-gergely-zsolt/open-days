import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/base_error.dart';
import '../../error/error_codes.dart';
import '../../error/error_messages.dart';
import '../../models/responses/base_response.dart';
import '../../models/requests/create_user_request.dart';

Future<BaseResponse> createUserSvc(CreateUserRequest user) async {
  final body = jsonEncode(user);
  final response = BaseResponse();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/user/create-user';

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  try {
    final rawResponse = await http
        .post(
          Uri.parse(uri),
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 10));

    if (rawResponse.statusCode == 200) {
      response.isOperationSuccessful = true;
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
