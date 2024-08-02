import '../activity.dart';
import '../base_error.dart';

class ActivitiesResponse {
  List<Activity> activities;
  bool isOperationSuccessful;
  BaseError error = BaseError();

  ActivitiesResponse({
    this.activities = const [],
    this.isOperationSuccessful = false,
  });
}
