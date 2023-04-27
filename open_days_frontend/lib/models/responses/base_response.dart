import './base_error_response.dart';

/// Contains only basic informations of a response from the server. Use this if no additional
/// information is needed from the server.
class BaseResponse {
  bool isOperationSuccessful = false;
  BaseErrorResponse error = BaseErrorResponse();

  BaseResponse({
    this.isOperationSuccessful = false,
  });
}
