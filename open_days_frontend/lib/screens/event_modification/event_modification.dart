import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import './event_modification_controller.dart';
import '../home_base/models/event_response_model.dart';

/// This class holds the event modification screen.
class EventModification extends ConsumerWidget {
  final EventResponseModel? _event;

  const EventModification(this._event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final eventModificationController = ref.read(eventModificationControllerProvider);

    eventModificationController.initializeMeetingProvider(_event?.isOnline);

    final isLoading = ref.watch(eventModificationController.getIsLoadinProvider());
    final activities = ref.watch(eventModificationController.getActivitiesProvoder());
    var isOnlineMeeting = ref.watch(eventModificationController.getIsOnlineMeetingProvider()!);
    final selectedDateTime =
        ref.watch(eventModificationController.getSelectedDateTimeProvider(_event?.dateTime));

    var selectedActivityName = ref.watch(eventModificationController.getSelectedActivityProvider());

    if (eventModificationController.getUpdateEventResponse() != null) {
      SnackBar snackBar;

      if (eventModificationController.getUpdateEventResponse()?.isOperationSuccessful == true) {
        snackBar = const SnackBar(
          content: Text('Event updated successfully'),
        );
      } else {
        snackBar = const SnackBar(
          content: Text('Something went wrong. Please try again!'),
        );
      }

      Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));
    }

    eventModificationController.deleteUpdateEventResponse();

    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text(appLocale?.event_modification_header as String)),
        ),
        body: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  size: appHeight * 0.1,
                  color: const Color.fromRGBO(38, 70, 83, 1),
                ),
              )
            : activities.when(
                error: (error, stackTrace) => const Center(),
                loading: () => Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        size: appHeight * 0.1,
                        color: const Color.fromRGBO(38, 70, 83, 1),
                      ),
                    ),
                data: (activities) {
                  selectedActivityName ??= activities.activities[0].name;
                  isOnlineMeeting ??= _event?.isOnline;

                  return Container(
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
                                items: eventModificationController
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
                                  ref
                                      .read(eventModificationController
                                          .getSelectedActivityProvider()
                                          .notifier)
                                      .state = value;
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

                              eventModificationController.setSelectedDate(date);
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

                              eventModificationController.setSelectedTime(time);
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
                                    eventModificationController.getFormattedTime(selectedDateTime),
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
                            initialValue: _event?.location,
                            onChanged: (location) =>
                                eventModificationController.setLocation(location),
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
                            onChanged: ((value) =>
                                eventModificationController.setIsOnlineMeetingProvider(value)),
                          ),
                          isOnlineMeeting as bool
                              ? TextFormField(
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  initialValue: _event?.meetingLink,
                                  onChanged: (link) => eventModificationController.setLink(link),
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
                                onPressed: () {
                                  eventModificationController.saveChanges(
                                      _event?.id, selectedActivityName);
                                }),
                          ),
                          SizedBox(height: appHeight * 0.05),
                        ],
                      ),
                    ),
                  );
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
