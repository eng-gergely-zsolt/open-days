import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/base_response_model.dart';
import '../services/event_scanner/post_apply_user_for_event.dart';

final eventScannerRepositoyProvider = Provider((_) => EventScannerRepository());

class EventScannerRepository {
  Future<BaseResponseModel> participateInEvent(String? uri) async {
    await Future.delayed(const Duration(seconds: 3));
    return await participateInEventSvc(uri);
  }
}
