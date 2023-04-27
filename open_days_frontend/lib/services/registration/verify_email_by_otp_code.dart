import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/responses/base_response.dart';
import '../../models/responses/base_error_response.dart';
import '../../screens/registration/models/verify_email_by_otp_code_req.dart';

Future<BaseResponse> verifyEmailByOtpCodeSvc(VerifyEmailByOtpCodeReq payload) async {
  BaseResponse response = BaseResponse();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/users/email-verification-otp-code';

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  final rawResponse = await http
      .put(
        Uri.parse(uri),
        headers: headers,
        body: jsonEncode(<String, Object?>{
          'email': payload.getEmail(),
          'otpCode': payload.getOtpCode(),
        }),
      )
      .timeout(const Duration(seconds: 10));

  if (rawResponse.statusCode == 200) {
    response = BaseResponse();
    response.isOperationSuccessful = true;
  } else if (rawResponse.statusCode == 500) {
    Map<String, dynamic> responseMap = jsonDecode(rawResponse.body);
    response.error = BaseErrorResponse.fromJson(responseMap);
  } else {
    response = BaseResponse();
  }

  return response;
}
