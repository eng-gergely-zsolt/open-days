import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../home_base/home_base.dart';
import '../registration/registration.dart';

class Lobby extends StatelessWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    return SizedBox(
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
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: appHeight * 0.75,
            width: appWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(appWidth * 0.6, 45),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeBase(),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)?.login.toUpperCase() as String),
                ),
                SizedBox(height: appHeight * 0.03),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Registration(),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)?.sign_up.toUpperCase() as String,
                    style: const TextStyle(
                      color: Color.fromRGBO(1, 30, 65, 1),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(254, 251, 236, 1),
                    minimumSize: Size(appWidth * 0.6, 45),
                  ),
                ),
              ],
            ),
          ),
        ],
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
