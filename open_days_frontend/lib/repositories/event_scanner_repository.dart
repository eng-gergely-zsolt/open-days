import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/base_response.dart';
import '../services/event_scanner/save_user_participation_svc.dart';

final eventScannerRepositoyProvider = Provider((_) => EventScannerRepository());

class EventScannerRepository {
  Future<BaseResponse> saveUserParticipationRepo(String? uri) async {
    return await saveUserParticipationSvc(uri);
  }
}
