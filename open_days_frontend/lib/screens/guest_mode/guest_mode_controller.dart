import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/repositories/guest_mode_repository.dart';
import 'package:open_days_frontend/screens/home_base/models/get_all_event_model.dart';

class GuestModeController {
  final ProviderRef _ref;
  final GuestModeRepository _guestModeRepository;
  late FutureProvider<GetAllEventModel> _eventsProvider;

  GuestModeController(this._ref, this._guestModeRepository) {
    _eventsProvider = createEventsProvider();
  }

  FutureProvider<GetAllEventModel> getEventsProvider() {
    return _eventsProvider;
  }

  FutureProvider<GetAllEventModel> createEventsProvider() {
    return FutureProvider((ref) async {
      return await _guestModeRepository.getEventsRepo();
    });
  }

  Future<bool> invalidateGuestModeControllerProvider() {
    _ref.invalidate(guestModeControllerProvider);
    return Future.value(true);
  }

  Future<void> refreshEvents() async {
    _ref.invalidate(_eventsProvider);
    _eventsProvider = createEventsProvider();
    return await Future<void>.delayed(const Duration(seconds: 0));
  }
}

final guestModeControllerProvider = Provider((ref) {
  final guestModeRepository = ref.watch(guestModeRepositoryProvider);
  return GuestModeController(ref, guestModeRepository);
});
