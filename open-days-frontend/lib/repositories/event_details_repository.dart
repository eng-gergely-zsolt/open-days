import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/base_response.dart';
import '../models/responses/users_response.dart';
import '../models/responses/base_logical_response.dart';
import '../services/event_details/enroll_user_svc.dart';
import '../services/event_details/unenroll_user_svc.dart';
import '../services/event_details/is_user_enrolled_svc.dart';
import '../services/event_details/get_enrolled_users_svc.dart';
import '../services/event_details/get_participated_users_svc.dart';

final eventDetailsRepositoryProvider = Provider((_) => EventDetailsRepository());

class EventDetailsRepository {
  Future<BaseResponse> enrollUserRepo(int eventId) async {
    return await enrollUserSvc(eventId);
  }

  Future<BaseResponse> unenrollUserRepo(int eventId) async {
    return await unenrollUserSvc(eventId);
  }

  Future<UsersResponse> getEnrolledUsersRepo(int eventId) async {
    return await getEnrolledUsersSvc(eventId);
  }

  Future<UsersResponse> getParticipatedUsersRepo(int eventId) async {
    return await getParticipatedUsersSvc(eventId);
  }

  Future<BaseLogicalResponse> isUserEnrolledRepo(int eventId) async {
    return await isUserEnrolledSvc(eventId);
  }
}
