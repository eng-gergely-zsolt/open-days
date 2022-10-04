import 'package:flutter/material.dart';
import 'package:open_days_frontend/theme/theme.dart';

import 'screens/lobby/lobby.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  build(context) {
    return MaterialApp(
      theme: CustomTheme.lightTheme,
      home: const Scaffold(
        resizeToAvoidBottomInset: true,
        body: Lobby(),
      ),
    );
  }
}
