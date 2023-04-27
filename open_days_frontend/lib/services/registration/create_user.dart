import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/responses/user_login_response.dart';
import '../../screens/registration/models/user.dart';

Future<UserLoginResponse> createUserSvc(User user) async {
  final body = jsonEncode(user);
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/users';

  final rawResponse = await http.post(
    Uri.parse(uri),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  return UserLoginResponse.fromJson(jsonDecode(rawResponse.body));
}
