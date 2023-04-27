import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/firebase_utils.dart';
import '../../shared/secure_storage.dart';
import '../../models/responses/base_response.dart';
import '../../repositories/profile_repository.dart';

class ProfileController {
  static const _folderNameInStorage = 'user';
  static const _placeholderPath = 'user/placeholder.jpg';

  final ProviderRef _ref;
  final ProfileRepository _repository;
  final _imagePathProvider = StateProvider<String>((ref) => "");

  final _forcedReload = StateProvider<bool>(((ref) => true));
  final _isClosingPageRequired = StateProvider<bool>(((ref) => false));
  final _isOperationInProgress = StateProvider<bool>(((ref) => false));

  var _imageUrl = '';
  var _imagePathInDB = '';

  Reference? _imageToDeleteRef;
  Reference? _imageToUploadRef;
  BaseResponse? _updateImagePathResponse;
  FutureProvider<String>? _imageLinkProvider;

  ProfileController(this._ref, this._repository);

  String getImageUrl() {
    return _imageUrl;
  }

  String getImagePathInDB() {
    return _imagePathInDB;
  }

  StateProvider<bool> getForcedReload() {
    return _forcedReload;
  }

  BaseResponse? getUpdateImagePathResponse() {
    return _updateImagePathResponse;
  }

  StateProvider<String> getImagePathProvider() {
    return _imagePathProvider;
  }

  StateProvider<bool> getIsClosingPageRequired() {
    return _isClosingPageRequired;
  }

  StateProvider<bool> getIsOperationInProgress() {
    return _isOperationInProgress;
  }

  void setForcedReload() {
    bool currentValue = _ref.read(_forcedReload);
    _ref.read(_forcedReload.notifier).state = !currentValue;
  }

  void setIsClosingPageRequired(bool newState) {
    _ref.read(_isClosingPageRequired.notifier).state = newState;
  }

  void setIsOperationInProgress(bool newState) {
    _ref.read(_isOperationInProgress.notifier).state = newState;
  }

  void deleteUpdateImagePathResponse() {
    _updateImagePathResponse = null;
  }

  void invalidateProfileControllerProvider() {
    _ref.invalidate(profileControllerProvider);
  }

  FutureProvider<String> createImagPathProvider(String imagePath) {
    return _imageLinkProvider ??= FutureProvider((ref) async {
      if (imagePath == '') {
        _imageUrl = await FirebaseUtils.getDownloadURL(_placeholderPath);
      } else {
        _imageUrl = await FirebaseUtils.getDownloadURL(imagePath);
      }

      return _imageUrl;
    });
  }

  Future<void> selectImage(String id, String imagePath) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (xFile != null) {
      _ref.read(_imagePathProvider.notifier).state = xFile.path;

      final imageExtension = path.extension(xFile.path);
      final uniqueImageName = DateTime.now().microsecondsSinceEpoch.toString() + imageExtension;

      _imagePathInDB = _folderNameInStorage + "/" + uniqueImageName;

      Reference rootRef = FirebaseStorage.instance.ref();
      Reference userDirectoryRef = rootRef.child(_folderNameInStorage);
      _imageToUploadRef = userDirectoryRef.child(uniqueImageName);

      if (imagePath != "" && imagePath != _placeholderPath) {
        String oldImageName = imagePath.replaceAll("user/", "");
        _imageToDeleteRef = userDirectoryRef.child(oldImageName);
      }
    }

    saveImage(id);
  }

  void saveImage(String id) async {
    _ref.read(_isOperationInProgress.notifier).state = true;

    if (_imageToDeleteRef != null) {
      try {
        await _imageToDeleteRef?.delete();
      } catch (error) {}
    }

    if (_imageToUploadRef != null) {
      try {
        await _imageToUploadRef?.putFile(File(_ref.read(_imagePathProvider)));
      } catch (error) {}
    }

    if (_imagePathInDB != '') {
      _updateImagePathResponse = await _repository.updateImagePathRepo(id, _imagePathInDB);
    }

    _ref.read(_isOperationInProgress.notifier).state = false;
  }

  void logOut() async {
    setIsOperationInProgress(true);

    String? userId = await SecureStorage.getUserId();
    String? authorizationToken = await SecureStorage.getAuthorizationToken();

    if (userId != null) {
      await SecureStorage.deleteUserId();
    }

    if (authorizationToken != null) {
      await SecureStorage.deleteAuthorizationToken();
    }

    setIsClosingPageRequired(true);
  }
}

final profileControllerProvider = Provider((ref) {
  final _repository = ref.watch(profileRepositoryProvider);
  return ProfileController(ref, _repository);
});
