import 'dart:convert';

import 'package:open_days_frontend/models/response_model.dart';
import 'package:open_days_frontend/models/user.dart';
import 'package:http/http.dart' as http;

Future<ResponseModel> loginUserSvc(User user) async {
  String body = jsonEncode(user);
  String uri = 'http://10.0.2.2:8081/open-days/users/login';
  Map<String, String> headers = {"Content-Type": "application/json"};

  http.Response response = await http.post(
    Uri.parse(uri),
    headers: headers,
    body: body,
  );

  final responseTemp =
      ResponseModel(code: -1, message: '', operationResult: '');

  if (response.statusCode == 200) {
    responseTemp.operationResult = 'SUCCESS';

    for (var it in response.headers.entries) {
      if (it.key == 'Authorization') {
        responseTemp.bearer = it.value;
      }
    }
  }

  return responseTemp;
}
