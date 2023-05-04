import 'package:flutter/material.dart';

import './initial_page.dart';
import './screens/lobby/lobby.dart';
import './screens/login/login.dart';
import './constants/page_routes.dart';
import './screens/home_base/home_base.dart';
import './screens/guest_mode/guest_mode.dart';
import './screens/error/base_error_screen.dart';
import './screens/registration/registration.dart';
import './screens/registration/email_verification.dart';
import './screens/profile/modification/name_modification.dart';
import './screens/profile/models/name_modification_payload.dart';
import './screens/profile/modification/username_modification.dart';
import './screens/profile/models/username_modification_payload.dart';
import './screens/profile/modification/institution_modification.dart';
import './screens/profile/models/institution_modification_payload.dart';

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
      case emailVerificationRoute:
        return MaterialPageRoute(builder: (_) => EmailVerification(args as String));
      case usernameModificationRoute:
        return MaterialPageRoute(
            builder: (_) => UsernameModification(args as UsernameModificationPayload));
      case institutionModificationRoute:
        return MaterialPageRoute(
            builder: (_) => InstitutionModification(args as InstitutionModificationPayload));
      case nameModificationRoute:
        return MaterialPageRoute(builder: (_) => NameModification(args as NameModificationPayload));

      default:
        return MaterialPageRoute(builder: (_) => const BaseErrorScreen());
    }
  }
}
