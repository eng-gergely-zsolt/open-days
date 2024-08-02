import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/participated_users_stat_response.dart';
import '../services/statistic/get_participated_users_stat_svc.dart';

final statisticRepositoryProvider = Provider((_) => StatisticRepository());

class StatisticRepository {
  Future<ParticipatedUsersStatResponse> getParticipatedUsersStatRepo(
      List<String> activityNames) async {
    return await getParticipatedUsersStatSvc(activityNames);
  }
}
