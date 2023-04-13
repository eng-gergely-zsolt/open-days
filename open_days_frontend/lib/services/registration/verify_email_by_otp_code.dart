import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/base_response.dart';
import '../../screens/registration/models/verify_email_by_otp_code_req.dart';

Future<BaseResponse> verifyEmailByOtpCodeSvc(VerifyEmailByOtpCodeReq payload) async {
  BaseResponse response;
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/users/email-verification-otp-code';

  // final rawResponse = await http
  //     .put(
  //       Uri.parse(uri),
  //       body: jsonEncode(payload),
  //     )
  //     .timeout(const Duration(seconds: 10));

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  final v = jsonEncode(<String, Object?>{
    'email': payload.getEmail(),
    'otpCode': payload.getOtpCode(),
  });

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
    response = BaseResponse.fromJson(responseMap);
  } else {
    response = BaseResponse();
  }

  return response;
}
