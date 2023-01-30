import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import './event_creator_controller.dart';

class EventCreator extends ConsumerWidget {
  const EventCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final eventCreatorController = ref.read(eventCreatorControllerProvider);
    final isLoading = ref.watch(eventCreatorController.getIsLoadinProvider());
    final activities = ref.watch(eventCreatorController.getActivitiesProvider());
    final isOnlineMeeting = ref.watch(eventCreatorController.getIsOnlineMeetingProvider());
    final selectedDateTime = ref.watch(eventCreatorController.getSelectedDateTimeProvider());

    var selectedActivityName = ref.watch(eventCreatorController.getSelectedActivityProvider());

    if (eventCreatorController.getCreateEventResponse() != null) {
      SnackBar snackBar;

      if (eventCreatorController.getCreateEventResponse()?.isOperationSuccessful == true) {
        snackBar = const SnackBar(
          content: Text('Event created successfully'),
        );
      } else {
        snackBar = const SnackBar(
          content: Text('Something went wrong. Please try again!'),
        );
      }

      Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));
    }

    eventCreatorController.deleteCreateEventResponse();

    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text(appLocale?.event_creator_header as String)),
        ),
        body: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  size: appHeight * 0.1,
                  color: const Color.fromRGBO(1, 30, 65, 1),
                ),
              )
            : activities.when(
                error: (error, stackTrace) => const Center(),
                loading: () => Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        size: appHeight * 0.1,
                        color: const Color.fromRGBO(1, 30, 65, 1),
                      ),
                    ),
                data: (activities) {
                  selectedActivityName ??= activities.activities[0].name;

                  return activities.isOperationSuccessful == true && activities.activities.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: appWidth * 0.05),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: appHeight * 0.03),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: appWidth * 0.02),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedActivityName,
                                      icon: const Icon(Icons.arrow_downward),
                                      items: eventCreatorController
                                          .getAllActivityName(activities.activities)
                                          .map<DropdownMenuItem<String>>(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (String? value) {
                                        ref.read(eventCreatorController.getSelectedActivityProvider().notifier).state =
                                            value;
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                  margin: const EdgeInsets.symmetric(vertical: 30),
                                ),
                                // DATE SELECTOR
                                // -------------
                                Container(
                                  padding: EdgeInsets.only(
                                    left: appWidth * 0.02,
                                    bottom: appHeight * 0.01,
                                  ),
                                  child: Text(
                                    appLocale?.base_text_date as String,
                                    style: TextStyle(
                                      fontSize: appHeight * 0.026,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final date = await pickDate(context, selectedDateTime);

                                    eventCreatorController.setSelectedDate(date);
                                  },
                                  child: SizedBox(
                                    height: appHeight * 0.1,
                                    child: Card(
                                      elevation: 5,
                                      child: Row(children: [
                                        SizedBox(width: appWidth * 0.03),
                                        const Icon(
                                          Icons.date_range,
                                        ),
                                        SizedBox(width: appWidth * 0.03),
                                        Text(
                                          '${selectedDateTime.year}/${selectedDateTime.month}/${selectedDateTime.day}',
                                          style: TextStyle(
                                            fontSize: appHeight * 0.026,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          appLocale?.base_text_change as String,
                                          style: TextStyle(
                                            fontSize: appHeight * 0.026,
                                          ),
                                        ),
                                        SizedBox(width: appWidth * 0.03),
                                      ]),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                  margin: const EdgeInsets.symmetric(vertical: 30),
                                ),
                                // TIME SELECTOR
                                // -------------
                                Container(
                                  padding: EdgeInsets.only(
                                    left: appWidth * 0.02,
                                    bottom: appHeight * 0.01,
                                  ),
                                  child: Text(
                                    appLocale?.base_text_time as String,
                                    style: TextStyle(
                                      fontSize: appHeight * 0.026,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final time = await pickTime(context, selectedDateTime);

                                    eventCreatorController.setSelectedTime(time);
                                  },
                                  child: SizedBox(
                                    height: appHeight * 0.1,
                                    child: Card(
                                      elevation: 5,
                                      child: Row(children: [
                                        SizedBox(width: appWidth * 0.03),
                                        const Icon(
                                          Icons.timelapse,
                                        ),
                                        SizedBox(width: appWidth * 0.03),
                                        Text(
                                          eventCreatorController.getFormattedTime(selectedDateTime),
                                          style: TextStyle(
                                            fontSize: appHeight * 0.026,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          appLocale?.base_text_change as String,
                                          style: TextStyle(
                                            fontSize: appHeight * 0.026,
                                          ),
                                        ),
                                        SizedBox(width: appWidth * 0.03),
                                      ]),
                                    ),
                                  ),
                                ),
                                SizedBox(height: appHeight * 0.05),
                                // LOCATION TEXTFIELD
                                // ------------------
                                Container(
                                  padding: EdgeInsets.only(
                                    left: appWidth * 0.02,
                                    bottom: appHeight * 0.01,
                                  ),
                                  child: Text(
                                    appLocale?.base_text_location as String,
                                    style: TextStyle(
                                      fontSize: appHeight * 0.026,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  initialValue: eventCreatorController.getLocation(),
                                  onChanged: (location) => eventCreatorController.setLocation(location),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: appHeight * 0.05),
                                // MEETING LINK
                                // ------------
                                Container(
                                  padding: EdgeInsets.only(
                                    left: appWidth * 0.02,
                                    bottom: appHeight * 0.01,
                                  ),
                                  child: Text(
                                    appLocale?.event_creator_online_event as String,
                                    style: TextStyle(
                                      fontSize: appHeight * 0.026,
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  value: isOnlineMeeting,
                                  onChanged: ((value) => eventCreatorController.setIsOnlineMeetingProvider(value)),
                                ),
                                isOnlineMeeting
                                    ? TextFormField(
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        initialValue: eventCreatorController.getLink(),
                                        onChanged: (link) => eventCreatorController.setLink(link),
                                        decoration: InputDecoration(
                                          hintText: appLocale?.base_text_link as String,
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                SizedBox(height: appHeight * 0.05),
                                // Save button
                                // -----------
                                Container(
                                  width: double.infinity,
                                  height: appHeight * 0.07,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: appWidth * 0.1,
                                  ),
                                  child: ElevatedButton(
                                    child: const Text('Mentes'),
                                    onPressed: () => eventCreatorController.createEvent(selectedActivityName),
                                  ),
                                ),
                                SizedBox(height: appHeight * 0.05),
                              ],
                            ),
                          ),
                        )
                      : const Center();
                }),
      ),
    );
  }

  Future<TimeOfDay?> pickTime(context, DateTime selectedDateTime) => showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: selectedDateTime.hour,
        minute: selectedDateTime.minute,
      ));

  Future<DateTime?> pickDate(context, selectedDateTime) => showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
}
