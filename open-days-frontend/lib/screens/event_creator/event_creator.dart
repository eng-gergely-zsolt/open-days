import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/theme.dart';
import './event_creator_controller.dart';
import '../../utils/helper_widget_utils.dart';
import '../../models/responses/activities_response.dart';

class EventCreator extends ConsumerWidget {
  const EventCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(eventCreatorControllerProvider);
    var imagePath = ref.watch(controller.getImagePathProvider());
    final isLoading = ref.watch(controller.getIsLoadinProvider());
    final activities = ref.watch(controller.getActivitiesProvider());
    final isOnlineMeeting = ref.watch(controller.getIsOnlineMeetingProvider());
    final selectedDateTime = ref.watch(controller.getSelectedDateTimeProvider());

    var selectedActivityName = ref.watch(controller.getSelectedActivityProvider());

    if (controller.getCreateEventResponse() != null) {
      SnackBar snackBar;

      if (controller.getCreateEventResponse()?.isOperationSuccessful == true) {
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

    controller.deleteCreateEventResponse();

    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: WillPopScope(
        onWillPop: (() => controller.invalidateControllerProvider()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(appLocale?.event_creator_header as String),
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

                    return activities.isOperationSuccessful == true &&
                            activities.activities.isNotEmpty
                        ? SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: appWidth * 1,
                                  height: appHeight * 0.25,
                                  child: imagePath == ''
                                      ? Image.network(
                                          controller.getImageUrl(),
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            return HelperWidgetUtils
                                                .getImageCircularProgressIndicator(
                                              child,
                                              loadingProgress,
                                            );
                                          },
                                        )
                                      : Image.file(
                                          File(imagePath),
                                          fit: BoxFit.fill,
                                        ),
                                ),
                                Positioned(
                                  top: appHeight * 0.22,
                                  child: Container(
                                    width: appWidth * 1,
                                    height: appHeight * 0.7,
                                    padding: EdgeInsets.symmetric(
                                      vertical: appWidth * 0.05,
                                      horizontal: appWidth * 0.05,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(30),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: buildDataHolderColumn(
                                        ref,
                                        appWidth,
                                        appHeight,
                                        isOnlineMeeting,
                                        context,
                                        selectedDateTime,
                                        appLocale,
                                        selectedActivityName,
                                        controller,
                                        activities,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : const Center();
                  }),
        ),
      ),
    );
  }

  Widget buildDataHolderColumn(
    WidgetRef ref,
    double appWidth,
    double appHeight,
    bool isOnlineMeeting,
    BuildContext context,
    DateTime selectedDateTime,
    AppLocalizations? appLocale,
    String? selectedActivityName,
    EventCreatorController controller,
    ActivitiesResponse activities,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location
        Text(
          appLocale?.base_text_location as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          onChanged: (location) => controller.setLocation(location),
        ),

        // Description
        SizedBox(height: appHeight * 0.03),
        Text(
          appLocale?.event_modification_description as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        TextFormField(
          maxLines: null,
          maxLength: 255,
          keyboardType: TextInputType.multiline,
          onChanged: (description) => controller.setDescription(description),
        ),

        // Activity
        SizedBox(height: appHeight * 0.03),
        Text(
          appLocale?.event_modification_activity as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: CustomTheme.lightTheme.dividerColor,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedActivityName,
              icon: const Icon(Icons.arrow_downward),
              items: controller
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
                ref.read(controller.getSelectedActivityProvider().notifier).state = value;
              },
            ),
          ),
        ),

        // Meeting link
        SizedBox(height: appHeight * 0.03),
        Row(
          children: [
            SizedBox(
              child: Text(
                appLocale?.event_creator_online_event as String,
                style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
            const Spacer(),
            Switch(
              value: isOnlineMeeting,
              onChanged: ((value) => controller.setIsOnlineMeetingProvider(value)),
            ),
          ],
        ),
        isOnlineMeeting
            ? TextFormField(
                maxLines: null,
                initialValue: controller.getLink(),
                keyboardType: TextInputType.multiline,
                onChanged: (link) => controller.setLink(link),
                decoration: InputDecoration(
                  hintText: appLocale?.base_text_link as String,
                ),
              )
            : Container(
                height: 1,
                width: double.infinity,
                color: CustomTheme.lightTheme.dividerColor,
              ),

        // Image
        SizedBox(height: appHeight * 0.03),
        Text(
          appLocale?.event_modification_image as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        SizedBox(height: appHeight * 0.01),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            child: Text(
              appLocale?.event_modification_upload_image as String,
              style: CustomTheme.lightTheme.textTheme.button?.copyWith(color: Colors.black),
            ),
            onPressed: () {
              controller.selectImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomTheme.lightTheme.cardColor,
              textStyle: CustomTheme.lightTheme.textTheme.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
        ),

        // Date selector
        SizedBox(height: appHeight * 0.03),
        Text(
          appLocale?.base_text_date as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        SizedBox(height: appHeight * 0.01),
        GestureDetector(
          onTap: () async {
            final date = await pickDate(context, selectedDateTime);
            controller.setSelectedDate(date);
          },
          child: SizedBox(
            height: appHeight * 0.07,
            child: Card(
              elevation: 5,
              margin: EdgeInsets.zero,
              child: Row(children: [
                SizedBox(width: appWidth * 0.03),
                const Icon(Icons.date_range),
                SizedBox(width: appWidth * 0.03),
                Text(
                  '${selectedDateTime.year}/${selectedDateTime.month}/${selectedDateTime.day}',
                  style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.edit),
                SizedBox(width: appWidth * 0.05),
              ]),
            ),
          ),
        ),

        // Time selector
        SizedBox(height: appHeight * 0.03),
        Text(
          appLocale?.base_text_time as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        SizedBox(height: appHeight * 0.01),
        GestureDetector(
          onTap: () async {
            final time = await pickTime(context, selectedDateTime);
            controller.setSelectedTime(time);
          },
          child: SizedBox(
            height: appHeight * 0.07,
            child: Card(
              elevation: 5,
              margin: EdgeInsets.zero,
              child: Row(children: [
                SizedBox(width: appWidth * 0.03),
                const Icon(Icons.timelapse),
                SizedBox(width: appWidth * 0.03),
                Text(
                  controller.getFormattedTime(selectedDateTime),
                  style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.edit),
                SizedBox(width: appWidth * 0.05),
              ]),
            ),
          ),
        ),

        // Save button
        SizedBox(height: appHeight * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text(
                appLocale?.event_creator_main_button as String,
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(appWidth * 0.9, 50),
              ),
              onPressed: () => controller.createEvent(selectedActivityName),
            ),
          ],
        ),
        SizedBox(height: appHeight * 0.05),
      ],
    );
  }

  Future<DateTime?> pickDate(context, selectedDateTime) => showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            child: child as Widget,
            data: Theme.of(context).copyWith(
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: CustomTheme.lightTheme.textTheme.bodyText1,
                ),
              ),
            ),
          );
        },
      );

  Future<TimeOfDay?> pickTime(context, DateTime selectedDateTime) => showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: selectedDateTime.hour,
          minute: selectedDateTime.minute,
        ),
        builder: (context, child) {
          return Theme(
            child: child as Widget,
            data: Theme.of(context).copyWith(
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: CustomTheme.lightTheme.textTheme.bodyText1,
                ),
              ),
            ),
          );
        },
      );
}
