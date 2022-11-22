import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_days_frontend/constants/constants.dart';
import 'package:open_days_frontend/modules/event_creator/event.creator.dart';
import 'package:open_days_frontend/modules/home/home.dart';
import 'package:open_days_frontend/modules/home_base/home_base_controller.dart';
import 'package:open_days_frontend/modules/profile/profile.dart';
import 'package:open_days_frontend/modules/settings/settings.dart';
import 'package:open_days_frontend/shared/secure_storage.dart';
import 'package:open_days_frontend/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeBase extends ConsumerWidget {
  const HomeBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SecureStorage.setUserId('qwertyuiopasdf3');

    final appLocale = AppLocalizations.of(context);
    final _appHeight = MediaQuery.of(context).size.height;

    var _homeBaseController = ref.read(homeBaseControllerProvider);
    var _initialData = ref.watch(_homeBaseController.getInitialDataProvider());

    var curerrentIndex =
        ref.watch(_homeBaseController.getNavigationBarIndexProvider());

    var screens = [
      Home(initialDataModel: _homeBaseController.getInitialData()),
      const Profile(),
      const Settings(),
    ];

    final appBarTitle = [
      appLocale?.home,
      appLocale?.profile,
      appLocale?.settings,
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text(appBarTitle[curerrentIndex] as String)),
      ),
      body: _initialData.when(
        loading: () => Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            size: _appHeight * 0.1,
            color: const Color.fromRGBO(1, 30, 65, 1),
          ),
        ),
        error: (error, stackTrace) => const Center(),
        data: (initialData) {
          return initialData.operationResult == operationResultSuccess
              ? RefreshIndicator(
                  child: screens[curerrentIndex],
                  onRefresh: () =>
                      _homeBaseController.invalidateInitialDataProvider(),
                )
              : const Text('FAILURE');
        },
      ),
      floatingActionButton: _initialData.when(
        loading: () => null,
        error: (error, stackTrace) => null,
        data: (initialData) {
          return initialData.operationResult == operationResultSuccess &&
                      initialData.user?.roleName == roleAdmin ||
                  initialData.user?.roleName == roleOrganizer
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventCreator(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: _appHeight * 0.06,
                  ),
                )
              : null;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        currentIndex: curerrentIndex,
        selectedIconTheme: CustomTheme.lightTheme.iconTheme,
        onTap: (index) =>
            _homeBaseController.setNavigationBarIndexProvider(index),
        items: [
          BottomNavigationBarItem(
            label: appLocale?.home,
            activeIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: appLocale?.profile,
            activeIcon: const Icon(Icons.person),
            icon: const Icon(Icons.person_outline),
          ),
          BottomNavigationBarItem(
            label: appLocale?.settings,
            activeIcon: const Icon(Icons.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
    );
  }
}
