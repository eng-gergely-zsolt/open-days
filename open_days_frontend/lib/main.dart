import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:open_days_frontend/l10n/l10n.dart';
import 'package:open_days_frontend/theme/theme.dart';
import 'package:open_days_frontend/base/base_error.dart';
import 'package:open_days_frontend/models/base_response.dart';
import 'package:open_days_frontend/services/main/get_verify_authorization_token.dart';

import './screens/lobby/lobby.dart';
import './screens/home_base/home_base.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(ProviderScope(
      child: MaterialApp(
    supportedLocales: L10n.all,
    theme: CustomTheme.lightTheme,
    home: const Scaffold(
      resizeToAvoidBottomInset: true,
      body: MpApp(),
    ),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
  )));
}

class MpApp extends StatefulWidget {
  const MpApp({Key? key}) : super(key: key);

  @override
  State<MpApp> createState() => _MpAppState();
}

class _MpAppState extends State<MpApp> {
  var isAlertSet = false;
  var isUserLoggedIn = false;
  var isDeviceConnected = false;
  late StreamSubscription internetConnectionSubscription;

  @override
  void initState() {
    super.initState();
    getConnectivity();
    verifyAuthorizationToken();
  }

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

    return isDeviceConnected
        ? isUserLoggedIn
            ? const HomeBase()
            : const Lobby()
        : const BaseError();
  }

  verifyAuthorizationToken() async {
    BaseResponse response = await verifyAuthorizationTokenSvc();

    FlutterNativeSplash.remove();

    if (response.isOperationSuccessful) {
      setState(() {
        isUserLoggedIn = true;
      });
    } else {
      setState(() {
        isUserLoggedIn = false;
      });
    }
  }

  getConnectivity() {
    internetConnectionSubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      bool isDeviceConnectedTemp = await InternetConnectionChecker().hasConnection;

      if (!isDeviceConnectedTemp) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      setState(() => isDeviceConnected = isDeviceConnectedTemp);
    });
  }

  @override
  void dispose() {
    internetConnectionSubscription.cancel();
    super.dispose();
  }
}
