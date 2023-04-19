class ValidatorUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'An email address is required.';
    }

    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);

    if (!emailValid) {
      return 'This email address is not valid';
    } else {
      return null;
    }
  }
}
