import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_request_model.dart';
import '../models/user_response_model.dart';
import '../services/login/post_login_user.dart';

final loginRepositoryProvider = Provider((_) => LoginRepository());

class LoginRepository {
  Future<UserResponseModel> loginUserRepo(UserRequestModel user) async {
    return await loginUserSvc(user);
  }
}
