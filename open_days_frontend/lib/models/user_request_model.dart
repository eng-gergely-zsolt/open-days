class UserRequestModel {
  String id;
  String username;
  String password;
  String authorizationToken;

  UserRequestModel({
    this.id = '',
    this.username = '',
    this.password = '',
    this.authorizationToken = '',
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  factory UserRequestModel.fromJson(Map<String, dynamic> json) {
    return UserRequestModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
