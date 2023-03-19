import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/base/get_all_activity.dart';
import '../models/activities_response_model.dart';

final baseRepositoryProvider = Provider((_) => BaseRepository());

class BaseRepository {
  Future<ActivitiesResponseModel> getAllActivityRepo() async {
    return await getAllActivitySvc();
  }
}
