import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/login/login_user_svc.dart';
import '../models/requests/login_user_request.dart';
import '../models/responses/login_user_response.dart';

final loginRepositoryProvider = Provider((_) => LoginRepository());

class LoginRepository {
  Future<LoginUserResponse> loginUserRepo(LoginUserRequest user) async {
    return await loginUserSvc(user);
  }
}
