import 'package:open_days_frontend/constants/constants.dart';
import 'package:open_days_frontend/models/event_response_model.dart';

class GetAllEventModel {
  String operationResult;
  List<EventResponseModel> events;

  GetAllEventModel({
    this.events = const [],
    this.operationResult = operationResultFailure,
  });
}
