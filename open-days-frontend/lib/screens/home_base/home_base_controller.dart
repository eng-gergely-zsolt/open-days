import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import './models/home_base_initial_payload.dart';
import '../../repositories/home_base_repository.dart';

class HomeBaseController {
  HomeBaseInitialPayload? _initialData;
  FutureProvider<HomeBaseInitialPayload>? _initialDataProvider;

  final ProviderRef _ref;
  final HomeBaseRepository _homeBaseRepository;
  final _orderValueProvider = StateProvider<String?>((ref) => null);
  final _navigationBarIndexProvider = StateProvider<int>((_ref) => 0);

  static const String dateOrder = 'Date';
  static const String nameOrder = 'Name';

  HomeBaseController(this._ref, this._homeBaseRepository);

  HomeBaseInitialPayload? getInitialData() {
    return _initialData;
  }

  StateProvider<String?> getOrderValueProvider() {
    return _orderValueProvider;
  }

  StateProvider<int> getNavigationBarIndexProvider() {
    return _navigationBarIndexProvider;
  }

  FutureProvider<HomeBaseInitialPayload>? getInitialDataProvider() {
    return _initialDataProvider;
  }

  void setCounty(String county) {
    if (_initialData != null) {
      _initialData?.userResponse.user.countyName = county;
    }
  }

  void setUsername(String username) {
    if (_initialData != null) {
      _initialData?.userResponse.user.username = username;
    }
  }

  void setLastName(String lastName) {
    if (_initialData != null) {
      _initialData?.userResponse.user.lastName = lastName;
    }
  }

  void setFirstName(String firstName) {
    if (_initialData != null) {
      _initialData?.userResponse.user.firstName = firstName;
    }
  }

  void setImagePath(String imagePath) {
    if (_initialData != null) {
      _initialData?.userResponse.user.imagePath = imagePath;
    }
  }

  void setInstitution(String institution) {
    if (_initialData != null) {
      _initialData?.userResponse.user.institutionName = institution;
    }
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

  void invalidateControllerProvider() {
    _ref.invalidate(homeBaseControllerProvider);
  }

  Future<void> invalidateInitialDataProvider() async {
    if (_initialDataProvider != null) {
      _ref.invalidate(_initialDataProvider!);
    }
  }

  void setNavigationBarIndexProvider(int navigationBarIndex) {
    _ref.read(_navigationBarIndexProvider.notifier).state = navigationBarIndex;
  }

  bool isParticipant(HomeBaseInitialPayload initialData) {
    return _initialData?.userResponse.user.roleName == roleUser;
  }

  void orderEvents(String? sortingValue) {
    if (sortingValue != null) {
      if (_initialDataProvider != null) {
        _ref.invalidate(_initialDataProvider!);
      }

      if (sortingValue == dateOrder) {
        _initialDataProvider = _getInitialDataProviderEventsOrderedByDate();
      } else if (sortingValue == nameOrder) {
        _initialDataProvider = _getInitialDataProviderEventsOrderedByName();
      }
    }
  }

  FutureProvider<HomeBaseInitialPayload> _getInitialDataProviderEventsOrderedByDate() {
    return FutureProvider((ref) async {
      return await _getInitialDataEventsOrderedByDate();
    });
  }

  FutureProvider<HomeBaseInitialPayload> _getInitialDataProviderEventsOrderedByName() {
    return FutureProvider((ref) async {
      return await _getInitialDataEventsOrderedByName();
    });
  }

  Future<HomeBaseInitialPayload> _getInitialDataEventsOrderedByDate() {
    HomeBaseInitialPayload result = HomeBaseInitialPayload();

    var savedUser = _homeBaseRepository.getSavedUser();
    var savedEvents = _homeBaseRepository.getSavedEventsRepo();

    var orderedEvents = savedEvents.events;

    orderedEvents.sort(
      (a, b) {
        return DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime));
      },
    );

    if (savedUser.isOperationSuccessful == true && savedEvents.isOperationSuccessful) {
      result.isOperationSuccessful = true;
    } else {
      result.isOperationSuccessful = true;
    }

    result.userResponse = savedUser;
    result.eventsResponse = savedEvents;

    return Future.value(result);
  }

  Future<HomeBaseInitialPayload> _getInitialDataEventsOrderedByName() {
    HomeBaseInitialPayload result = HomeBaseInitialPayload();

    var savedUser = _homeBaseRepository.getSavedUser();
    var savedEvents = _homeBaseRepository.getSavedEventsRepo();

    var orderedEvents = savedEvents.events;

    orderedEvents.sort(
      (a, b) {
        return a.activityName.compareTo(b.activityName);
      },
    );

    if (savedUser.isOperationSuccessful == true && savedEvents.isOperationSuccessful) {
      result.isOperationSuccessful = true;
    } else {
      result.isOperationSuccessful = true;
    }

    result.userResponse = savedUser;
    result.eventsResponse = savedEvents;

    return Future.value(result);
  }

  // It decides if we should show the floating button for creating events or not.
  bool isFloatingButtonRequired(HomeBaseInitialPayload initialData) {
    return _ref.read(_navigationBarIndexProvider) == 0 &&
        initialData.isOperationSuccessful &&
        (initialData.userResponse.user.roleName == roleAdmin ||
            initialData.userResponse.user.roleName == roleOrganizer);
  }

  void createInitialDataProvider() {
    _initialDataProvider ??= FutureProvider((ref) async {
      HomeBaseInitialPayload response = HomeBaseInitialPayload();

      var userResponse = _homeBaseRepository.getUserByIdRepo();
      var eventResponse = _homeBaseRepository.getEventsConformToUserRoleRepo();

      response.userResponse = await userResponse;
      response.eventsResponse = await eventResponse;

      if (response.userResponse.isOperationSuccessful == true &&
          response.eventsResponse.isOperationSuccessful) {
        response.isOperationSuccessful = true;
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
