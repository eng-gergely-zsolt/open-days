import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/theme.dart';
import '../../utils/utils.dart';
import '../../models/event.dart';
import '../../constants/constants.dart';
import './event_details_controller.dart';
import '../../utils/custom_date_utils.dart';
import './models/event_details_initial_data.dart';

class EventDetails extends ConsumerWidget {
  final Event _event;
  final String _roleName;

  const EventDetails(this._event, this._roleName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(eventDetailsControllerProvider);

    final isLoading = ref.watch(controller.getIsLoading());
    final initialDataHolder = ref.watch(controller.createInitialDataProvider(
        _event.id, _event.dateTime, _roleName, _event.imagePath));

    final isPastDateTime = CustomDateUtils.isPastDate(_event.dateTime);

    ref.watch(controller.getReloadProvider());
    controller.setQrImageText(_event.id.toString());

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
        appBar: AppBar(title: Text(_event.activityName)),
        body: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  size: appHeight * 0.1,
                  color: const Color.fromRGBO(38, 70, 83, 1),
                ),
              )
            : initialDataHolder.when(
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
                  return buildPage(isPastDateTime, context, controller, initialData);
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: initialDataHolder.when(
            loading: () => null,
            error: (error, stackTrace) => null,
            data: (initialData) {
              return buildFloatingButton(appWidth, appHeight, context, appLocale, controller);
            }),
      ),
    );
  }

  Widget buildPage(
    bool isPastDateTime,
    BuildContext context,
    EventDetailsController controller,
    EventDetailsInitialData initialData,
  ) {
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
                controller: controller.getScrollViewController(),
                child: buildDataHolderColumn(appWidth, appHeight, isPastDateTime, context,
                    appLocale, controller, initialData),
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
    bool isPastDateTime,
    BuildContext context,
    AppLocalizations? appLocale,
    EventDetailsController controller,
    EventDetailsInitialData initialData,
  ) {
    var isDescriptionAvailable = _event.description != '';

    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            _event.dateTime,
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
          _event.isOnline
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
                      (_event.meetingLink as String),
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
                      (_event.location),
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
            ('${_event.organizerFirstName}, ${_event.organizerLastName}'),
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
          isDescriptionAvailable ? SizedBox(height: appHeight * 0.03) : const SizedBox.shrink(),
          isDescriptionAvailable
              ? Text(
                  appLocale?.event_details_description as String,
                  style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CustomTheme.lightTheme.hintColor,
                  ),
                )
              : const SizedBox.shrink(),
          isDescriptionAvailable ? SizedBox(height: appHeight * 0.01) : const SizedBox.shrink(),
          Text(
            _event.description,
            style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
              fontSize: 18,
              wordSpacing: 5.0,
            ),
          ),
          SizedBox(height: appHeight * 0.03),

          // Enrolled users
          _roleName == roleOrganizer && initialData.usersResponse.users.isNotEmpty
              ? Text(
                  isPastDateTime
                      ? appLocale?.event_details_participated_users as String
                      : appLocale?.event_details_enrolled_users as String,
                  style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CustomTheme.lightTheme.hintColor,
                  ),
                )
              : const SizedBox.shrink(),
          SizedBox(height: appHeight * 0.01),
          _roleName == roleOrganizer &&
                  initialData.usersResponse.isOperationSuccessful &&
                  initialData.usersResponse.users.isNotEmpty
              ? SizedBox(
                  width: appWidth * 1,
                  height: appHeight * 0.7,
                  child: ListView.builder(
                    controller: controller.getListViewController(),
                    itemCount: initialData.usersResponse.users.length,
                    physics: controller.isListViewActive()
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: appHeight * 0.01,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: const Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                color: index % 3 == 0
                                    ? const Color.fromRGBO(231, 111, 81, 1)
                                    : index % 3 == 1
                                        ? const Color.fromRGBO(42, 157, 143, 1)
                                        : const Color.fromRGBO(233, 196, 106, 1),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: appWidth * 0.03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  initialData.usersResponse.users[index].firstName +
                                      ' ' +
                                      initialData.usersResponse.users[index].lastName,
                                  style:
                                      Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
                                ),
                                Text(initialData.usersResponse.users[index].institutionName),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                )
              : const SizedBox.shrink()
        ]);
  }

  Widget buildFloatingButton(
    double appWidth,
    double appHeight,
    BuildContext context,
    AppLocalizations? appLocale,
    EventDetailsController controller,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: appHeight * 0.03),
      child: SizedBox(
        height: 45,
        width: appWidth * 0.6,
        child: _roleName == roleUser
            ? buildEnrollButton(appWidth, appHeight, appLocale, controller)
            : FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  Utils.getString(appLocale?.event_details_create_qr_code).toUpperCase(),
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
      ),
    );
  }

  Widget buildEnrollButton(double appWidth, double appHeight, AppLocalizations? appLocale,
      EventDetailsController controller) {
    return controller.isUserEnrolled()
        ? FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              Utils.getString(appLocale?.event_details_unenroll).toUpperCase(),
              style: TextStyle(
                fontSize: appHeight * 0.025,
              ),
            ),
            onPressed: () => controller.unenrollUser(),
          )
        : FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              Utils.getString(appLocale?.event_details_enroll).toUpperCase(),
              style: TextStyle(
                fontSize: appHeight * 0.025,
              ),
            ),
            onPressed: () => controller.enrollUser(),
          );
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
