import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../shared/secure_storage.dart';
import '../../repositories/login_repository.dart';
import '../../models/requests/user_request_model.dart';
import '../../models/responses/user_login_response.dart';

class LoginController {
  UserLoginResponse? _loginResponse;

  final ProviderRef _ref;
  final LoginRepository _loginRepository;

  final _user = UserRequestModel();
  final _isLoadingProvider = StateProvider<bool>((ref) => false);

  LoginController(this._ref, this._loginRepository);

  String getUsername() {
    return _user.username;
  }

  String getPassword() {
    return _user.password;
  }

  UserLoginResponse? getLoginResponse() {
    return _loginResponse;
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
    _loginResponse = null;
  }

  void loginUser() async {
    _ref.read(_isLoadingProvider.notifier).state = true;
    _loginResponse = null;
    _loginResponse = await _loginRepository.loginUserRepo(_user);

    if (_loginResponse != null && _loginResponse?.operationResult == operationResultSuccess) {
      await SecureStorage.setUserId(_loginResponse?.id as String);
      await SecureStorage.setAuthorizationToken(_loginResponse?.authorizationToken as String);
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
