import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/screens/registration/models/verify_email_by_otp_code_req.dart';

import '../../models/responses/base_response.dart';
import '../../repositories/registration_repository.dart';

class EmailVerificationController {
  final ProviderRef _ref;
  final RegistrationRepository _registrationRepository;
  final _isLoadingProvider = StateProvider<bool>((ref) => false);

  final _firstDigitProvider = StateProvider<String>((ref) => "");
  final _secondDigitProvider = StateProvider<String>((ref) => "");
  final _thirdDigitProvider = StateProvider<String>((ref) => "");
  final _fourthDigitProvider = StateProvider<String>((ref) => "");

  BaseResponse? _emailVerificationResponse;

  EmailVerificationController(this._ref, this._registrationRepository);

  StateProvider<bool> getIsLoadinProvider() {
    return _isLoadingProvider;
  }

  BaseResponse? getEmailVerificationResponse() {
    return _emailVerificationResponse;
  }

  StateProvider<String> getFirstDigitProvider() {
    return _firstDigitProvider;
  }

  StateProvider<String> getSecondDigitProvider() {
    return _secondDigitProvider;
  }

  StateProvider<String> getThirdDigitProvider() {
    return _thirdDigitProvider;
  }

  StateProvider<String> getFourthDigitProvider() {
    return _fourthDigitProvider;
  }

  void setFirstDigitProvider(String value) {
    _ref.read(_firstDigitProvider.notifier).state = value;
  }

  void setSecondDigitProvider(String value) {
    _ref.read(_secondDigitProvider.notifier).state = value;
  }

  void setThirdDigitProvider(String value) {
    _ref.read(_thirdDigitProvider.notifier).state = value;
  }

  void setFourthDigitProvider(String value) {
    _ref.read(_fourthDigitProvider.notifier).state = value;
  }

  void deleteEmailVerificationResponse() {
    _emailVerificationResponse = null;
  }

  bool isAllGigitGiven() {
    return _ref.read(_firstDigitProvider) != "" &&
        _ref.read(_secondDigitProvider) != "" &&
        _ref.read(_thirdDigitProvider) != "" &&
        _ref.read(_fourthDigitProvider) != "";
  }

  Future<bool> invalidateController() {
    _ref.invalidate(emailVerificationControllerProvider);
    return Future.value(true);
  }

  void verifyEmailByOtpCode(String email) async {
    _ref.read(_isLoadingProvider.notifier).state = true;

    VerifyEmailByOtpCodeReq payload = VerifyEmailByOtpCodeReq(email, getOtpCode());
    _emailVerificationResponse = await _registrationRepository.verifyEmailByOtpCodeRepo(payload);

    _ref.read(_isLoadingProvider.notifier).state = false;
  }

  int getOtpCode() {
    int firstDigit = int.parse(_ref.read(_firstDigitProvider)) * 1000;
    int secondDigit = int.parse(_ref.read(_secondDigitProvider)) * 100;
    int thirdDigit = int.parse(_ref.read(_thirdDigitProvider)) * 10;
    int fourthDigit = int.parse(_ref.read(_fourthDigitProvider));

    return firstDigit + secondDigit + thirdDigit + fourthDigit;
  }
}

final emailVerificationControllerProvider = Provider((ref) {
  final registrationRepository = ref.watch(registrationRepositoryProvider);
  return EmailVerificationController(ref, registrationRepository);
});
