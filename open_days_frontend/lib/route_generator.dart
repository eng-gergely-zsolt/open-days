import 'package:flutter/material.dart';
import 'package:open_days_frontend/screens/login/login.dart';
import 'package:open_days_frontend/screens/registration/registration.dart';

import './initial_page.dart';
import 'screens/error/base_error.dart';
import './constants/page_routes.dart';
import './screens/guest_mode/guest_mode.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const InitialPage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const Login());
      case guestModeRoute:
        return MaterialPageRoute(builder: (_) => const GuestMode());
      case registrationRoute:
        return MaterialPageRoute(builder: (_) => const Registration());
      default:
        return MaterialPageRoute(builder: (_) => const BaseError());
    }
  }
}
