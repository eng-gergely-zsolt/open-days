import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/activity_model.dart';
import '../../shared/secure_storage.dart';
import '../../models/responses/activities_response.dart';

Future<ActivitiesResponse> getAllActivitySvc() async {
  final response = ActivitiesResponse();
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
      .timeout(const Duration(seconds: 10));

  if (rawResponse.statusCode == 200) {
    Iterable decodedBody = jsonDecode(rawResponse.body);

    response.isOperationSuccessful = true;
    response.activities = decodedBody.map((e) => ActivityModel.fromJson(e)).toList();
  }

  return response;
}
