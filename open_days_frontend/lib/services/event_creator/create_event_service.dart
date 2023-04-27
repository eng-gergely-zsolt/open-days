import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/responses/base_response.dart';
import '../../screens/event_creator/models/create_event_model.dart';

Future<BaseResponse> createEventSvc(CreateEventModel payload) async {
  final response = BaseResponse();
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
