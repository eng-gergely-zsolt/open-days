import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/models/user_response_model.dart';
import 'package:open_days_frontend/repositories/home_repository.dart';

import '../../models/user_request_model.dart';
import '../../shared/secure_storage.dart';

class HomeController {
  final ProviderRef _ref;
  final HomeRepository _homeRepository;

  final _userProvider = FutureProvider((ref) async {
    final userRequestData = UserRequestModel();
    final homeRepository = ref.watch(homeRepositoryProvider);

    userRequestData.id = await SecureStorage.getUserId() ?? '';
    userRequestData.authorizationToken =
        await SecureStorage.getAuthorizationToken() ?? '';

    return homeRepository.getUserByIdRepo(userRequestData);
  });

  HomeController(this._ref, this._homeRepository);

  FutureProvider<UserResponseModel> getUserProvider() {
    return _userProvider;
  }
}

final homeControllerProvider = Provider((ref) {
  final homeRepository = ref.watch(homeRepositoryProvider);
  return HomeController(ref, homeRepository);
});
