import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './models/create_event_model.dart';
import '../../models/activity_model.dart';
import '../../shared/secure_storage.dart';
import '../../models/base_request_model.dart';
import '../../models/base_response_model.dart';
import '../../repositories/base_repository.dart';
import '../../models/activities_response_model.dart';
import '../../repositories/event_creator_repository.dart';

class EventCreatorController {
  var _location = '';
  String? _meetingLink;
  BaseResponseModel? _createEventResponse;

  final ProviderRef _ref;
  final BaseRepository _baseRepository;
  final EventCreatorRepository _eventCreatorRepository;
  final _isLoadingProvider = StateProvider<bool>((ref) => false);
  final _isOnlineMeetingProvider = StateProvider<bool>((ref) => false);
  final _selectedActivityProvider = StateProvider<String?>((ref) => null);
  final _selectedDateTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

  late FutureProvider<ActivitiesResponseModel> _activitiesProvider;

  EventCreatorController(this._ref, this._baseRepository, this._eventCreatorRepository) {
    _activitiesProvider = getAllActivity();
  }

  String? getLink() {
    return _meetingLink;
  }

  String getLocation() {
    return _location;
  }

  StateProvider<bool> getIsLoadinProvider() {
    return _isLoadingProvider;
  }

  BaseResponseModel? getCreateEventResponse() {
    return _createEventResponse;
  }

  StateProvider<bool> getIsOnlineMeetingProvider() {
    return _isOnlineMeetingProvider;
  }

  StateProvider<String?> getSelectedActivityProvider() {
    return _selectedActivityProvider;
  }

  StateProvider<DateTime> getSelectedDateTimeProvider() {
    return _selectedDateTimeProvider;
  }

  FutureProvider<ActivitiesResponseModel> getActivitiesProvider() {
    return _activitiesProvider;
  }

  FutureProvider<ActivitiesResponseModel> getAllActivity() {
    return FutureProvider((ref) async {
      final baseRequestData = BaseRequestModel();

      baseRequestData.authorizationToken = await SecureStorage.getAuthorizationToken() ?? '';

      return _baseRepository.getAllActivityRepo(baseRequestData);
    });
  }

  List<String> getAllActivityName(List<ActivityModel> activities) {
    List<String> activityNames = [];

    for (ActivityModel it in activities) {
      activityNames.add(it.name);
    }

    return activityNames;
  }

  void setLink(String meetingLink) {
    _meetingLink = meetingLink;
  }

  void setLocation(String location) {
    _location = location;
  }

  void setIsOnlineMeetingProvider(bool? isOnlineMeeting) {
    if (isOnlineMeeting == null) return;
    _ref.read(_isOnlineMeetingProvider.notifier).state = isOnlineMeeting;
  }

  void setSelectedDate(DateTime? date) {
    if (date == null) return;

    final currentDateTime = _ref.read(_selectedDateTimeProvider);

    final newSelectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      currentDateTime.hour,
      currentDateTime.minute,
    );

    _ref.read(_selectedDateTimeProvider.notifier).state = newSelectedDateTime;
  }

  void setSelectedTime(TimeOfDay? time) {
    if (time == null) return;

    final currentDateTime = _ref.read(_selectedDateTimeProvider);

    final newSelectedDateTime = DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      time.hour,
      time.minute,
    );

    _ref.read(_selectedDateTimeProvider.notifier).state = newSelectedDateTime;
  }

  void deleteCreateEventResponse() {
    _createEventResponse = null;
  }

  String getFormattedTime(DateTime dateTime) {
    final DateFormat dateFormatter = DateFormat('HH:mm');

    return dateFormatter.format(dateTime);
  }

  void createEvent(String? selectedActivityName) async {
    _ref.read(_isLoadingProvider.notifier).state = true;

    var payload = CreateEventModel();
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd H:m');

    payload.event.location = _location;
    payload.event.activityName = selectedActivityName ?? '';
    payload.event.isOnline = _ref.read(_isOnlineMeetingProvider);
    payload.event.meetingLink = payload.event.isOnline ? _meetingLink : null;

    payload.authorizationToken = await SecureStorage.getAuthorizationToken() ?? '';
    payload.event.dateTime = dateFormatter.format(_ref.read(_selectedDateTimeProvider));

    payload.event.organizerId = await SecureStorage.getUserId() ?? '';

    if (payload.event.location == '' || payload.event.organizerId == '' || payload.authorizationToken == '') {
      _createEventResponse = BaseResponseModel();
    } else {
      _createEventResponse = await _eventCreatorRepository.createEventRepo(payload);
    }

    if (_createEventResponse?.isOperationSuccessful == true) {
      _location = '';
    }

    _ref.read(_isLoadingProvider.notifier).state = false;
  }
}

final eventCreatorControllerProvider = Provider((ref) {
  final baseRepository = ref.watch(baseRepositoryProvider);
  final eventCreatorRepository = ref.watch(eventCreatorRepositoryProvider);
  return EventCreatorController(ref, baseRepository, eventCreatorRepository);
});
