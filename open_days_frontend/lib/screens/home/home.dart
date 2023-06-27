import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './home_controller.dart';
import '../../theme/theme.dart';
import '../../models/event.dart';
import '../../constants/constants.dart';
import '../../utils/custom_date_utils.dart';
import '../event_details/event_details.dart';
import '../home_base/home_base_controller.dart';
import '../event_modification/event_modification.dart';
import '../home_base/models/home_base_initial_payload.dart';

class Home extends ConsumerStatefulWidget {
  final HomeBaseInitialPayload? _initialData;

  const Home(
      {Key? key,
      required HomeBaseInitialPayload? initialDataModel,
      required HomeBaseController homeBaseController})
      : _initialData = initialDataModel,
        super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;
    final appLocale = AppLocalizations.of(context);

    final homeController = ref.read(homeControllerProvider);
    final homeBaseController = ref.read(homeBaseControllerProvider);
    String? orderValue = ref.watch(homeBaseController.getOrderValueProvider());

    orderValue = orderValue ?? appLocale?.order_by as String;

    return Container(
      height: appHeight * 1,
      color: CustomTheme.lightTheme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // Order section
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
                      homeBaseController.orderEvents(newOrderValue);
                      homeBaseController.setOrderValue(newOrderValue);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Event
          Expanded(
            child: ListView.builder(
                itemCount: widget._initialData?.eventsResponse.events.length,
                itemBuilder: (context, index) {
                  final event = widget._initialData?.eventsResponse.events[index];

                  final isPastDate = CustomDateUtils.isPastDate(
                      widget._initialData?.eventsResponse.events[index].dateTime ?? '');

                  Widget result = GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => EventDetails(
                              widget._initialData?.eventsResponse.events[index] ?? Event(),
                              widget._initialData?.userResponse.user.roleName ?? '',
                            )),
                      ),
                    ),
                    child: Container(
                      width: appWidth * 0.8,
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
                            color: isPastDate
                                ? const Color.fromRGBO(231, 111, 81, 1)
                                : index % 3 == 0
                                    ? const Color.fromRGBO(42, 157, 143, 1)
                                    : index % 3 == 1
                                        ? const Color.fromRGBO(99, 174, 183, 1)
                                        : const Color.fromRGBO(233, 196, 106, 1),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: appWidth * 0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: appWidth * 0.60,
                                  child: Text(
                                    event?.activityName as String,
                                    style: Theme.of(context).textTheme.headline5?.copyWith(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  event?.dateTime as String,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(color: Theme.of(context).iconTheme.color),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const Spacer(),
                          widget._initialData?.userResponse.user.roleName == roleOrganizer ||
                                  widget._initialData?.userResponse.user.roleName == roleAdmin
                              ? Container(
                                  margin: EdgeInsets.only(right: appWidth * 0.05),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                          ),
                                          onPressed: () {
                                            homeBaseController.invalidateInitialDataProvider();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EventModification(widget
                                                    ._initialData?.eventsResponse.events[index]),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                          ),
                                          onPressed: () {
                                            homeController.deleteEvent(
                                                widget._initialData?.eventsResponse.events[index].id
                                                    as int,
                                                homeBaseController);
                                            setState(() {
                                              widget._initialData?.eventsResponse.events
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      widget._initialData?.eventsResponse
                                                          .events[index].id);
                                            });
                                          },
                                        ),
                                      ]),
                                )
                              : Container(
                                  margin: EdgeInsets.only(right: appWidth * 0.04),
                                  child: const Icon(Icons.arrow_forward_ios),
                                )
                        ]),
                      ),
                    ),
                  );
                  return result;
                }),
          ),
        ],
      ),
    );
  }
}
