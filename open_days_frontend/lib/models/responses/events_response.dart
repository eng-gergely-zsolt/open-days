import '../event.dart';
import '../base_error.dart';

class EventsResponse {
  List<Event> events;
  bool isOperationSuccessful;
  BaseError error = BaseError();

  EventsResponse({
    this.events = const [],
    this.isOperationSuccessful = false,
  });
}
