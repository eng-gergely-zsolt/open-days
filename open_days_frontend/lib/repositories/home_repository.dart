import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/home/delete_event.dart';
import '../models/responses/base_response.dart';

final homeRepositoryProvider = Provider((_) => HomeRepository());

class HomeRepository {
  /// It deletes the event with the given id.
  Future<BaseResponse> deleteEventRepo(int eventId) async {
    return await deleteEventSvc(eventId);
  }
}
