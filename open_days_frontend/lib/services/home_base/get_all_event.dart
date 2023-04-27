import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../shared/secure_storage.dart';
import '../../screens/home_base/models/get_all_event_model.dart';
import '../../screens/home_base/models/event_response_model.dart';

Future<GetAllEventModel> getAllEventSvc() async {
  final response = GetAllEventModel();
  final authorizationToken = await SecureStorage.getAuthorizationToken();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/event/all-event';

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
    Iterable decodedResponse = jsonDecode(rawResponse.body);

    response.operationResult = operationResultSuccess;
    response.events = decodedResponse.map((e) => EventResponseModel.fromJson(e)).toList();
  }

  return response;
}
