import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BaseError extends StatelessWidget {
  const BaseError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            appLocale?.connectivity_offline as String,
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 25),
          Text(
            appLocale?.connectivity_check_connection as String,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
