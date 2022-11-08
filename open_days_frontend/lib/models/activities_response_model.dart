import 'activity_model.dart';

class ActivitiesResponseModel {
  bool isOperationSuccessful;
  List<ActivityModel> activities = [];

  ActivitiesResponseModel({
    this.isOperationSuccessful = false,
  });
}
