import 'package:open_days_frontend/constants/constants.dart';
import 'package:open_days_frontend/modules/home_base/models/get_all_event_model.dart';

import '../../../models/user_response_model.dart';

class InitialDataModel {
  String operationResult;
  UserResponseModel? user;
  GetAllEventModel? events;

  InitialDataModel({this.operationResult = operationResultFailure});
}
