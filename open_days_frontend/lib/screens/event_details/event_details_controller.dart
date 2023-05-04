import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/firebase_utils.dart';
import '../../models/responses/base_response.dart';
import '../../repositories/event_details_repository.dart';
import '../../models/responses/base_logical_response.dart';

class EventDetailsController {
  var _imageURL = '';
  var _qrImageText = '';
  var _isUserEnrolled = false;

  final ProviderRef _ref;
  final EventDetailsRepository _eventDetailsRepository;
  final _isLoadingProvider = StateProvider((ref) => false);

  int? _eventId;
  BaseResponse? _eventParticipatonResponse;
  FutureProvider<BaseLogicalResponse>? _initialDataProvider;

  final _eventScannerUri =
      'https://open-days-thesis.herokuapp.com/open-days/event/save-user-participation/';

  EventDetailsController(this._ref, this._eventDetailsRepository);

  String getImageURL() {
    return _imageURL;
  }

  bool isUserEnrolled() {
    return _isUserEnrolled;
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

  void enrollUser() async {
    var response = BaseResponse();
    _ref.read(_isLoadingProvider.notifier).state = true;

    if (_eventId != null) {
      response =
          _eventParticipatonResponse = await _eventDetailsRepository.enrollUserRepo(_eventId!);
    }

    if (response.isOperationSuccessful) {
      _isUserEnrolled = true;
    }

    _ref.read(_isLoadingProvider.notifier).state = false;
  }

  void unenrollUser() async {
    var response = BaseResponse();
    _ref.read(_isLoadingProvider.notifier).state = true;

    if (_eventId != null) {
      response =
          _eventParticipatonResponse = await _eventDetailsRepository.unenrollUserRepo(_eventId!);
    }

    if (response.isOperationSuccessful) {
      _isUserEnrolled = false;
    }

    _ref.read(_isLoadingProvider.notifier).state = false;
  }

  /// Gathers the requested data before showing the page to the user.
  FutureProvider<BaseLogicalResponse> createInitialDataProvider(int? eventId, String? imagePath) {
    _eventId = eventId;

    if (_eventId != null && _eventId != eventId && _initialDataProvider != null) {
      _ref.invalidate(_initialDataProvider!);
    }

    return _initialDataProvider ??= FutureProvider((ref) async {
      var response = BaseLogicalResponse();

      if (imagePath != null) {
        _imageURL = await FirebaseUtils.getDownloadURL(imagePath);
      }

      if (eventId != null) {
        response = await _eventDetailsRepository.isUserEnrolledRepo(eventId);
        _isUserEnrolled = response.data;
      }

      return response;
    });
  }
}

final eventDetailsControllerProvider = Provider((ref) {
  final _eventDetailsRepository = ref.watch(eventDetailsRepositoryProvider);
  return EventDetailsController(ref, _eventDetailsRepository);
});
