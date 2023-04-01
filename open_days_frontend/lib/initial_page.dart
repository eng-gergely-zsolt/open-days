import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:open_days_frontend/screens/error/internet_connection_error_scaffold.dart';

import 'package:open_days_frontend/models/base_response.dart';
import 'package:open_days_frontend/services/main/get_verify_authorization_token.dart';

import './screens/lobby/lobby.dart';
import './screens/home_base/home_base.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
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
        // systemNavigationBarColor: Color.fromRGBO(234, 234, 234, 1),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Color.fromRGBO(234, 234, 234, 1),
      ),
    );

    return isDeviceConnected
        ? isUserLoggedIn
            ? const HomeBase()
            : const Lobby()
        : const InternetConnectionErrorScaffold();
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
