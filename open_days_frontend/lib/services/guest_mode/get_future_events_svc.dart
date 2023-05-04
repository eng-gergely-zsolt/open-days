import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/event.dart';
import '../../error/error_codes.dart';
import '../../models/base_error.dart';
import '../../error/error_messages.dart';
import '../../shared/secure_storage.dart';
import '../../models/responses/events_response.dart';

Future<EventsResponse> getFutureEventsSvc() async {
  final response = EventsResponse();
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/event/future-events';

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  try {
    Iterable decodedBody;
    final rawResponse = await http
        .get(
          Uri.parse(uri),
          headers: headers,
        )
        .timeout(const Duration(seconds: 10));

    if (rawResponse.statusCode == 200) {
      response.isOperationSuccessful = true;
      decodedBody = jsonDecode(rawResponse.body);
      response.events = decodedBody.map((e) => Event.fromJson(e)).toList();
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
