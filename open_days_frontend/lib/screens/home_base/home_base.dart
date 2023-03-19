import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../home/home.dart';
import '../../theme/theme.dart';
import '../../utils/utils.dart';
import '../profile/profile.dart';
import './home_base_controller.dart';
import '../../constants/constants.dart';
import './models/initial_data_model.dart';
import '../../shared/secure_storage.dart';
import '../event_creator/event_creator.dart';
import '../event_scanner/event_scanner.dart';

class HomeBase extends ConsumerWidget {
  const HomeBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // SecureStorage.setUserId('qwertyuiopasdf2');
    // SecureStorage.setAuthorizationToken(
    //     'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTY3ODM4OTE4OH0.rTVj_GRSTkQ3GHLtOR5adi_T8G4BKM6xHdiIo7U3fjJrxNYNfOws0MfuapTOaBqb1Yu1rdAH5xZLVoAh945_fw');

    final appLocale = AppLocalizations.of(context);
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(homeBaseControllerProvider);
    final initialData = ref.watch(controller.getInitialDataProvider());
    final navigationBarIndex = ref.watch(controller.getNavigationBarIndexProvider());

    final screens = [
      Home(initialDataModel: controller.getInitialData(), homeBaseController: controller),
      const EventScanner(),
      const Profile(),
    ];

    final organizerSreens = [
      Home(initialDataModel: controller.getInitialData(), homeBaseController: controller),
      const Profile(),
    ];

    final appBarTitles = [
      appLocale?.home,
      Utils.getString(appLocale?.application_bar_scanner),
      Utils.getString(appLocale?.profile),
    ];

    final organizerAppBarTitles = [appLocale?.home, Utils.getString(appLocale?.profile)];

    return Scaffold(
      appBar: initialData.when(
        loading: () => null,
        error: (error, stackTrace) => null,
        data: (initialData) => AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: controller.isParticipant(initialData)
                ? Text(appBarTitles[navigationBarIndex] as String)
                : Text(organizerAppBarTitles[navigationBarIndex] as String),
          ),
        ),
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
                  child: initialData.user?.roleName == roleUser
                      ? screens[navigationBarIndex]
                      : organizerSreens[navigationBarIndex],
                  onRefresh: () => controller.invalidateInitialDataProvider(),
                )
              : const Center(
                  child: Text('FAILURE'),
                );
        },
      ),
      floatingActionButton: initialData.when(
        loading: () => null,
        error: (error, stackTrace) => null,
        data: (initialData) {
          return controller.isFloatingButtonRequired(initialData)
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
      bottomNavigationBar: initialData.when(
        loading: () => null,
        error: (error, stackTrace) => null,
        data: (initialData) =>
            getBottomNavigationBar(navigationBarIndex, controller, appLocale, initialData),
      ),
    );
  }

  Widget getBottomNavigationBar(int navigationBarIndex, HomeBaseController controller,
      AppLocalizations? appLocale, InitialDataModel initialData) {
    return initialData.user?.roleName == roleUser
        ? BottomNavigationBar(
            showUnselectedLabels: false,
            currentIndex: navigationBarIndex,
            selectedIconTheme: CustomTheme.lightTheme.iconTheme,
            onTap: (index) => controller.setNavigationBarIndexProvider(index),
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
              BottomNavigationBarItem(
                label: Utils.getString(appLocale?.profile),
                activeIcon: const Icon(Icons.person),
                icon: const Icon(Icons.person_outline_outlined),
              ),
            ],
          )
        : BottomNavigationBar(
            showUnselectedLabels: false,
            currentIndex: navigationBarIndex,
            selectedIconTheme: CustomTheme.lightTheme.iconTheme,
            onTap: (index) => controller.setNavigationBarIndexProvider(index),
            items: [
              BottomNavigationBarItem(
                label: appLocale?.home,
                activeIcon: const Icon(Icons.home),
                icon: const Icon(Icons.home_outlined),
              ),
              BottomNavigationBarItem(
                label: Utils.getString(appLocale?.profile),
                activeIcon: const Icon(Icons.person),
                icon: const Icon(Icons.person_outline_outlined),
              ),
            ],
          );
  }
}
