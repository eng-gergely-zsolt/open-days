import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_response_model.dart';
import '../services/event_scanner/post_apply_user_for_event.dart';

final eventScannerRepositoyProvider = Provider((_) => EventScannerRepository());

class EventScannerRepository {
  Future<BaseResponseModel> participateInEventRepo(String? uri) async {
    return await participateInEventSvc(uri);
  }
}
