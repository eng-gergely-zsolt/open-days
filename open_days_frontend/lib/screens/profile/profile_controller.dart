import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/shared/secure_storage.dart';

class ProfileController {
  final ProviderRef _ref;
  final _isClosingPageRequired = StateProvider<bool>(((ref) => false));
  final _isOperationInProgress = StateProvider<bool>(((ref) => false));

  ProfileController(this._ref);

  StateProvider<bool> getIsClosingPageRequired() {
    return _isClosingPageRequired;
  }

  StateProvider<bool> getIsOperationInProgress() {
    return _isOperationInProgress;
  }

  void setIsClosingPageRequired(bool newState) {
    _ref.read(_isClosingPageRequired.notifier).state = newState;
  }

  void setIsOperationInProgress(bool newState) {
    _ref.read(_isOperationInProgress.notifier).state = newState;
  }

  void logOut() async {
    setIsOperationInProgress(true);

    String? userId = await SecureStorage.getUserId();
    String? authorizationToken = await SecureStorage.getAuthorizationToken();

    if (userId != null) {
      await SecureStorage.deleteUserId();
    }

    if (authorizationToken != null) {
      await SecureStorage.deleteAuthorizationToken();
    }

    setIsClosingPageRequired(true);
  }
}

final profileControllerProvider = Provider((ref) {
  return ProfileController(ref);
});
