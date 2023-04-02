import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../login/login.dart';
import '../../constants/page_routes.dart';
import '../registration/registration.dart';

class Lobby extends StatelessWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            ClipPath(
              clipper: LobbyTopCoverClipper(),
              child: SizedBox(
                width: appWidth,
                height: appHeight * 0.69,
                child: Image.asset(
                  'lib/assets/images/books-cover3.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: appHeight * 0.55,
              child: ClipPath(
                clipper: LobbyBottomCoverClipper(),
                child: Container(
                  width: appWidth,
                  height: appHeight * 0.45,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
            Positioned(
              top: appHeight * 0.04,
              left: appWidth * 0.79,
              child: TextButton(
                child: Text(
                  appLocale?.base_text_guest as String,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, guestModeRoute);
                },
              ),
            ),
            Positioned(
              top: appHeight * 0.75,
              width: appWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      appLocale?.sign_in.toUpperCase() as String,
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(appWidth * 0.6, 45),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => const HomeBase(),
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: appHeight * 0.03),
                  OutlinedButton(
                    child: Text(
                      appLocale?.sign_up.toUpperCase() as String,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(254, 251, 236, 1),
                      minimumSize: Size(appWidth * 0.6, 45),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Registration(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LobbyTopCoverClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LobbyBottomCoverClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height * 0.31);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
