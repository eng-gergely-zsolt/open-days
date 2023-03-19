import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/user_response_model.dart';
import '../../screens/registration/models/user.dart';

Future<UserResponseModel> createUserSvc(User user) async {
  final body = jsonEncode(user);
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/users';

  final rawResponse = await http.post(
    Uri.parse(uri),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  return UserResponseModel.fromJson(jsonDecode(rawResponse.body));
}
