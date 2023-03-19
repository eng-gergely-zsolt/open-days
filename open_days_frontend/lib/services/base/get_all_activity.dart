import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/activity_model.dart';
import '../../shared/secure_storage.dart';
import '../../models/activities_response_model.dart';

Future<ActivitiesResponseModel> getAllActivitySvc() async {
  final response = ActivitiesResponseModel();
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/activity/all-activity';

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
    Iterable decodedBody = jsonDecode(rawResponse.body);

    response.isOperationSuccessful = true;
    response.activities = decodedBody.map((e) => ActivityModel.fromJson(e)).toList();
  }

  return response;
}
