import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../error/error_codes.dart';
import '../../error/error_messages.dart';
import '../../models/responses/base_error_response.dart';
import '../../models/responses/base_response.dart';
import '../../shared/secure_storage.dart';

Future<BaseResponse> verifyAuthorizationTokenSvc() async {
  BaseResponse response = BaseResponse();
  Map<String, dynamic> parsedResponse;
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/users/token-verification';

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  try {
    final rawResponse = await http
        .get(
          Uri.parse(uri),
          headers: headers,
        )
        .timeout(const Duration(seconds: 10));

    if (rawResponse.statusCode == 200) {
      parsedResponse = jsonDecode(rawResponse.body);
      response.error = BaseErrorResponse.fromJson(parsedResponse);
      response.isOperationSuccessful = true;
    } else {
      response = BaseResponse();
    }
  } on TimeoutException catch (_) {
    response.error.errorCode = timeoutExceptionCode;
    response.error.errorMessage = timeoutExceptionMessage;
  } on Exception catch (message) {
    response.error.errorCode = generalExceptionCode;
    response.error.errorMessage = message.toString();
  }

  return response;
}
