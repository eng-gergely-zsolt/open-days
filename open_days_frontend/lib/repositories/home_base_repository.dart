import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/models/base_request_model.dart';
import 'package:open_days_frontend/models/user_request_model.dart';
import 'package:open_days_frontend/models/user_response_model.dart';
import 'package:open_days_frontend/modules/home_base/models/get_all_event_model.dart';
import 'package:open_days_frontend/services/home_base/get-all-event.dart';
import 'package:open_days_frontend/services/home_base/get_user_by_id.dart';

final homeBaseRepositoryProvider = Provider((_) => HomeBaseRepository());

class HomeBaseRepository {
  Future<UserResponseModel> getUserByIdRepo(
      UserRequestModel userRequestData) async {
    await Future.delayed(const Duration(seconds: 3));
    return await getUserByIdSvc(userRequestData);
  }

  Future<GetAllEventModel> getAllEventRepo(
      BaseRequestModel baseRequestData) async {
    await Future.delayed(const Duration(seconds: 3));
    return await getAllEventSvc(baseRequestData);
  }
}
