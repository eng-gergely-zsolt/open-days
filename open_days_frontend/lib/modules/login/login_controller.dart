import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/models/response_model.dart';
import 'package:open_days_frontend/models/user.dart';

import '../../repositories/login_repository.dart';

class LoginController {
  final ProviderRef ref;
  final User user = User();
  final LoginRepository loginRepository;
  final _isLoadingProvider = StateProvider<bool>((ref) => false);

  ResponseModel? _loginResponse;

  StateProvider<bool> getIsLoadinProvider() {
    return _isLoadingProvider;
  }

  LoginController({required this.ref, required this.loginRepository});

  String getUsername() {
    return user.username;
  }

  String getPassword() {
    return user.password;
  }

  ResponseModel? getLoginResponse() {
    return _loginResponse;
  }

  void deleteResponse() {
    _loginResponse = null;
  }

  void setUsername(String username) {
    user.username = username;
  }

  void setPassword(String password) {
    user.password = password;
  }

  void loginUser() async {
    ref.read(_isLoadingProvider.notifier).state = true;
    _loginResponse = null;
    _loginResponse = await loginRepository.loginUserRepo(user);
    ref.read(_isLoadingProvider.notifier).state = false;
  }

  String? validateUsername(String? value) {
    if (value == null || value.length < 3) {
      return 'This field is required. Can\'t be shorter than 3 characters.';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Password is required. Can\'t be shorter than 8 characters.';
    } else {
      return null;
    }
  }
}

final loginControllerProvider = Provider((ref) {
  final loginRepository = ref.watch(loginRepositoryProvider);
  return LoginController(ref: ref, loginRepository: loginRepository);
});
