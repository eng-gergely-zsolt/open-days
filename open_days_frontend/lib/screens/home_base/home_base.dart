import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../home/home.dart';
import '../../theme/theme.dart';
import '../../utils/utils.dart';
import './home_base_controller.dart';
import '../../constants/constants.dart';
import '../../shared/secure_storage.dart';
import '../event_creator/event.creator.dart';
import '../event_scanner/event_scanner.dart';

class HomeBase extends ConsumerWidget {
  const HomeBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SecureStorage.setUserId('qwertyuiopasdf2');
    SecureStorage.setAuthorizationToken(
        'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3NzcwMDY2Nn0.4xRj8DnysZCx3aFls-hpHslvgdWmlKfgiQWUt3dOIIHpQPz6ij96tZYyMmWF3FqZ6rbDufssRYtk-pcNzSdoQg');

    final appLocale = AppLocalizations.of(context);
    final appHeight = MediaQuery.of(context).size.height;

    final homeBaseController = ref.read(homeBaseControllerProvider);
    final initialData = ref.watch(homeBaseController.getInitialDataProvider());
    final curerrentIndex = ref.watch(homeBaseController.getNavigationBarIndexProvider());

    final screens = [
      Home(
        initialDataModel: homeBaseController.getInitialData(),
        homeBaseController: homeBaseController,
      ),
      const EventScanner(),
    ];

    final appBarTitle = [
      appLocale?.home,
      Utils.getString(appLocale?.application_bar_scanner),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text(appBarTitle[curerrentIndex] as String)),
      ),
      body: initialData.when(
        loading: () => Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            size: appHeight * 0.1,
            color: const Color.fromRGBO(1, 30, 65, 1),
          ),
        ),
        error: (error, stackTrace) => const Center(),
        data: (initialData) {
          return initialData.operationResult == operationResultSuccess
              ? RefreshIndicator(
                  child: screens[curerrentIndex],
                  onRefresh: () => homeBaseController.invalidateInitialDataProvider(),
                )
              : const Text('FAILURE');
        },
      ),
      floatingActionButton: initialData.when(
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
                    size: appHeight * 0.06,
                  ),
                )
              : null;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        currentIndex: curerrentIndex,
        selectedIconTheme: CustomTheme.lightTheme.iconTheme,
        onTap: (index) => homeBaseController.setNavigationBarIndexProvider(index),
        items: [
          BottomNavigationBarItem(
            label: appLocale?.home,
            activeIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: Utils.getString(appLocale?.bottom_navigation_bar_title_QR),
            activeIcon: const Icon(Icons.qr_code),
            icon: const Icon(Icons.qr_code),
          ),
        ],
      ),
    );
  }
}
