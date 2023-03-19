import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_response_model.dart';
import '../models/event_modification_request.dart';
import '../services/event_modification/put_update_event.dart';

final eventModificationRepositoryProvider = Provider((_) => EventModificationRepository());

class EventModificationRepository {
  Future<BaseResponseModel> updateEventRepo(
      int eventId, EventModificationRequest updateEventPayload) async {
    return await updateEventSvc(eventId, updateEventPayload);
  }
}
