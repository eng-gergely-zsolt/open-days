import 'dart:convert';

import 'package:open_days_frontend/constants/constants.dart';
import 'package:open_days_frontend/models/user_response_model.dart';
import 'package:open_days_frontend/models/user_request_model.dart';
import 'package:http/http.dart' as http;

Future<UserResponseModel> loginUserSvc(UserRequestModel user) async {
  String body = jsonEncode(user);
  String uri = 'http://10.0.2.2:8081/open-days/users/login';
  Map<String, String> headers = {"Content-Type": "application/json"};

  http.Response response = await http.post(
    Uri.parse(uri),
    headers: headers,
    body: body,
  );

  final responseTemp =
      UserResponseModel(code: -1, message: '', operationResult: '');

  if (response.statusCode == 200) {
    responseTemp.operationResult = operationResultSuccess;

    for (var it in response.headers.entries) {
      if (it.key == 'userid') {
        responseTemp.id = it.value;
      }
      if (it.key == 'authorization') {
        responseTemp.bearer = it.value;
      }
    }
  }

  return responseTemp;
}
