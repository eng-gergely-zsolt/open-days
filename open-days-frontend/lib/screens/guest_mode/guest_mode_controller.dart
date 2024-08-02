import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/repositories/guest_mode_repository.dart';
import 'package:open_days_frontend/models/responses/events_response.dart';

class GuestModeController {
  final ProviderRef _ref;
  final GuestModeRepository _guestModeRepository;
  late FutureProvider<EventsResponse> _eventsProvider;
  final _orderValueProvider = StateProvider<String?>((ref) => null);

  static const String dateOrder = 'Date';
  static const String nameOrder = 'Name';

  GuestModeController(this._ref, this._guestModeRepository) {
    _eventsProvider = createEventsProvider();
  }

  StateProvider<String?> getOrderValueProvider() {
    return _orderValueProvider;
  }

  FutureProvider<EventsResponse> getEventsProvider() {
    return _eventsProvider;
  }

  FutureProvider<EventsResponse> createEventsProvider() {
    return FutureProvider((ref) async {
      return await _guestModeRepository.getEventsRepo();
    });
  }

  void setOrderValue(String? newOrderValue) {
    if (newOrderValue != null) {
      _ref.read(_orderValueProvider.notifier).state = newOrderValue;
    }
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

  void orderEvents(String? sortingValue) {
    if (sortingValue != null) {
      if (sortingValue == dateOrder) {
        _ref.invalidate(_eventsProvider);
        _eventsProvider = _getOrderedByDateEventsProvider();
      } else if (sortingValue == nameOrder) {
        _ref.invalidate(_eventsProvider);
        _eventsProvider = _getOrderedByNameEventsProvider();
      }
    }
  }

  FutureProvider<EventsResponse> _getOrderedByDateEventsProvider() {
    return FutureProvider((ref) async {
      return await _getOrderedByDateEvents();
    });
  }

  FutureProvider<EventsResponse> _getOrderedByNameEventsProvider() {
    return FutureProvider((ref) async {
      return await _getOrderedByNameEvents();
    });
  }

  Future<EventsResponse> _getOrderedByDateEvents() {
    EventsResponse result = EventsResponse();
    var savedEvents = _guestModeRepository.getSavedEventsRepo();
    var orderedEvents = savedEvents.events;

    orderedEvents.sort(
      (a, b) {
        return DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime));
      },
    );

    result = EventsResponse(
      isOperationSuccessful: savedEvents.isOperationSuccessful,
      events: orderedEvents,
    );

    return Future.value(result);
  }

  Future<EventsResponse> _getOrderedByNameEvents() {
    EventsResponse result = EventsResponse();
    var savedEvents = _guestModeRepository.getSavedEventsRepo();
    var orderedEvents = savedEvents.events;

    orderedEvents.sort(
      (a, b) {
        return a.activityName.compareTo(b.activityName);
      },
    );

    result = EventsResponse(
      isOperationSuccessful: savedEvents.isOperationSuccessful,
      events: orderedEvents,
    );

    return Future.value(result);
  }
}

final guestModeControllerProvider = Provider((ref) {
  final guestModeRepository = ref.watch(guestModeRepositoryProvider);
  return GuestModeController(ref, guestModeRepository);
});
