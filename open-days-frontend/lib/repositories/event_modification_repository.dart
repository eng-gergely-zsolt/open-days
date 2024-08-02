import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/base_response.dart';
import '../models/requests/update_event_request.dart';
import '../services/event_modification/update_event_svc.dart';

final eventModificationRepositoryProvider = Provider((_) => EventModificationRepository());

class EventModificationRepository {
  Future<BaseResponse> updateEventRepo(int eventId, UpdateEventRequest updateEventPayload) async {
    return await updateEventSvc(eventId, updateEventPayload);
  }
}
