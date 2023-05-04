import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/guest_mode/get_future_events_svc.dart';
import '../models/responses/events_response.dart';

final guestModeRepositoryProvider = Provider((_) => GuestModeRepository());

class GuestModeRepository {
  EventsResponse savedEvents = EventsResponse();

  EventsResponse getSavedEventsRepo() {
    return savedEvents;
  }

  Future<EventsResponse> getEventsRepo() async {
    savedEvents = await getFutureEventsSvc();
    return savedEvents;
  }
}
