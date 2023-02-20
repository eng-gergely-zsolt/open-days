import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/base_response_model.dart';
import '../domain/models/event_modification_request.dart';
import '../services/event_modification/put_update_event.dart';

final eventModificationRepositoryProvider = Provider((_) => EventModificationRepository());

class EventModificationRepository {
  Future<BaseResponseModel> updateEventRepo(
      int eventId, EventModificationRequest updateEventPayload) async {
    await Future.delayed(const Duration(seconds: 3));
    return await updateEventSvc(eventId, updateEventPayload);
  }
}
