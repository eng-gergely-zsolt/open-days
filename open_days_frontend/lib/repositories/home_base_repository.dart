import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_request_model.dart';
import '../models/user_request_model.dart';
import '../models/user_response_model.dart';
import '../services/home_base/get-all-event.dart';
import '../services/home_base/get_user_by_id.dart';
import '../modules/home_base/models/get_all_event_model.dart';

final homeBaseRepositoryProvider = Provider((_) => HomeBaseRepository());

class HomeBaseRepository {
  Future<GetAllEventModel> getAllEventRepo(BaseRequestModel baseRequestData) async {
    await Future.delayed(const Duration(seconds: 3));
    return await getAllEventSvc(baseRequestData);
  }

  Future<UserResponseModel> getUserByIdRepo(UserRequestModel userRequestData) async {
    await Future.delayed(const Duration(seconds: 3));
    return await getUserByIdSvc(userRequestData);
  }
}
