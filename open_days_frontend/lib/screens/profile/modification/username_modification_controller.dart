import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/secure_storage.dart';
import '../../../repositories/profile_repository.dart';
import '../../../models/responses/update_username_response.dart';

class UsernameModificationController {
  String? _username;
  UpdateUsernameResponse? _updateUsernameResponse;

  final ProviderRef _ref;
  final ProfileRepository _repository;
  final _isLoadingProvider = StateProvider<bool>((ref) => false);
  final _isConfirmAllowedProvider = StateProvider<bool>(((ref) => false));

  UsernameModificationController(this._ref, this._repository);

  String getUsername() {
    return _username ?? '';
  }

  StateProvider<bool> getLoadingProvider() {
    return _isLoadingProvider;
  }

  UpdateUsernameResponse? getUpdateUsernameResponse() {
    return _updateUsernameResponse;
  }

  StateProvider<bool> getConfirmAllowedProvider() {
    return _isConfirmAllowedProvider;
  }

  void setUsername(String username) {
    _username = username;
    _setConfirmAllowedProvider();
  }

  void setUsernameInitially(String username) {
    _username ??= username;
    _setConfirmAllowedProvider();
  }

  void deleteUpdateUsernameResponse() {
    _updateUsernameResponse = null;
  }

  void _setConfirmAllowedProvider() {
    if (_username == null || _username!.length < 3) {
      _ref.read(_isConfirmAllowedProvider.notifier).state = false;
    } else {
      _ref.read(_isConfirmAllowedProvider.notifier).state = true;
    }
  }

  void updateUsername(String id) async {
    _ref.read(_isLoadingProvider.notifier).state = true;

    if (_username != null) {
      _updateUsernameResponse = await _repository.updateUsernameRepo(id, _username.toString());
    }

    if (_updateUsernameResponse != null && _updateUsernameResponse?.authorizationToken != '') {
      await SecureStorage.setAuthorizationToken(_updateUsernameResponse!.authorizationToken);
    }

    _ref.read(_isLoadingProvider.notifier).state = false;
  }
}

final usernameModificationControllerProvider = Provider((ref) {
  final _profileRepository = ref.watch(profileRepositoryProvider);
  return UsernameModificationController(ref, _profileRepository);
});
