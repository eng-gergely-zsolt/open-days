import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';
import '../models/responses/base_response.dart';
import '../services/event_creator/create_event_svc.dart';

final eventCreatorRepositoryProvider = Provider((_) => EventCreatorRepository());

class EventCreatorRepository {
  Future<BaseResponse> createEventRepo(Event event) async {
    return await createEventSvc(event);
  }
}
