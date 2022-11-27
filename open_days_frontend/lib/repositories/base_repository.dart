import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_request_model.dart';
import '../services/base/get_all_activity.dart';
import '../models/activities_response_model.dart';

final baseRepositoryProvider = Provider((_) => BaseRepository());

class BaseRepository {
  Future<ActivitiesResponseModel> getAllActivityRepo(BaseRequestModel baseRequestData) async {
    await Future.delayed(const Duration(seconds: 3));
    return await getAllActivitySvc(baseRequestData);
  }
}
