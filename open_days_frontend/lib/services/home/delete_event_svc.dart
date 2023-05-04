import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../error/error_codes.dart';
import '../../models/base_error.dart';
import '../../error/error_messages.dart';
import '../../shared/secure_storage.dart';
import '../../models/responses/base_response.dart';

/// It deletes the event with the given id.
Future<BaseResponse> deleteEventSvc(int eventId) async {
  final response = BaseResponse();
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  final uri =
      'https://open-days-thesis.herokuapp.com/open-days/event/delete_event/' + eventId.toString();

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  try {
    final rawResponse = await http
        .delete(
          Uri.parse(uri),
          headers: headers,
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
