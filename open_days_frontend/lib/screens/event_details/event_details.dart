import 'package:flutter/material.dart';
import 'package:open_days_frontend/constants/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/theme.dart';
import '../../utils/utils.dart';
import './event_details_controller.dart';
import '../home_base/models/event_response_model.dart';
import 'models/is_user_applied_for_event.dart';

class EventDetails extends ConsumerWidget {
  final String? _roleName;
  final EventResponseModel? _event;
  const EventDetails(
    this._event,
    this._roleName, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(eventDetailsControllerProvider);

    final isLoading = ref.watch(controller.getIsLoading());
    final initialData =
        ref.watch(controller.createInitialDataProvider(_event?.id, _event?.imageLink));

    controller.setQrImageText(_event?.id.toString() as String);

    if (controller.getEventParticipationResponse() != null &&
        controller.getEventParticipationResponse()?.isOperationSuccessful == false) {
      var snackBar = SnackBar(
        content: Text(
          Utils.getString(appLocale?.base_text_general_try_again_message),
        ),
      );

      Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));

      controller.deleteEventParticipatonResponse();
    }

    return WillPopScope(
      onWillPop: controller.invalidateControllerProvider,
      child: Scaffold(
        appBar: AppBar(
          title: _event == null
              ? Text(appLocale?.base_text_error as String)
              : Text(_event?.activityName as String),
        ),
        body: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  size: appHeight * 0.1,
                  color: const Color.fromRGBO(38, 70, 83, 1),
                ),
              )
            : _event == null
                ? Center(
                    child: Text(Utils.getString(appLocale?.base_text_general_error_message)),
                  )
                : initialData.when(
                    error: (error, stackTrace) => Center(
                      child: Text(Utils.getString(appLocale?.base_text_general_error_message)),
                    ),
                    loading: () => Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        size: appHeight * 0.1,
                        color: const Color.fromRGBO(38, 70, 83, 1),
                      ),
                    ),
                    data: (initialData) {
                      return buildPage(context, initialData, controller);
                    },
                  ),
      ),
    );
  }

  Widget buildPage(
      BuildContext context, IsUserAppliedForEvent initialData, EventDetailsController controller) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: appHeight * 0.2,
          child: Image.network(
            controller.getImageURL(),
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
        Positioned(
          child: Container(
            color: Colors.amber,
            height: appHeight * 0.5,
            padding: EdgeInsets.symmetric(
              vertical: appWidth * 0.05,
              horizontal: appWidth * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appLocale?.base_text_date as String,
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
                ),
                SizedBox(height: appHeight * 0.03),
                Text(
                  Utils.getString(appLocale?.base_text_organizer),
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
                ),
                SizedBox(height: appHeight * 0.03),
                _event?.isOnline == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getString(appLocale?.base_text_link),
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
                            Utils.getString(appLocale?.base_text_location),
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
                _roleName == roleUser
                    ? SizedBox(
                        width: appWidth * 0.6,
                        height: appHeight * 0.07,
                        child: initialData.isUserAppliedForEvent
                            ? OutlinedButton(
                                child: Text(
                                  Utils.getString(appLocale?.event_details_cancel_participation),
                                  style: TextStyle(
                                    fontSize: appHeight * 0.025,
                                  ),
                                ),
                                onPressed: () => controller.deleteUserFromEvent(),
                              )
                            : ElevatedButton(
                                child: Text(
                                  Utils.getString(appLocale?.event_details_participate),
                                  style: TextStyle(
                                    fontSize: appHeight * 0.025,
                                  ),
                                ),
                                onPressed: () => controller.applyUserForEvent(),
                              ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: appHeight * 0.04),
                _roleName == roleAdmin || _roleName == roleOrganizer
                    ? SizedBox(
                        width: appWidth * 0.6,
                        height: appHeight * 0.07,
                        child: OutlinedButton(
                          child: Text(
                            Utils.getString(appLocale?.event_details_create_qr_code),
                            style: TextStyle(
                              fontSize: appHeight * 0.025,
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return buildModalBottomSheet(context, controller);
                                });
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget buildButton() {
  //   return
  // }

  Widget buildModalBottomSheet(
      BuildContext context, EventDetailsController eventDetailsController) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: appHeight * 0.85,
      child: Column(children: [
        SizedBox(height: appHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: appWidth * 0.02),
              child: SizedBox(
                width: appWidth * 0.08,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_downward,
                    size: appHeight * 0.04,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Text(
              Utils.getString(appLocale?.event_details_qr_code),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: appHeight * 0.032,
              ),
            ),
            SizedBox(width: appWidth * 0.08)
          ],
        ),
        SizedBox(height: appHeight * 0.1),
        QrImage(
          size: appHeight * 0.55,
          data: eventDetailsController.getQrImageText(),
        )
      ]),
    );
  }
}
