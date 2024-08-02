import '../user.dart';
import '../base_error.dart';

class UsersResponse {
  List<User> users;
  bool isOperationSuccessful;
  BaseError error = BaseError();

  UsersResponse({
    this.users = const [],
    this.isOperationSuccessful = false,
  });
}
