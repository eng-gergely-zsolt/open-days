import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../utils/custom_date_utils.dart';
import '../../utils/firebase_utils.dart';
import './models/event_details_initial_data.dart';
import '../../models/responses/base_response.dart';
import '../../repositories/event_details_repository.dart';

class EventDetailsController {
  var _imageURL = '';
  var _qrImageText = '';
  var _isUserEnrolled = false;

  final ProviderRef _ref;
  final EventDetailsRepository _eventDetailsRepository;

  final _listViewController = ScrollController();
  final _scrollViewController = ScrollController();
  final _reloadScreen = StateProvider((ref) => false);
  final _isLoadingProvider = StateProvider((ref) => false);

  int? _eventId;
  BaseResponse? _eventParticipatonResponse;
  FutureProvider<EventDetailsInitialData>? _initialDataProvider;

  var _isListViewActive = false;
  var _isScrollViewActive = true;

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

  bool isListViewActive() {
    return _isListViewActive;
  }

  bool isScrollViewActive() {
    return _isScrollViewActive;
  }

  ProviderRef getProviderRef() {
    return _ref;
  }

  StateProvider getReloadProvider() {
    return _reloadScreen;
  }

  StateProvider getIsLoading() {
    return _isLoadingProvider;
  }

  ScrollController getListViewController() {
    return _listViewController;
  }

  ScrollController getScrollViewController() {
    return _scrollViewController;
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
    _listViewController.dispose();
    _scrollViewController.dispose();

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
  FutureProvider<EventDetailsInitialData> createInitialDataProvider(
    int eventId,
    String dateTime,
    String roleName,
    String imagePath,
  ) {
    _eventId = eventId;

    if (_eventId != null && _eventId != eventId && _initialDataProvider != null) {
      _ref.invalidate(_initialDataProvider!);
    }

    return _initialDataProvider ??= FutureProvider((ref) async {
      var response = EventDetailsInitialData();

      _imageURL = await FirebaseUtils.getDownloadURL(imagePath);

      if (CustomDateUtils.isFutureDate(dateTime)) {
        response.usersResponse = await _eventDetailsRepository.getEnrolledUsersRepo(eventId);
      } else {
        response.usersResponse = await _eventDetailsRepository.getParticipatedUsersRepo(eventId);
      }

      if (roleName == roleOrganizer) {
        response.isUserEnrolledResponse = await _eventDetailsRepository.isUserEnrolledRepo(eventId);
      }

      _isUserEnrolled = response.isUserEnrolledResponse.data;

      if (response.usersResponse.isOperationSuccessful &&
          (roleName != roleOrganizer || response.isUserEnrolledResponse.isOperationSuccessful)) {
        response.isOperationSuccessful = true;
      }

      // Add listeners
      _listViewController.addListener(() {
        if (_listViewController.position.atEdge) {
          bool isTop = _listViewController.position.pixels == 0;
          if (isTop) {
            _isListViewActive = false;
            _isScrollViewActive = true;

            if (getProviderRef().read(_reloadScreen)) {
              getProviderRef().read(_reloadScreen.notifier).state = false;
            } else {
              getProviderRef().read(_reloadScreen.notifier).state = true;
            }
          }
        }
      });

      _scrollViewController.addListener(() {
        if (_scrollViewController.position.atEdge) {
          bool isTop = _scrollViewController.position.pixels == 0;
          if (!isTop) {
            _isListViewActive = true;
            _isScrollViewActive = false;

            if (getProviderRef().read(_reloadScreen)) {
              getProviderRef().read(_reloadScreen.notifier).state = false;
            } else {
              getProviderRef().read(_reloadScreen.notifier).state = true;
            }
          }
        }
      });

      return response;
    });
  }
}

final eventDetailsControllerProvider = Provider((ref) {
  final _eventDetailsRepository = ref.watch(eventDetailsRepositoryProvider);
  return EventDetailsController(ref, _eventDetailsRepository);
});
