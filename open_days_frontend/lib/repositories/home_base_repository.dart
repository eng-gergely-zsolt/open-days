import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_response_model.dart';
import '../services/home_base/get_all_event.dart';
import '../services/home_base/get_user_by_id.dart';
import '../screens/home_base/models/get_all_event_model.dart';

final homeBaseRepositoryProvider = Provider((_) => HomeBaseRepository());

class HomeBaseRepository {
  GetAllEventModel _savedEvents = GetAllEventModel();
  UserResponseModel _savedUser = UserResponseModel();

  UserResponseModel getSavedUser() {
    return _savedUser;
  }

  GetAllEventModel getSavedEventsRepo() {
    return _savedEvents;
  }

  Future<GetAllEventModel> getAllEventRepo() async {
    _savedEvents = await getAllEventSvc();
    return _savedEvents;
  }

  Future<UserResponseModel> getUserByIdRepo() async {
    _savedUser = await getUserByIdSvc();
    return _savedUser;
  }
}
