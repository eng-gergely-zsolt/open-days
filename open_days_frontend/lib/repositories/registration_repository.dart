import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/base_response.dart';
import '../models/requests/create_user_request.dart';
import '../services/registration/create_user_svc.dart';
import '../services/registration/verify_email_by_otp_code_svc.dart';

final registrationRepositoryProvider = Provider((_) => RegistrationRepository());

abstract class IRegistrationRepository {
  Future<BaseResponse> createUserRepo(CreateUserRequest user);
  Future<BaseResponse> verifyEmailByOtpCodeRepo(int otpCode, String email);
}

class RegistrationRepository extends IRegistrationRepository {
  @override
  Future<BaseResponse> createUserRepo(CreateUserRequest user) async {
    return await createUserSvc(user);
  }

  @override
  Future<BaseResponse> verifyEmailByOtpCodeRepo(int otpCode, String email) async {
    return await verifyEmailByOtpCodeSvc(otpCode, email);
  }
}
