import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../theme/theme.dart';
import '../../../utils/helper_widget_utils.dart';
import './username_modification_controller.dart';
import '../models/username_modification_payload.dart';

class UsernameModification extends ConsumerWidget {
  final UsernameModificationPayload payload;

  const UsernameModification(this.payload, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(usernameModificationControllerProvider);

    final isLoading = ref.watch(controller.getLoadingProvider());
    final isConfirmAllowed = ref.watch(controller.getConfirmAllowedProvider());

    Future.microtask(() {
      controller.setUsernameInitially(payload.username);
    });

    if (controller.getUpdateUsernameResponse() != null) {
      if (controller.getUpdateUsernameResponse()?.isOperationSuccessful == true) {
        Future.microtask(() {
          UsernameModificationPayload result = UsernameModificationPayload(
            id: payload.id,
            username: controller.getUsername(),
          );

          Navigator.pop(context, result);
        });
      } else {
        final snackBar = SnackBar(
          content: Text(controller.getUpdateUsernameResponse()?.error.errorMessage as String),
        );

        Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));
      }

      controller.deleteUpdateUsernameResponse();
    }

    return WillPopScope(
      onWillPop: (() {
        Navigator.pop(
            context,
            UsernameModificationPayload(
              id: payload.id,
              username: payload.username,
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
                    appLocale?.profile_username_modification_title as String,
                    style: CustomTheme.lightTheme.textTheme.headline5,
                  ),
                  SizedBox(height: appHeight * 0.05),
                  TextFormField(
                    maxLines: null,
                    initialValue: payload.username,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      controller.setUsername(value);
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
                            controller.updateUsername();
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
