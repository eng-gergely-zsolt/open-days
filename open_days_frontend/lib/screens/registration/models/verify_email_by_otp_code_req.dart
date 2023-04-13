class VerifyEmailByOtpCodeReq {
  int _otpCode;
  String _email;

  int getOtpCode() {
    return _otpCode;
  }

  String getEmail() {
    return _email;
  }

  void setOtpCode(int otpCode) {
    _otpCode = otpCode;
  }

  void setEmail(String email) {
    _email = email;
  }

  VerifyEmailByOtpCodeReq(this._email, this._otpCode);

  Map<String, dynamic> toJson() => {
        'email': _email,
        'otpCode': _otpCode,
      };
}
