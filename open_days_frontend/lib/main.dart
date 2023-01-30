import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/l10n/l10n.dart';
import 'package:open_days_frontend/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/lobby/lobby.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  build(context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Color.fromRGBO(220, 220, 220, 0.4),
      ),
    );

    return MaterialApp(
      supportedLocales: L10n.all,
      theme: CustomTheme.lightTheme,
      home: const Scaffold(
        resizeToAvoidBottomInset: true,
        body: Lobby(),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
