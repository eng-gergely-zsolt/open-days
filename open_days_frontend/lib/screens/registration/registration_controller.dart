import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/institution.dart';
import '../../repositories/base_repository.dart';
import '../../models/responses/base_response.dart';
import '../../models/requests/create_user_request.dart';
import '../../repositories/registration_repository.dart';
import '../../models/responses/institution_response.dart';

class RegistrationController {
  BaseResponse? _registrationResponse;

  final ProviderRef _ref;
  final RegistrationRepository _registrationRepository;

  final _user = CreateUserRequest();
  final _isLoadingProvider = StateProvider<bool>((ref) => false);
  final _selectedCountyProvider = StateProvider<String?>((ref) => null);
  final _selectedInstitutionProvider = StateProvider<String?>((ref) => null);

  final _institutionsProvider = FutureProvider((ref) async {
    final baseRepository = ref.watch(baseRepositoryProvider);
    return baseRepository.getInstitutionsRepo();
  });

  RegistrationController(this._ref, this._registrationRepository);

  CreateUserRequest getUser() {
    return _user;
  }

  String getEmail() {
    return _user.email;
  }

  BaseResponse? getRegistrationResponse() {
    return _registrationResponse;
  }

  StateProvider<bool> getIsLoadingProvider() {
    return _isLoadingProvider;
  }

  StateProvider<String?> getSelectedCountyProvider() {
    return _selectedCountyProvider;
  }

  StateProvider<String?> getSelectedInstitutionProvider() {
    return _selectedInstitutionProvider;
  }

  FutureProvider<InstitutionsResponse> getInstitutionsProvider() {
    return _institutionsProvider;
  }

  void setEmail(String email) {
    _user.email = email;
  }

  void setPassword(String password) {
    _user.password = password;
  }

  void setUsername(String username) {
    _user.username = username;
  }

  void setLastName(String lastName) {
    _user.lastName = lastName;
  }

  void setFirstName(String firstName) {
    _user.firstName = firstName;
  }

  void setInstitutionName(String? institutionName) {
    if (institutionName != null) {
      _user.institutionName = institutionName;
    }
  }

  void deleteRegistrationResponse() {
    _registrationResponse = null;
  }

  void invalidateControllerProvider() {
    _ref.invalidate(registrationControllerProvider);
  }

  createUser() async {
    _ref.read(_isLoadingProvider.notifier).state = true;
    _registrationResponse = await _registrationRepository.createUserRepo(_user);
    _ref.read(_isLoadingProvider.notifier).state = false;
  }

  String? validateName(String? value) {
    if (value == null || value.length < 3) {
      return 'This field is required. Can\'t be shorter than 3 characters.';
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'An email address is required.';
    }

    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);

    if (!emailValid) {
      return 'This email address is not valid';
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

  String getFirstCounty(List<Institution> institutions) {
    List<String> countyNames = [];

    for (Institution it in institutions) {
      if (!countyNames.contains(it.countyName)) {
        countyNames.add(it.countyName);
      }
    }

    countyNames.sort();
    return countyNames.isNotEmpty ? countyNames[0] : "";
  }
}

final registrationControllerProvider = Provider((ref) {
  final registrationRepository = ref.watch(registrationRepositoryProvider);
  return RegistrationController(ref, registrationRepository);
});
