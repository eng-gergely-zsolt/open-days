import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants.dart';
import './models/is_user_applied_for_event.dart';
import '../../models/responses/base_response.dart';
import '../../repositories/event_details_repository.dart';

class EventDetailsController {
  var _imageURL = '';
  var _qrImageText = '';

  final ProviderRef _ref;
  final EventDetailsRepository _eventDetailsRepository;
  final _isLoadingProvider = StateProvider((ref) => false);

  int? _eventId;
  BaseResponse? _eventParticipatonResponse;
  FutureProvider<IsUserAppliedForEvent>? _initialDataProvider;

  final _eventScannerUri =
      'https://open-days-thesis.herokuapp.com/open-days/event/user_participates_in_event/';

  EventDetailsController(this._ref, this._eventDetailsRepository);

  String getImageURL() {
    return _imageURL;
  }

  String getQrImageText() {
    return _qrImageText;
  }

  StateProvider getIsLoading() {
    return _isLoadingProvider;
  }

  BaseResponse? getEventParticipationResponse() {
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

  Future<bool> invalidateControllerProvider() {
    _ref.invalidate(eventDetailsControllerProvider);
    return Future.value(true);
  }

  void applyUserForEvent() async {
    var response = BaseResponse();
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
    var response = BaseResponse();
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

  /// Gathers the requested data before showing the page to the user.
  FutureProvider<IsUserAppliedForEvent> createInitialDataProvider(int? eventId, String? imagePath) {
    setEventId(eventId);

    if (_eventId != null && _eventId != eventId && _initialDataProvider != null) {
      _ref.invalidate(_initialDataProvider!);
    }

    return _initialDataProvider ??= FutureProvider((ref) async {
      var response = IsUserAppliedForEvent();

      if (imagePath != null) {
        _imageURL = await _getDownloadURL(imagePath);
      }

      if (eventId != null) {
        response = await _eventDetailsRepository.isUserAppliedForEventRepo(eventId);
      }

      return response;
    });
  }

  /// Gets the URL link from the connected Firebase Storage by the given path.
  Future<String> _getDownloadURL(String imagePath) async {
    String response;
    Reference firebaseRef;

    try {
      firebaseRef = FirebaseStorage.instance.ref().child(imagePath);
      response = await firebaseRef.getDownloadURL();
    } catch (error) {
      firebaseRef = FirebaseStorage.instance.ref().child(placeholderImagePath);
      response = await firebaseRef.getDownloadURL();
    }

    return response;
  }
}

final eventDetailsControllerProvider = Provider((ref) {
  final _eventDetailsRepository = ref.watch(eventDetailsRepositoryProvider);
  return EventDetailsController(ref, _eventDetailsRepository);
});
