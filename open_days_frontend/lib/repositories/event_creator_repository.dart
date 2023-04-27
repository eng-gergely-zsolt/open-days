import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/base_response.dart';
import '../services/event_creator/create_event_service.dart';
import '../screens/event_creator/models/create_event_model.dart';

final eventCreatorRepositoryProvider = Provider((_) => EventCreatorRepository());

class EventCreatorRepository {
  Future<BaseResponse> createEventRepo(CreateEventModel payload) async {
    return await createEventSvc(payload);
  }
}
