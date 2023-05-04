import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/event.dart';
import '../constants/constants.dart';
import '../../models/activity.dart';
import '../../utils/firebase_utils.dart';
import '../../shared/secure_storage.dart';
import '../../repositories/base_repository.dart';
import '../../models/responses/base_response.dart';
import '../../models/responses/activities_response.dart';
import '../../repositories/event_creator_repository.dart';

class EventCreatorController {
  var _imageUrl = '';
  var _location = '';
  var _description = '';
  var _imagePathInDB = '';
  final _folderNameInStorage = 'event';

  String? _meetingLink;
  Reference? _imageToUploadRef;
  BaseResponse? _createEventResponse;

  final ProviderRef _ref;
  final BaseRepository _baseRepository;
  final EventCreatorRepository _eventCreatorRepository;
  final _imagePathProvider = StateProvider<String>((ref) => "");
  final _isLoadingProvider = StateProvider<bool>((ref) => false);
  final _isOnlineMeetingProvider = StateProvider<bool>((ref) => false);
  final _selectedActivityProvider = StateProvider<String?>((ref) => null);
  final _selectedDateTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

  late FutureProvider<ActivitiesResponse> _activitiesProvider;

  EventCreatorController(this._ref, this._baseRepository, this._eventCreatorRepository) {
    createInitialData();
  }

  String? getLink() {
    return _meetingLink;
  }

  String getLocation() {
    return _location;
  }

  String getImageUrl() {
    return _imageUrl;
  }

  String getDescription() {
    return _description;
  }

  StateProvider<String> getImagePathProvider() {
    return _imagePathProvider;
  }

  StateProvider<bool> getIsLoadinProvider() {
    return _isLoadingProvider;
  }

  BaseResponse? getCreateEventResponse() {
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

  FutureProvider<ActivitiesResponse> getActivitiesProvider() {
    return _activitiesProvider;
  }

  void setLink(String meetingLink) {
    _meetingLink = meetingLink;
  }

  void setLocation(String location) {
    _location = location;
  }

  void setDescription(String description) {
    _description = description;
  }

  void deleteCreateEventResponse() {
    _createEventResponse = null;
  }

  String getFormattedTime(DateTime dateTime) {
    final DateFormat dateFormatter = DateFormat('HH:mm');
    return dateFormatter.format(dateTime);
  }

  Future<bool> invalidateControllerProvider() {
    _ref.invalidate(eventCreatorControllerProvider);
    return Future.value(true);
  }

  void setIsOnlineMeetingProvider(bool? isOnlineMeeting) {
    if (isOnlineMeeting == null) return;
    _ref.read(_isOnlineMeetingProvider.notifier).state = isOnlineMeeting;
  }

  List<String> getAllActivityName(List<Activity> activities) {
    List<String> activityNames = [];

    for (Activity it in activities) {
      activityNames.add(it.name);
    }

    return activityNames;
  }

  Future<void> createInitialData() async {
    _activitiesProvider = FutureProvider((ref) async {
      _imageUrl = await FirebaseUtils.getDownloadURL(eventPlaceholderImagePath);
      return _baseRepository.getActivitiesRepo();
    });
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

  void selectImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (xFile != null) {
      _ref.read(_imagePathProvider.notifier).state = xFile.path;
    }

    if (xFile != null) {
      final imageExtension = path.extension(xFile.path);
      final uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString() + imageExtension;

      _imagePathInDB = _folderNameInStorage + '/' + uniqueImageName;

      Reference rootRef = FirebaseStorage.instance.ref();
      Reference eventDirectoryRef = rootRef.child(_folderNameInStorage);
      _imageToUploadRef = eventDirectoryRef.child(uniqueImageName);
    }
  }

  void createEvent(String? selectedActivityName) async {
    _ref.read(_isLoadingProvider.notifier).state = true;

    var event = Event();
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd H:m');

    event.location = _location;
    event.description = _description;
    event.activityName = selectedActivityName ?? '';
    event.isOnline = _ref.read(_isOnlineMeetingProvider);
    event.meetingLink = event.isOnline ? _meetingLink : null;
    event.dateTime = dateFormatter.format(_ref.read(_selectedDateTimeProvider));

    event.organizerId = await SecureStorage.getUserId() ?? '';

    if (_imageToUploadRef != null) {
      try {
        await _imageToUploadRef?.putFile(File(_ref.read(_imagePathProvider)));
        event.imagePath = _imagePathInDB;
      } catch (error) {}
    }

    if (_imageToUploadRef != null) {
      try {
        await _imageToUploadRef?.putFile(File(_ref.read(_imagePathProvider)));
        event.imagePath = _imagePathInDB;
      } catch (error) {}
    } else {
      event.imagePath = eventPlaceholderImagePath;
    }

    if (event.location == '' || event.organizerId == '') {
      _createEventResponse = BaseResponse();
    } else {
      _createEventResponse = await _eventCreatorRepository.createEventRepo(event);
    }

    if (_createEventResponse?.isOperationSuccessful == true) {
      _location = '';
      _description = '';
    }

    _ref.read(_isLoadingProvider.notifier).state = false;
  }
}

final eventCreatorControllerProvider = Provider((ref) {
  final baseRepository = ref.watch(baseRepositoryProvider);
  final eventCreatorRepository = ref.watch(eventCreatorRepositoryProvider);
  return EventCreatorController(ref, baseRepository, eventCreatorRepository);
});
