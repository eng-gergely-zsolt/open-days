import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/base_response.dart';
import '../screens/registration/models/user.dart';
import '../services/registration/create_user.dart';
import '../models/responses/user_login_response.dart';
import '../services/registration/verify_email_by_otp_code.dart';
import '../screens/registration/models/verify_email_by_otp_code_req.dart';

final registrationRepositoryProvider = Provider((_) => RegistrationRepository());

abstract class IRegistrationRepository {
  Future<UserLoginResponse> createUserRepo(User user);
  Future<BaseResponse> verifyEmailByOtpCodeRepo(VerifyEmailByOtpCodeReq payload);
}

class RegistrationRepository extends IRegistrationRepository {
  @override
  Future<UserLoginResponse> createUserRepo(User user) async {
    return await createUserSvc(user);
  }

  @override
  Future<BaseResponse> verifyEmailByOtpCodeRepo(VerifyEmailByOtpCodeReq payload) async {
    return await verifyEmailByOtpCodeSvc(payload);
  }
}
