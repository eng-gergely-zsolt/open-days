import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/responses/base_response.dart';
import '../../../repositories/profile_repository.dart';

class NameModificationController {
  String? _lastName;
  String? _firstName;
  BaseResponse? _updateNameResponse;

  final ProviderRef _ref;
  final ProfileRepository _repository;
  final _isLoadingProvider = StateProvider<bool>((ref) => false);
  final _isConfirmAllowedProvider = StateProvider<bool>(((ref) => false));

  NameModificationController(this._ref, this._repository);

  String getLastName() {
    return _lastName ?? '';
  }

  String getFirstName() {
    return _firstName ?? '';
  }

  BaseResponse? getUpdateNameResponse() {
    return _updateNameResponse;
  }

  StateProvider<bool> getLoadingProvider() {
    return _isLoadingProvider;
  }

  StateProvider<bool> getConfirmAllowedProvider() {
    return _isConfirmAllowedProvider;
  }

  void setLastName(String? lastName) {
    _lastName = lastName;
    _setConfirmAllowedProvider();
  }

  void setFirstName(String? firstName) {
    _firstName = firstName;
    _setConfirmAllowedProvider();
  }

  void deleteUpdateNameResponse() {
    _updateNameResponse = null;
  }

  void setNamesInitially(String lastName, String firstName) {
    _lastName ??= lastName;
    _firstName ??= firstName;
    _setConfirmAllowedProvider();
  }

  void _setConfirmAllowedProvider() {
    if (_lastName == null ||
        _lastName!.length < 3 ||
        _firstName == null ||
        _firstName!.length < 3) {
      _ref.read(_isConfirmAllowedProvider.notifier).state = false;
    } else {
      _ref.read(_isConfirmAllowedProvider.notifier).state = true;
    }
  }

  void updateName(String id) async {
    _ref.read(_isLoadingProvider.notifier).state = true;

    if (_lastName != null && _firstName != null) {
      _updateNameResponse =
          await _repository.updateNameRepo(id, _lastName.toString(), _firstName.toString());
    }

    _ref.read(_isLoadingProvider.notifier).state = false;
  }
}

final nameModificationControllerProvider = Provider((ref) {
  final _profileRepository = ref.watch(profileRepositoryProvider);
  return NameModificationController(ref, _profileRepository);
});
