import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import './models/initial_data_model.dart';
import '../../repositories/home_base_repository.dart';
import 'models/get_all_event_model.dart';

class HomeBaseController {
  InitialDataModel? _initialData;

  final ProviderRef _ref;
  final HomeBaseRepository _homeBaseRepository;
  late FutureProvider<InitialDataModel> _initialDataProvider;
  final _orderValueProvider = StateProvider<String?>((ref) => null);
  final _navigationBarIndexProvider = StateProvider<int>((_ref) => 0);

  static const String dateOrder = 'Date';
  static const String nameOrder = 'Name';

  HomeBaseController(this._ref, this._homeBaseRepository) {
    _initialDataProvider = createInitialDataProvider();
  }

  InitialDataModel? getInitialData() {
    return _initialData;
  }

  StateProvider<String?> getOrderValueProvider() {
    return _orderValueProvider;
  }

  StateProvider<int> getNavigationBarIndexProvider() {
    return _navigationBarIndexProvider;
  }

  FutureProvider<InitialDataModel> getInitialDataProvider() {
    return _initialDataProvider;
  }

  void setOrderValue(String? newOrderValue) {
    if (newOrderValue != null) {
      _ref.read(_orderValueProvider.notifier).state = newOrderValue;
    }
  }

  Future<bool> closeApplication(BuildContext context) {
    SystemChannels.platform.invokeListMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  void invalidateInitialDataProviderNow() {
    _ref.invalidate(_initialDataProvider);
  }

  Future<void> invalidateInitialDataProvider() async {
    _ref.invalidate(_initialDataProvider);
    return await Future<void>.delayed(const Duration(seconds: 3));
  }

  void setNavigationBarIndexProvider(int navigationBarIndex) {
    _ref.read(_navigationBarIndexProvider.notifier).state = navigationBarIndex;
  }

  bool isParticipant(InitialDataModel initialData) {
    return initialData.user?.roleName == roleUser;
  }

  void orderEvents(String? sortingValue) {
    if (sortingValue != null) {
      _ref.invalidate(_initialDataProvider);
      if (sortingValue == dateOrder) {
        _initialDataProvider = _getInitialDataProviderEventsOrderedByDate();
      } else if (sortingValue == nameOrder) {
        _initialDataProvider = _getInitialDataProviderEventsOrderedByName();
      }
    }
  }

  FutureProvider<InitialDataModel> _getInitialDataProviderEventsOrderedByDate() {
    return FutureProvider((ref) async {
      return await _getInitialDataEventsOrderedByDate();
    });
  }

  FutureProvider<InitialDataModel> _getInitialDataProviderEventsOrderedByName() {
    return FutureProvider((ref) async {
      return await _getInitialDataEventsOrderedByName();
    });
  }

  Future<InitialDataModel> _getInitialDataEventsOrderedByDate() {
    InitialDataModel result = InitialDataModel();

    var savedUser = _homeBaseRepository.getSavedUser();
    var savedEvents = _homeBaseRepository.getSavedEventsRepo();

    var orderedEvents = savedEvents.events;

    orderedEvents.sort(
      (a, b) {
        return DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime));
      },
    );

    if (savedUser.operationResult == operationResultSuccess &&
        savedEvents.operationResult == operationResultSuccess) {
      result.operationResult = operationResultSuccess;
    } else {
      result.operationResult = operationResultFailure;
    }

    result.user = savedUser;
    result.events = savedEvents;

    return Future.value(result);
  }

  Future<InitialDataModel> _getInitialDataEventsOrderedByName() {
    InitialDataModel result = InitialDataModel();

    var savedUser = _homeBaseRepository.getSavedUser();
    var savedEvents = _homeBaseRepository.getSavedEventsRepo();

    var orderedEvents = savedEvents.events;

    orderedEvents.sort(
      (a, b) {
        return a.activityName.compareTo(b.activityName);
      },
    );

    if (savedUser.operationResult == operationResultSuccess &&
        savedEvents.operationResult == operationResultSuccess) {
      result.operationResult = operationResultSuccess;
    } else {
      result.operationResult = operationResultFailure;
    }

    result.user = savedUser;
    result.events = savedEvents;

    return Future.value(result);
  }

  // It decides if we should show the floating button for creating events or not.
  bool isFloatingButtonRequired(InitialDataModel initialData) {
    return _ref.read(_navigationBarIndexProvider) == 0 &&
        initialData.operationResult == operationResultSuccess &&
        (initialData.user?.roleName == roleAdmin || initialData.user?.roleName == roleOrganizer);
  }

  FutureProvider<InitialDataModel> createInitialDataProvider() {
    return FutureProvider((ref) async {
      InitialDataModel response = InitialDataModel();

      var eventResponse = _homeBaseRepository.getAllEventRepo();
      var userResponse = _homeBaseRepository.getUserByIdRepo();

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
