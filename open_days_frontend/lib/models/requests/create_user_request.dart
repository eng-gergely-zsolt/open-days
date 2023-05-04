class CreateUserRequest {
  String email;
  String password;
  String username;
  String lastName;
  String firstName;
  String institutionName;

  CreateUserRequest({
    this.email = '',
    this.password = '',
    this.username = '',
    this.lastName = '',
    this.firstName = '',
    this.institutionName = '',
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'username': username,
        'lastName': lastName,
        'firstName': firstName,
        'institutionName': institutionName,
      };
}
