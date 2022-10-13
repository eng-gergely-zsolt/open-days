import 'package:flutter/material.dart';
import 'package:open_days_frontend/screens/login/login.dart';
import 'package:open_days_frontend/registration/registration.dart';

class Lobby extends StatelessWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          ClipPath(
            clipper: LobbyTopCoverClipper(),
            child: SizedBox(
              width: screenWidth,
              height: screenHeight * 0.69,
              child: Image.asset(
                'lib/assets/images/books-cover3.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.55,
            child: ClipPath(
              clipper: LobbyBottomCoverClipper(),
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.45,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.75,
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.6, 45),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  child: const Text('Sign in'),
                ),
                SizedBox(height: screenHeight * 0.03),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Registration(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color.fromRGBO(1, 30, 65, 1),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(254, 251, 236, 1),
                    minimumSize: Size(screenWidth * 0.6, 45),
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
