import './base_error_response.dart';

class UpdateUsernameResponse {
  String authorizationToken;
  bool isOperationSuccessful;
  BaseErrorResponse error = BaseErrorResponse();

  UpdateUsernameResponse({
    this.authorizationToken = '',
    this.isOperationSuccessful = false,
  });
}
