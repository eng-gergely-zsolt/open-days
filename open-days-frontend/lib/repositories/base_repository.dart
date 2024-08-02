import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/base/get_activities_svc.dart';
import '../services/base/get_institutions_svc.dart';
import '../models/responses/activities_response.dart';
import '../models/responses/institution_response.dart';

final baseRepositoryProvider = Provider((_) => BaseRepository());

class BaseRepository {
  Future<ActivitiesResponse> getActivitiesRepo() async {
    return await getActivitiesSvc();
  }

  Future<InstitutionsResponse> getInstitutionsRepo() async {
    return await getInstitutionsSvc();
  }
}
