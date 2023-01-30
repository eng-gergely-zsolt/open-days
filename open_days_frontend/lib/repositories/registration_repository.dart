import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_response_model.dart';
import '../screens/registration/models/user.dart';
import '../services/registration/create_user.dart';
import '../screens/registration/models/institution.dart';
import '../services/registration/get_all_institution.dart';

final registrationRepositoryProvider = Provider((_) => RegistrationRepository());

abstract class IRegistrationRepository {
  Future<UserResponseModel> createUserRepo(User user);
  Future<List<Institution>> getAllInstitutionRepo();
}

class RegistrationRepository extends IRegistrationRepository {
  @override
  Future<List<Institution>> getAllInstitutionRepo() async {
    await Future.delayed(const Duration(seconds: 3));
    return await getAllInstitutionSvc();
  }

  @override
  Future<UserResponseModel> createUserRepo(User user) async {
    await Future.delayed(const Duration(seconds: 3));
    return await createUserSvc(user);
  }
}
