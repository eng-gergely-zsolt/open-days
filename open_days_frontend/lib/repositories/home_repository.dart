import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/base_response_model.dart';
import '../services/home/delete_event.dart';

final homeRepositoryProvider = Provider((_) => HomeRepository());

class HomeRepository {
  /// It deletes the event with the given id.
  Future<BaseResponseModel> deleteEventRepo(int eventId) async {
    await Future.delayed(const Duration(seconds: 3));
    return await deleteEventSvc(eventId);
  }
}
