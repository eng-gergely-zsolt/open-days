import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/user_response.dart';
import '../models/responses/events_response.dart';
import '../services/home_base/get_user_by_id_svc.dart';
import '../services/home_base/get_events_conform_to_user_role_svc.dart';

final homeBaseRepositoryProvider = Provider((_) => HomeBaseRepository());

class HomeBaseRepository {
  UserResponse _savedUser = UserResponse();
  EventsResponse _savedEvents = EventsResponse();

  UserResponse getSavedUser() {
    return _savedUser;
  }

  EventsResponse getSavedEventsRepo() {
    return _savedEvents;
  }

  Future<UserResponse> getUserByIdRepo() async {
    _savedUser = await getUserByIdSvc();
    return _savedUser;
  }

  Future<EventsResponse> getEventsConformToUserRoleRepo() async {
    _savedEvents = await getEventsConformToUserRoleSvc();
    return _savedEvents;
  }
}
