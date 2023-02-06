import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home_base/home_base_controller.dart';
import '../../repositories/home_repository.dart';

class HomeController {
  final ProviderRef _ref;
  final HomeRepository _homeRepository;

  HomeController(this._ref, this._homeRepository);

  void deleteEvent(int eventId, HomeBaseController homeBaseController) async {
    final response = await _homeRepository.deleteEventRepo(eventId);

    if (response.isOperationSuccessful == true) {
      homeBaseController.invalidateInitialDataProviderNow();
    }
  }
}

final homeControllerProvider = Provider((ref) {
  final homeRepository = ref.watch(homeRepositoryProvider);
  return HomeController(ref, homeRepository);
});
