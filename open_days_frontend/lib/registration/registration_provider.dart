import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/registration/models/institution.dart';
import 'package:open_days_frontend/repositories/registration_repository.dart';

final registrationRepository = RegistrationRepository();

final institutionFuture = FutureProvider<List<Institution>>((ref) async {
  return registrationRepository.getAllInstitutionRepo();
});

class RegistrationProvider with ChangeNotifier {
  bool loading = false;
  List<Institution> institutions = [];

  final registrationRepository = RegistrationRepository();
  final registrationProvider =
      ChangeNotifierProvider((ref) => RegistrationProvider());

  getAllInstitution() async {
    loading = true;
    institutions = await registrationRepository.getAllInstitutionRepo();
    loading = false;

    notifyListeners();
  }
}
