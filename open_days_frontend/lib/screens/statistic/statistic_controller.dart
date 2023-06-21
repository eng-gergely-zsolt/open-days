import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/base_repository.dart';
import '../../repositories/statistic_repository.dart';
import '../../models/responses/activities_response.dart';
import '../../models/responses/participated_users_stat_response.dart';

class StatisticController {
  final ProviderRef _ref;
  final BaseRepository _baseRepository;
  final StatisticRepository _statisticRepository;

  final List<String> _activityNames = [];
  final _isLoadingProvider = StateProvider<bool>((ref) => false);
  final StateProvider<bool> _reloadFlagProvider = StateProvider(((ref) => false));

  late FutureProvider<ActivitiesResponse> _initialDataProvider;

  ParticipatedUsersStatResponse? _participatedUsersStatResponse;

  final List<Color> _pieChartColorList = [
    const Color.fromRGBO(231, 111, 81, 1),
    const Color.fromRGBO(42, 157, 143, 1),
    const Color.fromRGBO(99, 174, 183, 1),
    const Color.fromRGBO(233, 196, 106, 1),
    const Color.fromRGBO(38, 70, 83, 1),
  ];

  StatisticController(this._ref, this._baseRepository, this._statisticRepository) {
    _initialDataProvider = _createInitialDataProvider();
  }

  bool isPieChartRequired() {
    return _participatedUsersStatResponse != null &&
        _participatedUsersStatResponse!.stats.length > 1;
  }

  List<String> getActivityNames() {
    return _activityNames;
  }

  List<Color> getPieChartColorList() {
    return _pieChartColorList;
  }

  StateProvider<bool> getIsLoadinProvider() {
    return _isLoadingProvider;
  }

  StateProvider<bool> getReloadFlagProvider() {
    return _reloadFlagProvider;
  }

  FutureProvider<ActivitiesResponse> getInitialDataProvider() {
    return _initialDataProvider;
  }

  ParticipatedUsersStatResponse? getParticipatedUsersStatResponse() {
    return _participatedUsersStatResponse;
  }

  Map<String, double> getPieChartDataMap() {
    Map<String, double> result = {};

    for (var element in _participatedUsersStatResponse!.stats) {
      result[element.activityName] = element.participatedUsersNr.toDouble();
    }

    return result;
  }

  void changeCheckBoxState(bool? checkBoxState, String activityName) {
    if (checkBoxState != null) {
      if (checkBoxState) {
        if (!_activityNames.contains(activityName)) {
          _activityNames.add(activityName);
        }
      } else {
        _activityNames.remove(activityName);
      }
    }

    if (_ref.read(_reloadFlagProvider)) {
      _ref.read(_reloadFlagProvider.notifier).state = false;
    } else {
      _ref.read(_reloadFlagProvider.notifier).state = true;
    }
  }

  Future<void> createStatistic() async {
    if (_activityNames.length > 1) {
      _ref.read(_isLoadingProvider.notifier).state = true;

      _participatedUsersStatResponse =
          await _statisticRepository.getParticipatedUsersStatRepo(_activityNames);

      _ref.read(_isLoadingProvider.notifier).state = false;
    }
  }

  /// Creates the initial provider, the initial provider contains the initial data that required to
  /// load a page.
  FutureProvider<ActivitiesResponse> _createInitialDataProvider() {
    return FutureProvider((ref) async {
      return await _baseRepository.getActivitiesRepo();
    });
  }
}

final statisticControllerProvider = Provider((ref) {
  final baseRepository = ref.watch(baseRepositoryProvider);
  final statisticRespository = ref.watch(statisticRepositoryProvider);

  return StatisticController(ref, baseRepository, statisticRespository);
});
