import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/theme.dart';
import './guest_mode_controller.dart';
import './guest_mode_event_details.dart';
import '../error/base_error_screen.dart';
import '../../constants/page_routes.dart';
import '../../models/responses/events_response.dart';

class GuestMode extends ConsumerWidget {
  const GuestMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(guestModeControllerProvider);
    final events = ref.watch(controller.getEventsProvider());
    String? orderValue = ref.watch(controller.getOrderValueProvider());

    return WillPopScope(
      onWillPop: controller.invalidateGuestModeControllerProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appLocale?.base_text_guest as String,
          ),
        ),
        body: events.when(
          error: (error, stackTrace) => const BaseErrorScreen(),
          loading: () => Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              size: appHeight * 0.1,
              color: const Color.fromRGBO(38, 70, 83, 1),
            ),
          ),
          data: (data) {
            orderValue = orderValue ?? appLocale?.order_by as String;

            return RefreshIndicator(
              onRefresh: () => controller.refreshEvents(),
              child: data.isOperationSuccessful
                  ? Column(
                      children: [
                        Container(
                          height: appHeight * 0.08,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomTheme.lightTheme.dividerColor,
                            ),
                          ),
                          padding: EdgeInsets.only(
                            left: appWidth * 0.1,
                            right: appWidth * 0.1,
                            top: appHeight * 0.02,
                          ),
                          child: Row(
                            children: [
                              Text(
                                appLocale?.events as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: Theme.of(context).iconTheme.color),
                              ),
                              const Spacer(),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: orderValue,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  items: [
                                    appLocale?.order_by as String,
                                    appLocale?.order_by_name as String,
                                    appLocale?.order_by_date as String,
                                  ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(color: Theme.of(context).iconTheme.color),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (String? newOrderValue) {
                                    controller.orderEvents(newOrderValue);
                                    controller.setOrderValue(newOrderValue);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: appHeight * 0.81,
                              padding: EdgeInsets.only(top: appHeight * 0.0),
                              child: getEventsListView(appWidth, appHeight, data),
                            ),
                            Positioned(
                              top: appHeight * 0.72,
                              left: appWidth * 0.2,
                              child: getSignUpSection(appWidth, appHeight, context, appLocale),
                            )
                          ],
                        ),
                      ],
                    )
                  : const BaseErrorScreen(),
            );
          },
        ),
      ),
    );
  }

  Widget getEventsListView(double appWidth, double appHeight, EventsResponse data) {
    return ListView.builder(
        itemCount: data.events.length,
        itemBuilder: (context, index) {
          final event = data.events[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => GuestModeEventDetails(
                      data.events[index],
                    )),
              ),
            ),
            child: Container(
              height: appHeight * 0.2,
              margin: EdgeInsets.all(appWidth * 0.02),
              child: Card(
                elevation: 5,
                color: const Color.fromRGBO(250, 250, 250, 1),
                shadowColor: CustomTheme.lightTheme.primaryColor,
                child: Row(children: [
                  Container(
                    height: double.infinity,
                    width: 10,
                    color: index % 3 == 0
                        ? const Color.fromRGBO(231, 111, 81, 1)
                        : index % 3 == 1
                            ? const Color.fromRGBO(42, 157, 143, 1)
                            : const Color.fromRGBO(233, 196, 106, 1),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: appWidth * 0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: appWidth * 0.6,
                          child: Text(
                            event.activityName.toUpperCase(),
                            style: Theme.of(context).textTheme.headline5?.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          event.dateTime,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Theme.of(context).iconTheme.color),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: appWidth * 0.1),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 27,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  )
                ]),
              ),
            ),
          );
        });
  }

  Widget getSignUpSection(
      double appWidth, double appHeight, BuildContext context, AppLocalizations? appLocale) {
    return Container(
      padding: EdgeInsets.only(
        top: appHeight * 0.01,
      ),
      color: Theme.of(context).primaryColor.withOpacity(0),
      child: ElevatedButton(
        child: Text(
          appLocale?.sign_up.toUpperCase() as String,
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(appWidth * 0.6, appWidth * 0.12),
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, registrationRoute);
        },
      ),
    );
  }
}
