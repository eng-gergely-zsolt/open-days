import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/base/get_all_activity.dart';
import '../models/responses/activities_response.dart';
import '../services/base/get_all_institution_svc.dart';
import '../screens/registration/models/institution.dart';

final baseRepositoryProvider = Provider((_) => BaseRepository());

class BaseRepository {
  Future<ActivitiesResponse> getAllActivityRepo() async {
    return await getAllActivitySvc();
  }

  Future<List<Institution>> getAllInstitutionRepo() async {
    return await getAllInstitutionSvc();
  }
}
