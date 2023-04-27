import './get_all_event_model.dart';
import '../../../constants/constants.dart';
import '../../../models/responses/user_response.dart';

class InitialDataModel {
  String operationResult;
  UserResponse user = UserResponse();
  GetAllEventModel? events;

  InitialDataModel({this.operationResult = operationResultFailure});
}
