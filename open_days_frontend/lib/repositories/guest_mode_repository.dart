import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/home_base/get_all_event.dart';
import '../screens/home_base/models/get_all_event_model.dart';

final guestModeRepositoryProvider = Provider((_) => GuestModeRepository());

class GuestModeRepository {
  GetAllEventModel savedEvents = GetAllEventModel();

  GetAllEventModel getSavedEventsRepo() {
    return savedEvents;
  }

  Future<GetAllEventModel> getEventsRepo() async {
    savedEvents = await getAllEventSvc();
    return savedEvents;
  }
}
