import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/theme.dart';
import '../../utils/utils.dart';
import '../../models/event.dart';
import './guest_mode_event_details_controller.dart';

class GuestModeEventDetails extends ConsumerWidget {
  final Event? _event;

  const GuestModeEventDetails(this._event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(guestModeEventDetailsControllerProvider);
    final initialDataAsync = ref.watch(controller.createInitialDataProvider(_event?.imagePath));

    return WillPopScope(
      onWillPop: controller.invalidateControllerProvider,
      child: Scaffold(
        appBar: AppBar(
          title: _event == null
              ? Text(appLocale?.base_text_error as String)
              : Text(_event?.activityName as String),
        ),
        body: initialDataAsync.when(
          error: (error, stackTrace) => Center(
            child: Text(Utils.getString(appLocale?.base_text_general_error_message)),
          ),
          loading: () => Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              size: appHeight * 0.1,
              color: const Color.fromRGBO(38, 70, 83, 1),
            ),
          ),
          data: (imageUrl) {
            return buildPage(context, imageUrl);
          },
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context, String imageUrl) {
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
              imageUrl,
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
                child: Column(
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
                                _event?.meetingLink as String,
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
                                _event?.location as String,
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
                      '${_event?.organizerFirstName}, ${_event?.organizerLastName}',
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
                      Utils.getString('Description'),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
