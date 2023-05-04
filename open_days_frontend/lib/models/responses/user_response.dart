import '../user.dart';
import '../base_error.dart';

class UserResponse {
  User user = User();
  bool isOperationSuccessful;
  BaseError error = BaseError();

  UserResponse({
    this.isOperationSuccessful = false,
  });
}
