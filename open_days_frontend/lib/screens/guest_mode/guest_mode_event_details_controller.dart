import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDetailsController {
  final ProviderRef _ref;
  FutureProvider<String>? _initialDataProvider;

  EventDetailsController(this._ref);

  Future<bool> invalidateControllerProvider() {
    _ref.invalidate(guestModeEventDetailsControllerProvider);
    return Future.value(true);
  }

  /// Gathers the requested data before showing the page to the user.
  FutureProvider<String> createInitialDataProvider(String? imagePath) {
    return _initialDataProvider ??= FutureProvider((ref) async {
      var response = "";

      if (imagePath != null) {
        response = await _getDownloadURL(imagePath);
      }

      return response;
    });
  }

  /// Gets the URL link from the connected Firebase Storage by the given path.
  Future<String> _getDownloadURL(String imagePath) async {
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    return await ref.getDownloadURL();
  }
}

final guestModeEventDetailsControllerProvider = Provider((ref) {
  return EventDetailsController(ref);
});
