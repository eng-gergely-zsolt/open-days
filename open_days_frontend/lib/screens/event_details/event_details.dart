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

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          SizedBox(
            width: appWidth * 1,
            height: appHeight * 0.25,
            child: Image.network(
              controller.getImageURL(),
              fit: BoxFit.fill,
              loadingBuilder:
                  (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
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
                    appWidth, appHeight, context, appLocale, initialData, controller),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDataHolderColumn(
    double appWidth,
    double appHeight,
    BuildContext context,
    AppLocalizations? appLocale,
    IsUserAppliedForEvent initialData,
    EventDetailsController controller,
  ) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Date
      Text(
        appLocale?.base_text_date as String,
        style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
          fontWeight: FontWeight.w600,
          color: CustomTheme.lightTheme.hintColor,
        ),
      ),
      SizedBox(height: appHeight * 0.01),
      Text(
        _event?.dateTime as String,
        style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
          fontSize: 18,
        ),
      ),
      SizedBox(height: appHeight * 0.02),
      Container(
        height: 1,
        width: double.infinity,
        color: CustomTheme.lightTheme.dividerColor,
      ),
      // Location / Link
      SizedBox(height: appHeight * 0.03),
      _event?.isOnline == true
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getString(appLocale?.base_text_link),
                  style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CustomTheme.lightTheme.hintColor,
                  ),
                ),
                SizedBox(height: appHeight * 0.01),
                Text(
                  (_event?.meetingLink as String),
                  style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
                    fontSize: 18,
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
                  style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CustomTheme.lightTheme.hintColor,
                  ),
                ),
                SizedBox(height: appHeight * 0.01),
                Text(
                  (_event?.location as String),
                  style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
                    fontSize: 18,
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
      // Organizer
      SizedBox(height: appHeight * 0.03),
      Text(
        Utils.getString(appLocale?.base_text_organizer),
        style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
          fontWeight: FontWeight.w600,
          color: CustomTheme.lightTheme.hintColor,
        ),
      ),
      SizedBox(height: appHeight * 0.01),
      Text(
        ('${_event?.organizerFirstName}, ${_event?.organizerLastName}'),
        style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
          fontSize: 18,
        ),
      ),
      SizedBox(height: appHeight * 0.02),
      Container(
        height: 1,
        width: double.infinity,
        color: CustomTheme.lightTheme.dividerColor,
      ),
      // Description
      SizedBox(height: appHeight * 0.03),
      Text(
        appLocale?.event_details_description as String,
        style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
          fontWeight: FontWeight.w600,
          color: CustomTheme.lightTheme.hintColor,
        ),
      ),
      SizedBox(height: appHeight * 0.01),
      Text(
        _event?.description as String,
        style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
          fontSize: 18,
          wordSpacing: 5.0,
        ),
      ),

      SizedBox(height: appHeight * 0.03),
      buildCreateQRButton(appWidth, appHeight, context, appLocale, controller),
      buildEntollButton(appWidth, appHeight, appLocale, initialData, controller),
    ]);
  }

  Widget buildEntollButton(double appWidth, double appHeight, AppLocalizations? appLocale,
      IsUserAppliedForEvent initialData, EventDetailsController controller) {
    return _roleName == roleUser
        ? Container(
            margin: EdgeInsets.only(bottom: appHeight * 0.03),
            child: Row(children: [
              initialData.isUserAppliedForEvent
                  ? ElevatedButton(
                      child: Text(
                        Utils.getString(appLocale?.event_details_unenroll),
                        style: TextStyle(
                          fontSize: appHeight * 0.025,
                        ),
                      ),
                      onPressed: () => controller.deleteUserFromEvent(),
                    )
                  : ElevatedButton(
                      child: Text(
                        Utils.getString(appLocale?.event_details_enroll),
                        style: TextStyle(
                          fontSize: appHeight * 0.025,
                        ),
                      ),
                      onPressed: () => controller.applyUserForEvent(),
                    )
            ]),
          )
        : const SizedBox.shrink();
  }

  Widget buildCreateQRButton(double appWidth, double appHeight, BuildContext context,
      AppLocalizations? appLocale, EventDetailsController controller) {
    return _roleName == roleAdmin || _roleName == roleOrganizer
        ? Container(
            margin: EdgeInsets.only(bottom: appHeight * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(
                    Utils.getString(appLocale?.event_details_create_qr_code).toUpperCase(),
                    style: TextStyle(
                      fontSize: appHeight * 0.025,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(appWidth * 0.6, 45),
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
              ],
            ),
          )
        : const SizedBox.shrink();
  }

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
