import 'package:flutter/material.dart';

class HelperWidgetUtils {
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
