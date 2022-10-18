import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/constants/constants.dart';
import 'package:open_days_frontend/models/user_response_model.dart';
import 'package:open_days_frontend/models/user_request_model.dart';
import 'package:open_days_frontend/shared/secure_storage.dart';

import '../../repositories/login_repository.dart';

class LoginController {
  UserResponseModel? _loginResponse;

  final ProviderRef ref;
  final LoginRepository loginRepository;

  final UserRequestModel user = UserRequestModel();
  final _isLoadingProvider = StateProvider<bool>((ref) => false);

  LoginController({
    required this.ref,
    required this.loginRepository,
  });

  String getUsername() {
    return user.username;
  }

  String getPassword() {
    return user.password;
  }

  UserResponseModel? getLoginResponse() {
    return _loginResponse;
  }

  StateProvider<bool> getIsLoadinProvider() {
    return _isLoadingProvider;
  }

  void setUsername(String username) {
    user.username = username;
  }

  void setPassword(String password) {
    user.password = password;
  }

  void deleteResponse() {
    _loginResponse = null;
  }

  void loginUser() async {
    ref.read(_isLoadingProvider.notifier).state = true;
    _loginResponse = null;
    _loginResponse = await loginRepository.loginUserRepo(user);

    if (_loginResponse != null &&
        _loginResponse?.operationResult == operationResultSuccess) {
      await SecureStorage.setUserId(_loginResponse?.id as String);
      await SecureStorage.setAuthorizationToken(
          _loginResponse?.bearer as String);
    }

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
