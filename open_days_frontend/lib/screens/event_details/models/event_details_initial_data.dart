import '../../../models/base_error.dart';
import '../../../models/responses/users_response.dart';
import '../../../models/responses/base_logical_response.dart';

class EventDetailsInitialData {
  bool isOperationSuccessful;
  BaseError error = BaseError();
  UsersResponse usersResponse = UsersResponse();
  BaseLogicalResponse isUserEnrolledResponse = BaseLogicalResponse();

  EventDetailsInitialData({
    this.isOperationSuccessful = false,
  });
}
