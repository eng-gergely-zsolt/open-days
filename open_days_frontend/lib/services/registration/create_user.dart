import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_days_frontend/modules/registration/models/user.dart';

import '../../models/user_response_model.dart';

Future<UserResponseModel> createUserSvc(User user) async {
  String uri = 'http://10.0.2.2:8081/open-days/users';

  String body = jsonEncode(user);

  http.Response response = await http.post(
    Uri.parse(uri),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  return UserResponseModel.fromJson(jsonDecode(response.body));
}
