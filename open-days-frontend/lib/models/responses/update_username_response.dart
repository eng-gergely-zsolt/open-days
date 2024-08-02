import '../base_error.dart';

class UpdateUsernameResponse {
  String authorizationToken;
  bool isOperationSuccessful;
  BaseError error = BaseError();

  UpdateUsernameResponse({
    this.authorizationToken = '',
    this.isOperationSuccessful = false,
  });
}
