import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../models/user_request_model.dart';
import '../../models/user_response_model.dart';

Future<UserResponseModel> getUserByIdSvc(UserRequestModel userRequestData) async {
  var result = UserResponseModel();
  final uri = 'http://10.0.2.2:8081/open-days/users/' + userRequestData.id;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": userRequestData.authorizationToken,
  };

  final rawResponse = await http
      .get(
        Uri.parse(uri),
        headers: headers,
      )
      .timeout(const Duration(seconds: 5));

  if (rawResponse.statusCode == 200) {
    result = UserResponseModel.fromJson(jsonDecode(rawResponse.body));
    result.operationResult = operationResultSuccess;
    return result;
  } else {
    result.operationResult = operationResultFailure;
    return result;
  }
}
