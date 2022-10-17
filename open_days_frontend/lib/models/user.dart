class User {
  String username = '';
  String password = '';

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  User({this.username = '', this.password = ''});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
