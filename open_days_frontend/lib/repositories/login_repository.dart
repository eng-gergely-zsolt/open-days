import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/models/response_model.dart';
import 'package:open_days_frontend/models/user.dart';
import 'package:open_days_frontend/services/login/post_login_user.dart';

final loginRepositoryProvider = Provider((_) => LoginRepository());

class LoginRepository {
  Future<ResponseModel> loginUserRepo(User user) async {
    await Future.delayed(const Duration(seconds: 3));
    return await loginUserSvc(user);
  }
}
