import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/secure_storage.dart';
import '../../repositories/login_repository.dart';
import '../../models/requests/login_user_request.dart';
import '../../models/responses/login_user_response.dart';

class LoginController {
  LoginUserResponse? _loginUserResponse;

  final ProviderRef _ref;
  final LoginRepository _loginRepository;

  final _user = LoginUserRequest();
  final _isLoadingProvider = StateProvider<bool>((ref) => false);

  LoginController(this._ref, this._loginRepository);

  String getUsername() {
    return _user.username;
  }

  String getPassword() {
    return _user.password;
  }

  LoginUserResponse? getLoginUserResponse() {
    return _loginUserResponse;
  }

  StateProvider<bool> getIsLoadinProvider() {
    return _isLoadingProvider;
  }

  void setUsername(String username) {
    _user.username = username;
  }

  void setPassword(String password) {
    _user.password = password;
  }

  void deleteResponse() {
    _loginUserResponse = null;
  }

  void invalidateControllerProvider() {
    _ref.invalidate(loginControllerProvider);
  }

  void loginUser() async {
    _ref.read(_isLoadingProvider.notifier).state = true;
    _loginUserResponse = null;
    _loginUserResponse = await _loginRepository.loginUserRepo(_user);

    if (_loginUserResponse != null && _loginUserResponse!.isOperationSuccessful) {
      await SecureStorage.setUserId(_loginUserResponse?.id as String);
      await SecureStorage.setAuthorizationToken(_loginUserResponse?.authorizationToken as String);
    }

    _ref.read(_isLoadingProvider.notifier).state = false;
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
  return LoginController(ref, loginRepository);
});
