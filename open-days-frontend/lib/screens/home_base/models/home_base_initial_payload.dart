import '../../../models/base_error.dart';
import '../../../models/responses/user_response.dart';
import '../../../models/responses/events_response.dart';

class HomeBaseInitialPayload {
  bool isOperationSuccessful;
  BaseError error = BaseError();
  UserResponse userResponse = UserResponse();
  EventsResponse eventsResponse = EventsResponse();

  HomeBaseInitialPayload({this.isOperationSuccessful = false});
}
