import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import './event_creator_controller.dart';

class EventCreator extends ConsumerWidget {
  const EventCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _appLocale = AppLocalizations.of(context);
    final _appWidth = MediaQuery.of(context).size.width;
    final _appHeight = MediaQuery.of(context).size.height;

    final _eventCreatorController = ref.read(eventCreatorControllerProvider);

    final _activities =
        ref.watch(_eventCreatorController.getActivitiesProvider());

    final _isOnlineMeeting =
        ref.watch(_eventCreatorController.getIsOnlineMeetingProvider());

    final _selectedDateTime =
        ref.watch(_eventCreatorController.getSelectedDateTimeProvider());

    var _selectedActivityName =
        ref.watch(_eventCreatorController.getSelectedActivityProvider());

    final isLoading = ref.watch(_eventCreatorController.getIsLoadinProvider());

    if (_eventCreatorController.getCreateEventResponse() != null) {
      SnackBar snackBar;

      if (_eventCreatorController
              .getCreateEventResponse()
              ?.isOperationSuccessful ==
          true) {
        snackBar = const SnackBar(
          content: Text('Event created successfully'),
        );
      } else {
        snackBar = const SnackBar(
          content: Text('Something went wrong. Please try again!'),
        );
      }

      Future.microtask(
          () => ScaffoldMessenger.of(context).showSnackBar(snackBar));
    }

    _eventCreatorController.deleteCreateEventResponse();

    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:
              Center(child: Text(_appLocale?.event_creator_header as String)),
        ),
        body: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  size: _appHeight * 0.1,
                  color: const Color.fromRGBO(1, 30, 65, 1),
                ),
              )
            : _activities.when(
                error: (error, stackTrace) => const Center(),
                loading: () => Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        size: _appHeight * 0.1,
                        color: const Color.fromRGBO(1, 30, 65, 1),
                      ),
                    ),
                data: (activities) {
                  _selectedActivityName ??= activities.activities[0].name;

                  return activities.isOperationSuccessful == true &&
                          activities.activities.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: _appWidth * 0.05),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: _appHeight * 0.03),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _appWidth * 0.02),
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
                                      value: _selectedActivityName,
                                      icon: const Icon(Icons.arrow_downward),
                                      items: _eventCreatorController
                                          .getAllActivityName(
                                              activities.activities)
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
                                            .read(_eventCreatorController
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 30),
                                ),
                                // DATE SELECTOR
                                // -------------
                                Container(
                                  padding: EdgeInsets.only(
                                    left: _appWidth * 0.02,
                                    bottom: _appHeight * 0.01,
                                  ),
                                  child: Text(
                                    _appLocale?.base_text_date as String,
                                    style: TextStyle(
                                      fontSize: _appHeight * 0.026,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final date = await pickDate(
                                        context, _selectedDateTime);

                                    _eventCreatorController
                                        .setSelectedDate(date);
                                  },
                                  child: SizedBox(
                                    height: _appHeight * 0.1,
                                    child: Card(
                                      elevation: 5,
                                      child: Row(children: [
                                        SizedBox(width: _appWidth * 0.03),
                                        const Icon(
                                          Icons.date_range,
                                        ),
                                        SizedBox(width: _appWidth * 0.03),
                                        Text(
                                          '${_selectedDateTime.year}/${_selectedDateTime.month}/${_selectedDateTime.day}',
                                          style: TextStyle(
                                            fontSize: _appHeight * 0.026,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          _appLocale?.base_text_change
                                              as String,
                                          style: TextStyle(
                                            fontSize: _appHeight * 0.026,
                                          ),
                                        ),
                                        SizedBox(width: _appWidth * 0.03),
                                      ]),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 30),
                                ),
                                // TIME SELECTOR
                                // -------------
                                Container(
                                  padding: EdgeInsets.only(
                                    left: _appWidth * 0.02,
                                    bottom: _appHeight * 0.01,
                                  ),
                                  child: Text(
                                    _appLocale?.base_text_time as String,
                                    style: TextStyle(
                                      fontSize: _appHeight * 0.026,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final time = await pickTime(
                                        context, _selectedDateTime);

                                    _eventCreatorController
                                        .setSelectedTime(time);
                                  },
                                  child: SizedBox(
                                    height: _appHeight * 0.1,
                                    child: Card(
                                      elevation: 5,
                                      child: Row(children: [
                                        SizedBox(width: _appWidth * 0.03),
                                        const Icon(
                                          Icons.timelapse,
                                        ),
                                        SizedBox(width: _appWidth * 0.03),
                                        Text(
                                          _eventCreatorController
                                              .getFormattedTime(
                                                  _selectedDateTime),
                                          style: TextStyle(
                                            fontSize: _appHeight * 0.026,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          _appLocale?.base_text_change
                                              as String,
                                          style: TextStyle(
                                            fontSize: _appHeight * 0.026,
                                          ),
                                        ),
                                        SizedBox(width: _appWidth * 0.03),
                                      ]),
                                    ),
                                  ),
                                ),
                                SizedBox(height: _appHeight * 0.05),
                                // LOCATION TEXTFIELD
                                // ------------------
                                Container(
                                  padding: EdgeInsets.only(
                                    left: _appWidth * 0.02,
                                    bottom: _appHeight * 0.01,
                                  ),
                                  child: Text(
                                    _appLocale?.base_text_location as String,
                                    style: TextStyle(
                                      fontSize: _appHeight * 0.026,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  initialValue:
                                      _eventCreatorController.getLocation(),
                                  onChanged: (location) =>
                                      _eventCreatorController
                                          .setLocation(location),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: _appHeight * 0.05),
                                // MEETING LINK
                                // ------------
                                Container(
                                  padding: EdgeInsets.only(
                                    left: _appWidth * 0.02,
                                    bottom: _appHeight * 0.01,
                                  ),
                                  child: Text(
                                    _appLocale?.event_creator_online_event
                                        as String,
                                    style: TextStyle(
                                      fontSize: _appHeight * 0.026,
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  value: _isOnlineMeeting,
                                  onChanged: ((value) => _eventCreatorController
                                      .setIsOnlineMeetingProvider(value)),
                                ),
                                _isOnlineMeeting
                                    ? TextFormField(
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        initialValue:
                                            _eventCreatorController.getLink(),
                                        onChanged: (link) =>
                                            _eventCreatorController
                                                .setLink(link),
                                        decoration: InputDecoration(
                                          hintText: _appLocale?.base_text_link
                                              as String,
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                SizedBox(height: _appHeight * 0.05),
                                // Save button
                                // -----------
                                Container(
                                  width: double.infinity,
                                  height: _appHeight * 0.07,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: _appWidth * 0.1,
                                  ),
                                  child: ElevatedButton(
                                    child: const Text('Mentes'),
                                    onPressed: () => _eventCreatorController
                                        .createEvent(_selectedActivityName),
                                  ),
                                ),
                                SizedBox(height: _appHeight * 0.05),
                              ],
                            ),
                          ),
                        )
                      : const Center();
                }),
      ),
    );
  }

  Future<TimeOfDay?> pickTime(context, DateTime selectedDateTime) =>
      showTimePicker(
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
