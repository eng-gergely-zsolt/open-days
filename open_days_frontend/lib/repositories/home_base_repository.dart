import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_response_model.dart';
import '../services/home_base/get_all_event.dart';
import '../services/home_base/get_user_by_id.dart';
import '../screens/home_base/models/get_all_event_model.dart';

final homeBaseRepositoryProvider = Provider((_) => HomeBaseRepository());

class HomeBaseRepository {
  Future<GetAllEventModel> getAllEventRepo() async {
    await Future.delayed(const Duration(seconds: 3));
    return await getAllEventSvc();
  }

  Future<UserResponseModel> getUserByIdRepo() async {
    await Future.delayed(const Duration(seconds: 3));
    return await getUserByIdSvc();
  }
}
