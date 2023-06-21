class CustomDateUtils {
  static bool isPastDate(String dateTimeString) {
    DateTime dateTime;
    DateTime now = DateTime.now();

    try {
      dateTime = DateTime.parse(dateTimeString);
    } catch (_) {
      return false;
    }

    return dateTime.isBefore(now);
  }

  static bool isFutureDate(String dateTimeString) {
    DateTime dateTime;
    DateTime now = DateTime.now();

    try {
      dateTime = DateTime.parse(dateTimeString);
    } catch (_) {
      return false;
    }

    return dateTime.isAfter(now);
  }
}
