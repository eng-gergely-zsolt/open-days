import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HelperWidgetUtils {
  static Widget getStaggeredDotsWaveAnimation(double appHeight) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        size: appHeight * 0.1,
        color: const Color.fromRGBO(38, 70, 83, 1),
      ),
    );
  }

  static Widget getImageCircularProgressIndicator(Widget child, ImageChunkEvent? loadingProgress) {
    return loadingProgress != null
        ? Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          )
        : child;
  }
}
