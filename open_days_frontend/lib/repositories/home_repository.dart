import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/models/user_request_model.dart';
import 'package:open_days_frontend/models/user_response_model.dart';
import 'package:open_days_frontend/services/home/get_user_by_id.dart';

final homeRepositoryProvider = Provider((_) => HomeRepository());

class HomeRepository {
  Future<UserResponseModel> getUserByIdRepo(
      UserRequestModel userRequestData) async {
    await Future.delayed(const Duration(seconds: 3));
    return await getUserByIdSvc(userRequestData);
  }
}
