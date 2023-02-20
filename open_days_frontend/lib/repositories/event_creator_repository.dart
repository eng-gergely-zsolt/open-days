import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/base_response_model.dart';
import '../services/event_creator/create_event_service.dart';
import '../screens/event_creator/models/create_event_model.dart';

final eventCreatorRepositoryProvider = Provider((_) => EventCreatorRepository());

class EventCreatorRepository {
  Future<BaseResponseModel> createEventRepo(CreateEventModel payload) async {
    await Future.delayed(const Duration(seconds: 3));
    return await createEventSvc(payload);
  }
}
