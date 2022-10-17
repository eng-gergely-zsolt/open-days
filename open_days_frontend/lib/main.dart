import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/theme/theme.dart';

import 'modules/lobby/lobby.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
