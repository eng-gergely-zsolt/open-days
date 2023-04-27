import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/user_response.dart';
import '../services/home_base/get_all_event.dart';
import '../services/home_base/get_user_by_id.dart';
import '../screens/home_base/models/get_all_event_model.dart';

final homeBaseRepositoryProvider = Provider((_) => HomeBaseRepository());

class HomeBaseRepository {
  UserResponse _savedUser = UserResponse();
  GetAllEventModel _savedEvents = GetAllEventModel();

  UserResponse getSavedUser() {
    return _savedUser;
  }

  GetAllEventModel getSavedEventsRepo() {
    return _savedEvents;
  }

  Future<UserResponse> getUserByIdRepo() async {
    _savedUser = await getUserByIdSvc();
    return _savedUser;
  }

  Future<GetAllEventModel> getAllEventRepo() async {
    _savedEvents = await getAllEventSvc();
    return _savedEvents;
  }
}
