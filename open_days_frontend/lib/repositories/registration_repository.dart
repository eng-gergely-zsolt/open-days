import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/models/user_response_model.dart';
import 'package:open_days_frontend/modules/registration/models/institution.dart';
import 'package:open_days_frontend/modules/registration/models/user.dart';
import 'package:open_days_frontend/services/registration/get_all_institution.dart';

import '../services/registration/create_user.dart';

final registrationRepositoryProvider =
    Provider((_) => RegistrationRepository());

abstract class IRegistrationRepository {
  Future<UserResponseModel> createUserRepo(User user);
  Future<List<Institution>> getAllInstitutionRepo();
}

class RegistrationRepository extends IRegistrationRepository {
  @override
  Future<UserResponseModel> createUserRepo(User user) async {
    await Future.delayed(const Duration(seconds: 3));
    return await createUserSvc(user);
  }

  @override
  Future<List<Institution>> getAllInstitutionRepo() async {
    await Future.delayed(const Duration(seconds: 3));
    return await getAllInstitutionSvc();
  }
}
