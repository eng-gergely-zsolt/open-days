import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../shared/secure_storage.dart';
import '../../models/user_response_model.dart';

Future<UserResponseModel> getUserByIdSvc() async {
  var result = UserResponseModel();
  final userId = await SecureStorage.getUserId() ?? '';
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  final uri = 'https://open-days-thesis.herokuapp.com/open-days/users/' + userId;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": authorizationToken ?? '',
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
