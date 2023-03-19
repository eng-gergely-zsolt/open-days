import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_response_model.dart';
import '../services/event_creator/create_event_service.dart';
import '../screens/event_creator/models/create_event_model.dart';

final eventCreatorRepositoryProvider = Provider((_) => EventCreatorRepository());

class EventCreatorRepository {
  Future<BaseResponseModel> createEventRepo(CreateEventModel payload) async {
    return await createEventSvc(payload);
  }
}
