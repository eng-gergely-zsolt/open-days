import 'event_response_model.dart';
import '../../../constants/constants.dart';

class GetAllEventModel {
  String operationResult;
  List<EventResponseModel> events;

  GetAllEventModel({
    this.events = const [],
    this.operationResult = operationResultFailure,
  });
}
