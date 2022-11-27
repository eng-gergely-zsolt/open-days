import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../shared/secure_storage.dart';
import './models/initial_data_model.dart';
import '../../models/base_request_model.dart';
import '../../models/user_request_model.dart';
import '../../repositories/home_base_repository.dart';

class HomeBaseController {
  final ProviderRef _ref;
  final HomeBaseRepository _homeBaseRepository;
  final _navigationBarIndexProvider = StateProvider<int>((_ref) => 0);

  InitialDataModel? _initialData;

  late FutureProvider<InitialDataModel> _initialDataProvider;

  HomeBaseController(this._ref, this._homeBaseRepository) {
    _initialDataProvider = createInitialDataProvider();
  }

  InitialDataModel? getInitialData() {
    return _initialData;
  }

  StateProvider<int> getNavigationBarIndexProvider() {
    return _navigationBarIndexProvider;
  }

  FutureProvider<InitialDataModel> getInitialDataProvider() {
    return _initialDataProvider;
  }

  Future<void> invalidateInitialDataProvider() async {
    _ref.invalidate(_initialDataProvider);
    return await Future<void>.delayed(const Duration(seconds: 3));
  }

  void setNavigationBarIndexProvider(int navigationBarIndex) {
    _ref.read(_navigationBarIndexProvider.notifier).state = navigationBarIndex;
  }

  FutureProvider<InitialDataModel> createInitialDataProvider() {
    return FutureProvider((ref) async {
      final userRequestData = UserRequestModel();
      final baseRequestData = BaseRequestModel();

      userRequestData.id = await SecureStorage.getUserId() ?? '';
      userRequestData.authorizationToken =
          baseRequestData.authorizationToken = await SecureStorage.getAuthorizationToken() ?? '';

      InitialDataModel response = InitialDataModel();

      var userResponse = _homeBaseRepository.getUserByIdRepo(userRequestData);
      var eventResponse = _homeBaseRepository.getAllEventRepo(baseRequestData);

      response.user = await userResponse;
      response.events = await eventResponse;

      if (response.user?.operationResult == operationResultSuccess &&
          response.events?.operationResult == operationResultSuccess) {
        response.operationResult = operationResultSuccess;
      }

      _initialData = response;

      return response;
    });
  }
}

final homeBaseControllerProvider = Provider((ref) {
  final homeBaseRepository = ref.watch(homeBaseRepositoryProvider);
  return HomeBaseController(ref, homeBaseRepository);
});
