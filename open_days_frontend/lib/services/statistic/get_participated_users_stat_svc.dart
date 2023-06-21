import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../error/error_codes.dart';
import '../../models/base_error.dart';
import '../../error/error_messages.dart';
import '../../shared/secure_storage.dart';
import '../../models/participated_users_stat.dart';
import '../../models/responses/participated_users_stat_response.dart';

Future<ParticipatedUsersStatResponse> getParticipatedUsersStatSvc(
    List<String> activityNames) async {
  final response = ParticipatedUsersStatResponse();
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/event/participated-users-stat';

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
  };

  // var body = jsonEncode(activityNames);

  try {
    Iterable decodedBody;
    final rawResponse = await http
        .put(
          Uri.parse(uri),
          headers: headers,
          body: jsonEncode(activityNames),
        )
        .timeout(const Duration(seconds: 10));

    if (rawResponse.statusCode == 200) {
      response.isOperationSuccessful = true;
      decodedBody = jsonDecode(rawResponse.body);
      response.stats = decodedBody.map((e) => ParticipatedUsersStat.fromJson(e)).toList();
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
