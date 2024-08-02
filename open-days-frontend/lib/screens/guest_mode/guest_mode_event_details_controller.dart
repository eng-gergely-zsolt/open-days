import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/firebase_utils.dart';

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
        response = await FirebaseUtils.getDownloadURL(imagePath);
      }

      return response;
    });
  }
}

final guestModeEventDetailsControllerProvider = Provider((ref) {
  return EventDetailsController(ref);
});
