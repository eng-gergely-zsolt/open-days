import 'package:flutter/material.dart';
import 'package:open_days_frontend/screens/login/login.dart';
import 'package:open_days_frontend/screens/registration/registration.dart';

import './initial_page.dart';
import './screens/lobby/lobby.dart';
import './constants/page_routes.dart';
import './screens/error/base_error.dart';
import './screens/home_base/home_base.dart';
import './screens/guest_mode/guest_mode.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const InitialPage());
      case lobbyRoute:
        return MaterialPageRoute(builder: (_) => const Lobby());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const Login());
      case homeBaseRoute:
        return MaterialPageRoute(builder: (_) => const HomeBase());
      case guestModeRoute:
        return MaterialPageRoute(builder: (_) => const GuestMode());
      case registrationRoute:
        return MaterialPageRoute(builder: (_) => const Registration());
      default:
        return MaterialPageRoute(builder: (_) => const BaseError());
    }
  }
}
