import '../base_error.dart';

class LoginUserResponse {
  String id;
  String authorizationToken;
  bool isOperationSuccessful;
  BaseError error = BaseError();

  LoginUserResponse({
    this.id = '',
    this.authorizationToken = '',
    this.isOperationSuccessful = false,
  });
}
