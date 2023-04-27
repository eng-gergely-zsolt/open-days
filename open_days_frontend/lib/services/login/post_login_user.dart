import 'dart:convert';

import 'package:open_days_frontend/constants/constants.dart';
import 'package:open_days_frontend/models/responses/user_login_response.dart';
import 'package:open_days_frontend/models/requests/user_request_model.dart';
import 'package:http/http.dart' as http;

Future<UserLoginResponse> loginUserSvc(UserRequestModel user) async {
  final body = jsonEncode(user);
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/users/login';
  Map<String, String> headers = {"Content-Type": "application/json"};

  final rawResponse = await http.post(
    Uri.parse(uri),
    headers: headers,
    body: body,
  );

  final response =
      UserLoginResponse(operationResultCode: -1, operationResultMessage: '', operationResult: '');

  if (rawResponse.statusCode == 200) {
    response.operationResult = operationResultSuccess;

    for (var it in rawResponse.headers.entries) {
      if (it.key == 'userid') {
        response.id = it.value;
      }
      if (it.key == 'authorization') {
        response.authorizationToken = it.value;
      }
    }
  }

  return response;
}
