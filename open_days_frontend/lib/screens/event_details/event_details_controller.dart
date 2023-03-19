import 'package:flutter_riverpod/flutter_riverpod.dart';

import './models/is_user_applied_for_event.dart';
import '../../models/base_response_model.dart';
import '../../repositories/event_details_repository.dart';

class EventDetailsController {
  var _qrImageText = '';

  final ProviderRef _ref;
  final EventDetailsRepository _eventDetailsRepository;
  final _isLoadingProvider = StateProvider((ref) => false);

  int? _eventId;
  BaseResponseModel? _eventParticipatonResponse;
  FutureProvider<IsUserAppliedForEvent>? _initialDataProvider;

  final _eventScannerUri =
      'https://open-days-thesis.herokuapp.com/open-days/event/user_participates_in_event/';

  EventDetailsController(this._ref, this._eventDetailsRepository);

  String getQrImageText() {
    return _qrImageText;
  }

  StateProvider getIsLoading() {
    return _isLoadingProvider;
  }

  BaseResponseModel? getEventParticipationResponse() {
    return _eventParticipatonResponse;
  }

  void setEventId(int? eventId) {
    _eventId = eventId;
  }

  void setQrImageText(String eventId) {
    _qrImageText = _eventScannerUri + eventId;
  }

  void deleteEventParticipatonResponse() {
    _eventParticipatonResponse = null;
  }

  void applyUserForEvent() async {
    var response = BaseResponseModel();
    _ref.read(_isLoadingProvider.notifier).state = true;

    if (_eventId != null) {
      response = _eventParticipatonResponse =
          await _eventDetailsRepository.applyUserForEventRepo(_eventId!);
    }

    if (response.isOperationSuccessful) {
      reloadInitialDataProvider();
    } else {
      _ref.read(_isLoadingProvider.notifier).state = false;
    }
  }

  void deleteUserFromEvent() async {
    var response = BaseResponseModel();
    _ref.read(_isLoadingProvider.notifier).state = true;

    if (_eventId != null) {
      response = _eventParticipatonResponse =
          await _eventDetailsRepository.deleteUserFromEventRepo(_eventId!);
    }

    if (response.isOperationSuccessful) {
      reloadInitialDataProvider();
    } else {
      _ref.read(_isLoadingProvider.notifier).state = false;
    }
  }

  void reloadInitialDataProvider() {
    _ref.invalidate(_initialDataProvider!);

    _initialDataProvider = FutureProvider((ref) async {
      var response = IsUserAppliedForEvent();

      if (_eventId != null) {
        response = await _eventDetailsRepository.isUserAppliedForEventRepo(_eventId!);
      }

      _ref.read(_isLoadingProvider.notifier).state = false;
      return response;
    });
  }

  FutureProvider<IsUserAppliedForEvent> createInitialDataProvider(int? eventId) {
    if (_eventId != null && _eventId != eventId && _initialDataProvider != null) {
      _ref.invalidate(_initialDataProvider!);

      setEventId(eventId);

      return _initialDataProvider = FutureProvider((ref) async {
        var response = IsUserAppliedForEvent();

        if (eventId != null) {
          response = await _eventDetailsRepository.isUserAppliedForEventRepo(eventId);
        }

        return response;
      });
    }

    setEventId(eventId);

    return _initialDataProvider ??= FutureProvider((ref) async {
      var response = IsUserAppliedForEvent();

      if (eventId != null) {
        response = await _eventDetailsRepository.isUserAppliedForEventRepo(eventId);
      }

      return response;
    });
  }
}

final eventDetailsControllerProvider = Provider((ref) {
  final _eventDetailsRepository = ref.watch(eventDetailsRepositoryProvider);
  return EventDetailsController(ref, _eventDetailsRepository);
});
