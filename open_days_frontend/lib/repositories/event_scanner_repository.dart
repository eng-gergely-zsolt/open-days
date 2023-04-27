import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/base_response.dart';
import '../services/event_scanner/post_apply_user_for_event.dart';

final eventScannerRepositoyProvider = Provider((_) => EventScannerRepository());

class EventScannerRepository {
  Future<BaseResponse> participateInEventRepo(String? uri) async {
    return await participateInEventSvc(uri);
  }
}
