import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StatelessBase extends StatelessWidget {
  const StatelessBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 600,
          ),
        ));
  }
}
