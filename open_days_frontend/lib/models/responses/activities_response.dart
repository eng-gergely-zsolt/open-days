import '../activity_model.dart';

class ActivitiesResponse {
  bool isOperationSuccessful;
  List<ActivityModel> activities = [];

  ActivitiesResponse({
    this.isOperationSuccessful = false,
  });
}
