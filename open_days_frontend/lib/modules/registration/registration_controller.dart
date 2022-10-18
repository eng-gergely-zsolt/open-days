import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/models/user_response_model.dart';
import 'package:open_days_frontend/modules/registration/models/user.dart';
import 'package:open_days_frontend/repositories/registration_repository.dart';
import 'package:open_days_frontend/modules/registration/models/institution.dart';

class RegistrationController {
  UserResponseModel? _registrationResponse;

  final ProviderRef ref;
  final RegistrationRepository registrationRepository;

  final User _user = User();
  final _isLoadingProvider = StateProvider<bool>((ref) => false);
  final _selectedCountyProvider = StateProvider<String?>((ref) => null);
  final _selectedInstitutionProvider = StateProvider<String?>((ref) => null);

  final _institutionProvider = FutureProvider((ref) async {
    final registrationRepository = ref.watch(registrationRepositoryProvider);
    return registrationRepository.getAllInstitutionRepo();
  });

  RegistrationController({
    required this.ref,
    required this.registrationRepository,
  });

  User getUser() {
    return _user;
  }

  UserResponseModel? getRegistrationResponse() {
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

  FutureProvider<List<Institution>> getInstitutionProvider() {
    return _institutionProvider;
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

  void setInstitution(String? institution) {
    if (institution != null) {
      _user.institution = institution;
    }
  }

  void deleteRegistrationResponse() {
    _registrationResponse = null;
  }

  createUser() async {
    ref.read(_isLoadingProvider.notifier).state = true;
    _registrationResponse = await registrationRepository.createUserRepo(_user);
    ref.read(_isLoadingProvider.notifier).state = false;
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

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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

  List<String> getCounties(List<Institution> institutions) {
    List<String> countyNames = [];

    for (Institution it in institutions) {
      if (!countyNames.contains(it.countyName)) {
        countyNames.add(it.countyName);
      }
    }

    countyNames.sort();
    return countyNames;
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

  List<String> getInstitutions(
      String? selectedCounty, List<Institution> institutions) {
    List<String> institutionNames = [];

    for (Institution it in institutions) {
      if (it.countyName == selectedCounty &&
          !institutionNames.contains(it.institutionName)) {
        institutionNames.add(it.institutionName);
      }
    }

    institutionNames.sort();
    return institutionNames;
  }

  String getFirstInstitution(
      String? selectedCounty, List<Institution> institutions) {
    List<String> institutionNames = [];

    for (Institution it in institutions) {
      if (it.countyName == selectedCounty &&
          !institutionNames.contains(it.institutionName)) {
        institutionNames.add(it.institutionName);
      }
    }

    institutionNames.sort();
    return institutionNames.isNotEmpty ? institutionNames[0] : "";
  }
}

final registrationControllerProvider = Provider((ref) {
  final registrationRepository = ref.watch(registrationRepositoryProvider);
  return RegistrationController(
      ref: ref, registrationRepository: registrationRepository);
});
