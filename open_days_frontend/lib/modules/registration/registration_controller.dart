import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/models/response_model.dart';
import 'package:open_days_frontend/modules/registration/models/user.dart';
import 'package:open_days_frontend/repositories/registration_repository.dart';
import 'package:open_days_frontend/modules/registration/models/institution.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);

final institutionProvider = FutureProvider((ref) async {
  final registrationRepository = ref.watch(registrationRepositoryProvider);
  return registrationRepository.getAllInstitutionRepo();
});

final createUserProvider =
    FutureProvider.family<ResponseModel, User>((ref, user) async {
  return ref.watch(registrationRepositoryProvider).createUserRepo(user);
});

final registrationControllerProvider = Provider((ref) {
  final registrationRepository = ref.watch(registrationRepositoryProvider);
  return RegistrationController(
      ref: ref, registrationRepository: registrationRepository);
});

class RegistrationController {
  final ProviderRef ref;
  final User user = User();
  final RegistrationRepository registrationRepository;

  ResponseModel? response;

  RegistrationController(
      {required this.ref, required this.registrationRepository});

  refreshInstitutionListByCountyName(String countyName) {
    ref.refresh(institutionProvider);
  }

  ResponseModel? getResponse() {
    return response;
  }

  User getUser() {
    return user;
  }

  void setEmail(String email) {
    user.email = email;
  }

  void setPassword(String password) {
    user.password = password;
  }

  void setUsername(String username) {
    user.username = username;
  }

  void setLastName(String lastName) {
    user.lastName = lastName;
  }

  void setFirstName(String firstName) {
    user.firstName = firstName;
  }

  void setInstitution(String? institution) {
    if (institution != null) {
      user.institution = institution;
    }
  }

  createUser() async {
    response = null;
    ref.read(isLoadingProvider.notifier).state = true;
    response = await registrationRepository.createUserRepo(user);
    ref.read(isLoadingProvider.notifier).state = false;
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

  List<String> getInstituions(
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
