import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/base_response_model.dart';
import '../../screens/event_creator/models/create_event_model.dart';

Future<BaseResponseModel> createEventSvc(CreateEventModel payload) async {
  final response = BaseResponseModel();
  final body = jsonEncode(payload.event);
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/event';

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
      .timeout(const Duration(seconds: 10));

  if (httpResponse.statusCode == 200) {
    response.isOperationSuccessful = true;
  }

  return response;
}
