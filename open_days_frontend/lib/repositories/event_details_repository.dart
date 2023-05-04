import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/base_response.dart';
import '../models/responses/base_logical_response.dart';
import '../services/event_details/enroll_user_svc.dart';
import '../services/event_details/unenroll_user_svc.dart';
import '../services/event_details/is_user_enrolled_svc.dart';

final eventDetailsRepositoryProvider = Provider((_) => EventDetailsRepository());

class EventDetailsRepository {
  Future<BaseResponse> enrollUserRepo(int eventId) async {
    return await enrollUserSvc(eventId);
  }

  Future<BaseResponse> unenrollUserRepo(int eventId) async {
    return await unenrollUserSvc(eventId);
  }

  Future<BaseLogicalResponse> isUserEnrolledRepo(int eventId) async {
    return await isUserEnrolledSvc(eventId);
  }
}
