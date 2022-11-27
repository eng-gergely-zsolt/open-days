import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/theme.dart';
import './event_details_controller.dart';
import '../home_base/models/event_response_model.dart';

class EventDetails extends ConsumerWidget {
  final EventResponseModel? _event;
  const EventDetails(
    this._event, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final eventDetailsController = ref.read(eventDetailsControllerProvider);

    final isLoading = ref.watch(eventDetailsController.getIsLoading());
    final initialData = ref.watch(eventDetailsController.createInitialDataProvider(_event?.id));

    if (eventDetailsController.getEventParticipationResponse() != null &&
        eventDetailsController.getEventParticipationResponse()?.isOperationSuccessful == false) {
      const snackBar = SnackBar(
        content: Text('Something went wrong. Please try again!'),
      );

      Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));

      eventDetailsController.deleteEventParticipatonResponse();
    }

    return Scaffold(
      appBar: AppBar(
        title: _event == null ? Text(appLocale?.base_text_error as String) : Text(_event?.activityName as String),
      ),
      body: isLoading == true
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                size: appHeight * 0.1,
                color: const Color.fromRGBO(1, 30, 65, 1),
              ),
            )
          : _event == null
              ? const Center(
                  child: Text('Something went wrong'),
                )
              : initialData.when(
                  error: (error, stackTrace) => const Center(
                    child: Text('Something went wrong'),
                  ),
                  loading: () => Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      size: appHeight * 0.1,
                      color: const Color.fromRGBO(1, 30, 65, 1),
                    ),
                  ),
                  data: (initialData) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: appWidth * 0.05,
                        horizontal: appWidth * 0.05,
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: appHeight * 0.024,
                                  color: CustomTheme.lightTheme.hintColor,
                                ),
                              ),
                              SizedBox(height: appHeight * 0.01),
                              Text(
                                _event?.dateTime as String,
                                style: TextStyle(
                                  fontSize: appHeight * 0.024,
                                  color: CustomTheme.lightTheme.primaryColor,
                                ),
                              ),
                              SizedBox(height: appHeight * 0.02),
                              Container(
                                height: 1,
                                width: double.infinity,
                                color: CustomTheme.lightTheme.dividerColor,
                              )
                            ],
                          ),
                          SizedBox(height: appHeight * 0.03),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Organizer',
                                style: TextStyle(
                                  fontSize: appHeight * 0.024,
                                  color: CustomTheme.lightTheme.hintColor,
                                ),
                              ),
                              SizedBox(height: appHeight * 0.01),
                              Text(
                                ('${_event?.organizerFirstName}, ${_event?.organizerFirstName}'),
                                style: TextStyle(
                                  fontSize: appHeight * 0.024,
                                  color: CustomTheme.lightTheme.primaryColor,
                                ),
                              ),
                              SizedBox(height: appHeight * 0.02),
                              Container(
                                height: 1,
                                width: double.infinity,
                                color: CustomTheme.lightTheme.dividerColor,
                              )
                            ],
                          ),
                          SizedBox(height: appHeight * 0.03),
                          _event?.isOnline == true
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Meeting link',
                                      style: TextStyle(
                                        fontSize: appHeight * 0.024,
                                        color: CustomTheme.lightTheme.hintColor,
                                      ),
                                    ),
                                    SizedBox(height: appHeight * 0.01),
                                    Text(
                                      (_event?.meetingLink as String),
                                      style: TextStyle(
                                        fontSize: appHeight * 0.024,
                                        color: CustomTheme.lightTheme.primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: appHeight * 0.02),
                                    Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: CustomTheme.lightTheme.dividerColor,
                                    )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location',
                                      style: TextStyle(
                                        fontSize: appHeight * 0.024,
                                        color: CustomTheme.lightTheme.hintColor,
                                      ),
                                    ),
                                    SizedBox(height: appHeight * 0.01),
                                    Text(
                                      (_event?.location as String),
                                      style: TextStyle(
                                        fontSize: appHeight * 0.024,
                                        color: CustomTheme.lightTheme.primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: appHeight * 0.02),
                                    Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: CustomTheme.lightTheme.dividerColor,
                                    )
                                  ],
                                ),
                          SizedBox(height: appHeight * 0.05),
                          SizedBox(
                            width: appWidth * 0.6,
                            height: appHeight * 0.07,
                            child: initialData.isUserAppliedForEvent
                                ? OutlinedButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: appHeight * 0.025,
                                      ),
                                    ),
                                    onPressed: () => eventDetailsController.deleteUserFromEvent(),
                                  )
                                : ElevatedButton(
                                    child: Text(
                                      'Participate',
                                      style: TextStyle(
                                        fontSize: appHeight * 0.025,
                                      ),
                                    ),
                                    onPressed: () => eventDetailsController.applyUserForEvent(),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
