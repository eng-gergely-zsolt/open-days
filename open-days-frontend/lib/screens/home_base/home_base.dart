import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_days_frontend/models/responses/user_response.dart';

import '../home/home.dart';
import '../../theme/theme.dart';
import '../../utils/utils.dart';
import '../profile/profile.dart';
import '../statistic/statistic.dart';
import './home_base_controller.dart';
import '../../constants/constants.dart';
import '../error/base_error_screen.dart';
import '../event_creator/event_creator.dart';
import '../event_scanner/event_scanner.dart';
import './models/home_base_initial_payload.dart';

class HomeBase extends ConsumerWidget {
  const HomeBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(homeBaseControllerProvider);
    controller.createInitialDataProvider();

    final userResponse = controller.getInitialData()?.userResponse ?? UserResponse();
    final initialData = ref.watch(controller.getInitialDataProvider()!);
    final navigationBarIndex = ref.watch(controller.getNavigationBarIndexProvider());

    final screens = [
      Home(initialDataModel: controller.getInitialData(), homeBaseController: controller),
      const EventScanner(),
      Profile(userResponse.user, controller),
    ];

    final organizerSreens = [
      Home(initialDataModel: controller.getInitialData(), homeBaseController: controller),
      Profile(userResponse.user, controller),
    ];

    final adminSreens = [
      Home(initialDataModel: controller.getInitialData(), homeBaseController: controller),
      const Statistic(),
      Profile(userResponse.user, controller),
    ];

    final appBarTitles = [
      appLocale?.home,
      Utils.getString(appLocale?.home_base_app_bar_title_qr),
      Utils.getString(appLocale?.profile),
    ];

    final organizerAppBarTitles = [appLocale?.home, Utils.getString(appLocale?.profile)];

    final adminAppBarTitles = [
      appLocale?.home,
      Utils.getString(appLocale?.home_base_navigation_bar_title_stats),
      Utils.getString(appLocale?.profile)
    ];

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
                  : initialData.userResponse.user.roleName == roleOrganizer
                      ? Text(organizerAppBarTitles[navigationBarIndex] as String)
                      : Text(adminAppBarTitles[navigationBarIndex] as String),
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
            return initialData.isOperationSuccessful
                ? RefreshIndicator(
                    child: initialData.userResponse.user.roleName == roleUser
                        ? screens[navigationBarIndex]
                        : initialData.userResponse.user.roleName == roleOrganizer
                            ? organizerSreens[navigationBarIndex]
                            : adminSreens[navigationBarIndex],
                    onRefresh: () => controller.invalidateInitialDataProvider(),
                  )
                : const BaseErrorScreen();
          },
        ),
        floatingActionButtonLocation: initialData.when(
            loading: () => null,
            error: (error, stackTrace) => null,
            data: (initialData) {
              return initialData.userResponse.user.roleName == roleOrganizer
                  ? FloatingActionButtonLocation.centerDocked
                  : FloatingActionButtonLocation.endFloat;
            }),
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
      AppLocalizations? appLocale, HomeBaseInitialPayload initialData) {
    return initialData.userResponse.user.roleName == roleUser
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
                label: Utils.getString(appLocale?.home_base_navigation_bar_title_qr),
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
        : initialData.userResponse.user.roleName == roleOrganizer
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
                    label: appLocale?.home_base_navigation_bar_title_stats,
                    icon: const Icon(Icons.bar_chart_outlined),
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
