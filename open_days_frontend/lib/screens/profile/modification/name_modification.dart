import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../theme/theme.dart';
import './name_modification_controller.dart';
import '../../../utils/helper_widget_utils.dart';
import '../models/name_modification_payload.dart';

class NameModification extends ConsumerWidget {
  final NameModificationPayload payload;

  const NameModification(this.payload, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(nameModificationControllerProvider);

    final isLoading = ref.watch(controller.getLoadingProvider());
    final isConfirmAllowed = ref.watch(controller.getConfirmAllowedProvider());

    Future.microtask(() {
      controller.setNamesInitially(payload.lastName, payload.firstName);
    });

    if (controller.getUpdateNameResponse() != null) {
      if (controller.getUpdateNameResponse()?.isOperationSuccessful == true) {
        Future.microtask(() {
          NameModificationPayload result = NameModificationPayload(
            id: payload.id,
            lastName: controller.getLastName(),
            firstName: controller.getFirstName(),
          );
          Navigator.pop(context, result);
        });
      } else {
        final snackBar = SnackBar(
          content: Text(controller.getUpdateNameResponse()?.error.errorMessage as String),
        );

        Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));
      }

      controller.deleteUpdateNameResponse();
    }

    return WillPopScope(
      onWillPop: (() {
        Navigator.pop(
            context,
            NameModificationPayload(
              id: payload.id,
              lastName: payload.lastName,
              firstName: payload.firstName,
            ));
        return Future.value(true);
      }),
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocale?.profile_name as String),
        ),
        body: isLoading
            ? HelperWidgetUtils.getStaggeredDotsWaveAnimation(appHeight)
            : Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: appWidth * 0.05),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  SizedBox(height: appHeight * 0.1),
                  Text(
                    appLocale?.profile_what_is_your_name as String,
                    style: CustomTheme.lightTheme.textTheme.headline5,
                  ),
                  SizedBox(height: appHeight * 0.05),
                  TextFormField(
                    maxLines: null,
                    initialValue: payload.lastName,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      controller.setLastName(value);
                    },
                  ),
                  SizedBox(height: appHeight * 0.05),
                  TextFormField(
                    maxLines: null,
                    initialValue: payload.firstName,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      controller.setFirstName(value);
                    },
                  ),
                  SizedBox(height: appHeight * 0.05),
                  isConfirmAllowed
                      ? ElevatedButton(
                          child: Text(
                            appLocale?.profile_confirm.toUpperCase() as String,
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(appWidth * 0.6, 45),
                          ),
                          onPressed: () {
                            controller.updateName();
                          },
                        )
                      : ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            appLocale?.profile_confirm.toUpperCase() as String,
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(appWidth * 0.6, 45),
                            backgroundColor: CustomTheme.lightTheme.hintColor,
                          ),
                        ),
                ]),
              ),
      ),
    );
  }
}
