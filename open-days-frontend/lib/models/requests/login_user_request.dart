class LoginUserRequest {
  String id;
  String username;
  String password;
  String authorizationToken;

  LoginUserRequest({
    this.id = '',
    this.username = '',
    this.password = '',
    this.authorizationToken = '',
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  factory LoginUserRequest.fromJson(Map<String, dynamic> json) {
    return LoginUserRequest(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
