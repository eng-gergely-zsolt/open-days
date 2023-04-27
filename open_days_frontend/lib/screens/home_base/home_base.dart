import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_days_frontend/models/responses/user_response.dart';

import '../home/home.dart';
import '../../theme/theme.dart';
import '../../utils/utils.dart';
import '../profile/profile.dart';
import './home_base_controller.dart';
import '../../constants/constants.dart';
import './models/initial_data_model.dart';
import '../event_creator/event_creator.dart';
import '../event_scanner/event_scanner.dart';

class HomeBase extends ConsumerWidget {
  const HomeBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(homeBaseControllerProvider);
    final initialData = ref.watch(controller.getInitialDataProvider());
    final navigationBarIndex = ref.watch(controller.getNavigationBarIndexProvider());

    UserResponse user = controller.getInitialData()?.user ?? UserResponse();

    final screens = [
      Home(initialDataModel: controller.getInitialData(), homeBaseController: controller),
      const EventScanner(),
      Profile(user, controller),
    ];

    final organizerSreens = [
      Home(initialDataModel: controller.getInitialData(), homeBaseController: controller),
      Profile(user, controller),
    ];

    final appBarTitles = [
      appLocale?.home,
      Utils.getString(appLocale?.application_bar_scanner),
      Utils.getString(appLocale?.profile),
    ];

    final organizerAppBarTitles = [appLocale?.home, Utils.getString(appLocale?.profile)];

    return WillPopScope(
      onWillPop: (() {
        return controller.closeApplication(context);
      }),
      child: Scaffold(
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
              color: const Color.fromRGBO(38, 70, 83, 1),
            ),
          ),
          error: (error, stackTrace) => const Center(),
          data: (initialData) {
            return initialData.operationResult == operationResultSuccess
                ? RefreshIndicator(
                    child: initialData.user.roleName == roleUser
                        ? screens[navigationBarIndex]
                        : organizerSreens[navigationBarIndex],
                    onRefresh: () => controller.invalidateInitialDataProvider(),
                  )
                : const Center(
                    child: Text('FAILURE'),
                  );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
      ),
    );
  }

  Widget getBottomNavigationBar(int navigationBarIndex, HomeBaseController controller,
      AppLocalizations? appLocale, InitialDataModel initialData) {
    return initialData.user.roleName == roleUser
        ? BottomNavigationBar(
            showUnselectedLabels: false,
            currentIndex: navigationBarIndex,
            selectedIconTheme: CustomTheme.lightTheme.iconTheme,
            onTap: (index) => controller.setNavigationBarIndexProvider(index),
            items: [
              BottomNavigationBarItem(
                label: appLocale?.home,
                icon: const Icon(Icons.home_outlined),
                activeIcon: Icon(
                  Icons.home,
                  color: CustomTheme.lightTheme.primaryColor,
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.qr_code),
                label: Utils.getString(appLocale?.bottom_navigation_bar_title_QR),
                activeIcon: Icon(
                  Icons.qr_code,
                  color: CustomTheme.lightTheme.primaryColor,
                ),
              ),
              BottomNavigationBarItem(
                label: Utils.getString(appLocale?.profile),
                icon: const Icon(Icons.person_outline_outlined),
                activeIcon: Icon(
                  Icons.person,
                  color: CustomTheme.lightTheme.primaryColor,
                ),
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
                icon: const Icon(Icons.home_outlined),
                activeIcon: Icon(
                  Icons.home,
                  color: CustomTheme.lightTheme.primaryColor,
                ),
              ),
              BottomNavigationBarItem(
                label: Utils.getString(appLocale?.profile),
                icon: const Icon(Icons.person_outline_outlined),
                activeIcon: Icon(
                  Icons.person,
                  color: CustomTheme.lightTheme.primaryColor,
                ),
              ),
            ],
          );
  }
}
