import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_response_model.dart';
import '../services/event_details/delete_user_from_event.dart';
import '../services/event_details/post_apply_user_for_event.dart';
import '../services/event_details/get_is_user_applied_to_event.dart';
import '../screens/event_details/models/is_user_applied_for_event.dart';

final eventDetailsRepositoryProvider = Provider((_) => EventDetailsRepository());

class EventDetailsRepository {
  Future<BaseResponseModel> applyUserForEventRepo(int eventId) async {
    return await applyUserForEventSvc(eventId);
  }

  Future<BaseResponseModel> deleteUserFromEventRepo(int eventId) async {
    return await deleteUserFromEventSvc(eventId);
  }

  Future<IsUserAppliedForEvent> isUserAppliedForEventRepo(int eventId) async {
    return await isUserAppliedForEventSvc(eventId);
  }
}
