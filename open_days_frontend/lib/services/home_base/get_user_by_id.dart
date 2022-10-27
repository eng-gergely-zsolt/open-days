import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_days_frontend/constants/constants.dart';
import 'package:open_days_frontend/models/user_request_model.dart';
import 'package:open_days_frontend/models/user_response_model.dart';

Future<UserResponseModel> getUserByIdSvc(
    UserRequestModel userRequestData) async {
  String uri = 'http://10.0.2.2:8081/open-days/users/' + userRequestData.id;
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": userRequestData.authorizationToken,
  };

  final response = await http
      .get(
        Uri.parse(uri),
        headers: headers,
      )
      .timeout(const Duration(seconds: 5));

  var result = UserResponseModel();

  if (response.statusCode == 200) {
    result = UserResponseModel.fromJson(jsonDecode(response.body));
    result.operationResult = operationResultSuccess;
    return result;
  } else {
    result.operationResult = operationResultFailure;
    return result;
  }
}
