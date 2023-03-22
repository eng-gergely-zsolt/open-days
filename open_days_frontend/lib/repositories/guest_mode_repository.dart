import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/home_base/get_all_event.dart';
import '../screens/home_base/models/get_all_event_model.dart';

final guestModeRepositoryProvider = Provider((_) => GuestModeRepository());

class GuestModeRepository {
  Future<GetAllEventModel> getEventsRepo() async {
    return await getAllEventSvc();
  }
}
