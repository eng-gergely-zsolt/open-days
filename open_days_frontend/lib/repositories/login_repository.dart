import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/requests/user_request_model.dart';
import '../models/responses/user_login_response.dart';
import '../services/login/post_login_user.dart';

final loginRepositoryProvider = Provider((_) => LoginRepository());

class LoginRepository {
  Future<UserLoginResponse> loginUserRepo(UserRequestModel user) async {
    return await loginUserSvc(user);
  }
}
