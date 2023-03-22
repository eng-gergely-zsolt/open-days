import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_days_frontend/screens/home_base/models/get_all_event_model.dart';

import '../error/base_error.dart';
import './guest_mode_controller.dart';
import '../../constants/constants.dart';
import '../../constants/page_routes.dart';
import '../event_details/event_details.dart';

class GuestMode extends ConsumerWidget {
  const GuestMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(guestModeControllerProvider);
    final events = ref.watch(controller.getEventsProvider());

    return WillPopScope(
      onWillPop: controller.invalidateGuestModeControllerProvider,
      child: Scaffold(
        body: events.when(
          error: (error, stackTrace) => const BaseError(),
          loading: () => Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              size: appHeight * 0.1,
              color: const Color.fromRGBO(1, 30, 65, 1),
            ),
          ),
          data: (data) {
            return RefreshIndicator(
              onRefresh: () => controller.refreshEvents(),
              child: data.operationResult == operationResultSuccess
                  ? Column(
                      children: [
                        Container(
                            height: appHeight * 0.9,
                            color: const Color.fromRGBO(220, 220, 220, 0.7),
                            child: getEventsListView(appWidth, appHeight, data)),
                        getSignUpSection(appWidth, appHeight, context, appLocale)
                      ],
                    )
                  : const BaseError(),
            );
          },
        ),
      ),
    );
  }

  Widget getEventsListView(double appWidth, double appHeight, GetAllEventModel data) {
    return ListView.builder(
        itemCount: data.events.length,
        itemBuilder: (context, index) {
          final event = data.events[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => EventDetails(
                      data.events[index],
                      "",
                    )),
              ),
            ),
            child: Container(
              width: appWidth * 0.8,
              height: appHeight * 0.2,
              margin: EdgeInsets.all(appWidth * 0.01),
              child: Card(
                elevation: 5,
                shadowColor: const Color.fromRGBO(1, 30, 65, 1),
                child: Row(children: [
                  Container(
                    margin: EdgeInsets.only(left: appWidth * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.activityName,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          event.dateTime,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          (event.organizerFirstName) + ' ' + (event.organizerFirstName),
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: appWidth * 0.04),
                    child: const Icon(Icons.arrow_forward_ios),
                  )
                ]),
              ),
            ),
          );
        });
  }

  Widget getSignUpSection(
      double appWidth, double appHeight, BuildContext context, AppLocalizations? appLocale) {
    return SizedBox(
      height: appHeight * 0.1,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 45.0,
            width: appWidth * 0.6,
            child: ElevatedButton(
              child: Text(
                appLocale?.sign_up.toUpperCase() as String,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, registrationRoute);
              },
            ),
          ),
        ],
      ),
    );
  }
}
