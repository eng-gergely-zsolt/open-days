import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/base_response.dart';
import '../models/event_modification_request.dart';
import '../services/event_modification/put_update_event.dart';

final eventModificationRepositoryProvider = Provider((_) => EventModificationRepository());

class EventModificationRepository {
  Future<BaseResponse> updateEventRepo(
      int eventId, EventModificationRequest updateEventPayload) async {
    return await updateEventSvc(eventId, updateEventPayload);
  }
}
