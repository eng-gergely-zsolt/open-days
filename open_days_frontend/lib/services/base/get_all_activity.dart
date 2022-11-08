import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/activity_model.dart';
import '../../models/base_request_model.dart';
import '../../models/activities_response_model.dart';

Future<ActivitiesResponseModel> getAllActivitySvc(
    BaseRequestModel baseRequestData) async {
  String uri = 'http://10.0.2.2:8081/open-days/activity/all-activity';

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": baseRequestData.authorizationToken,
  };

  final rawResponse = await http
      .get(
        Uri.parse(uri),
        headers: headers,
      )
      .timeout(const Duration(seconds: 5));

  ActivitiesResponseModel response = ActivitiesResponseModel();

  if (rawResponse.statusCode == 200) {
    Iterable decodedBody = jsonDecode(rawResponse.body);

    response.isOperationSuccessful = true;

    response.activities =
        decodedBody.map((e) => ActivityModel.fromJson(e)).toList();
  }

  return response;
}
