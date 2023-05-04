import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../error/error_codes.dart';
import '../../models/base_error.dart';
import '../../models/institution.dart';
import '../../error/error_messages.dart';
import '../../models/responses/institution_response.dart';

Future<InstitutionsResponse> getInstitutionsSvc() async {
  InstitutionsResponse response = InstitutionsResponse();
  const uri = 'https://open-days-thesis.herokuapp.com/open-days/institution/institutions';

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  try {
    Iterable decodedBody;
    final rawResponse = await http
        .get(
          Uri.parse(uri),
          headers: headers,
        )
        .timeout(const Duration(seconds: 10));

    if (rawResponse.statusCode == 200) {
      response.isOperationSuccessful = true;
      decodedBody = jsonDecode(rawResponse.body);
      response.institutions = decodedBody.map((e) => Institution.fromJson(e)).toList();
    } else if (rawResponse.statusCode == 500) {
      response.error = BaseError.fromJson(jsonDecode(rawResponse.body));
    } else {
      response.error.errorCode = baseErrorCode;
      response.error.errorMessage = baseErrorMessage;
    }
  } on TimeoutException catch (_) {
    response.error.errorCode = timeoutExceptionCode;
    response.error.errorMessage = timeoutExceptionMessage;
  } on Exception catch (error) {
    response.error.errorCode = baseErrorCode;
    response.error.errorMessage = error.toString();
  }

  return response;
}
