import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_response.dart';
import '../models/user_response_model.dart';
import '../screens/registration/models/user.dart';
import '../services/registration/create_user.dart';
import '../screens/registration/models/institution.dart';
import '../services/registration/get_all_institution.dart';
import '../services/registration/verify_email_by_otp_code.dart';
import '../screens/registration/models/verify_email_by_otp_code_req.dart';

final registrationRepositoryProvider = Provider((_) => RegistrationRepository());

abstract class IRegistrationRepository {
  Future<List<Institution>> getAllInstitutionRepo();
  Future<UserResponseModel> createUserRepo(User user);
  Future<BaseResponse> verifyEmailByOtpCodeRepo(VerifyEmailByOtpCodeReq payload);
}

class RegistrationRepository extends IRegistrationRepository {
  @override
  Future<List<Institution>> getAllInstitutionRepo() async {
    return await getAllInstitutionSvc();
  }

  @override
  Future<UserResponseModel> createUserRepo(User user) async {
    return await createUserSvc(user);
  }

  @override
  Future<BaseResponse> verifyEmailByOtpCodeRepo(VerifyEmailByOtpCodeReq payload) async {
    return await verifyEmailByOtpCodeSvc(payload);
  }
}
