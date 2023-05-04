import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../error/error_codes.dart';
import '../../models/base_error.dart';
import '../../error/error_messages.dart';
import '../../shared/secure_storage.dart';
import '../../models/responses/base_logical_response.dart';

Future<BaseLogicalResponse> isUserEnrolledSvc(int eventId) async {
  final response = BaseLogicalResponse();
  final userId = await SecureStorage.getUserId() ?? '';
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  final uri = 'https://open-days-thesis.herokuapp.com/open-days/event/is-user-enrolled/' +
      eventId.toString();

  Map<String, String> headers = {
    "User-Public-ID": userId,
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
      response.isOperationSuccessful = true;
      response.data = jsonDecode(rawResponse.body);
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
