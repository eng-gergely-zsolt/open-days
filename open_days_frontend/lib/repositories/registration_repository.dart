import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/models/response_model.dart';
import 'package:open_days_frontend/modules/registration/models/institution.dart';
import 'package:open_days_frontend/modules/registration/models/user.dart';
import 'package:open_days_frontend/services/registration/get_all_institution.dart';

import '../services/registration/create_user.dart';

final registrationRepositoryProvider =
    Provider((_) => RegistrationRepository());

abstract class IRegistrationRepository {
  Future<ResponseModel> createUserRepo(User user);
  Future<List<Institution>> getAllInstitutionRepo();
}

class RegistrationRepository extends IRegistrationRepository {
  @override
  Future<ResponseModel> createUserRepo(User user) async {
    return await createUserSvc(user);
  }

  @override
  Future<List<Institution>> getAllInstitutionRepo() async {
    return await getAllInstitutionSvc();
  }
}
