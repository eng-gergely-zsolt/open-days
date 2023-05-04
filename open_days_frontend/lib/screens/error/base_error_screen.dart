import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BaseErrorScreen extends StatelessWidget {
  const BaseErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            appLocale?.base_text_sorry as String,
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 25),
          Text(
            appLocale?.error_something_went_wrong as String,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
