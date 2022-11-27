import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/base_response_model.dart';
import '../../modules/event_creator/models/create_event_model.dart';

Future<BaseResponseModel> createEventSvc(CreateEventModel payload) async {
  final response = BaseResponseModel();
  final body = jsonEncode(payload.event);
  const uri = 'http://10.0.2.2:8081/open-days/event';

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": payload.authorizationToken,
  };

  http.Response httpResponse = await http
      .post(
        Uri.parse(uri),
        headers: headers,
        body: body,
      )
      .timeout(const Duration(seconds: 5));

  if (httpResponse.statusCode == 200) {
    response.isOperationSuccessful = true;
  }

  return response;
}
