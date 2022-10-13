class User {
  String email = '';
  String password = '';
  String username = '';
  String lastName = '';
  String firstName = '';
  String institution = '';

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'username': username,
        'lastName': lastName,
        'firstName': firstName,
        'institution': institution,
      };
}
