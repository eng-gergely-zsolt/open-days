class CustomDateUtils {
  static bool isPastDate(String dateTimeString) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(dateTimeString);

    return dateTime.isBefore(now);
  }

  static bool isFutureDate(String dateTimeString) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(dateTimeString);

    return dateTime.isAfter(now);
  }
}
