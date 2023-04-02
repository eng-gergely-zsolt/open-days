import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/page_routes.dart';
import './profile_controller.dart';

class Profile extends ConsumerWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(profileControllerProvider);
    final isClosingPageRequired = ref.watch(controller.getIsClosingPageRequired());
    final isOperationInProgress = ref.watch(controller.getIsOperationInProgress());

    if (isClosingPageRequired == true) {
      Future.microtask((() {
        controller.invalidateProfileControllerProvider();

        Navigator.pop(context);
        Navigator.pushNamed(context, lobbyRoute);
      }));
    }

    return isOperationInProgress
        ? LoadingAnimationWidget.staggeredDotsWave(
            size: appHeight * 0.1,
            color: const Color.fromRGBO(38, 70, 83, 1),
          )
        : Column(
            children: [
              SizedBox(height: appHeight * 0.02),
              Container(
                margin: EdgeInsets.symmetric(horizontal: appWidth * 0.05),
                child: Row(
                  children: [
                    TextButton(
                      child: Text(
                        appLocale?.base_text_log_out as String,
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        controller.logOut();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
