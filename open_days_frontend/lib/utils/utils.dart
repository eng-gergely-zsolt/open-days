import 'dart:convert';

class Utils {
  static String getString(String? appLocaleString) {
    if (appLocaleString == null) {
      return '';
    } else {
      return appLocaleString;
    }
  }

  static String getDecodedString(String? input) {
    String response = '';

    if (input != null) {
      response = utf8.decode(input.runes.toList());
    }

    return response;
  }
}
