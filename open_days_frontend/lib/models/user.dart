import '../utils/utils.dart';

class User {
  String id;
  String email;
  String roleName;
  String username;
  String lastName;
  String firstName;
  String imagePath;
  String countyName;
  String institutionName;

  User({
    this.id = '',
    this.email = '',
    this.roleName = '',
    this.username = '',
    this.lastName = '',
    this.firstName = '',
    this.imagePath = '',
    this.countyName = '',
    this.institutionName = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['publicId'] ?? '',
      email: json['email'] ?? '',
      roleName: json['roleName'] ?? '',
      username: json['username'] ?? '',
      lastName: json['lastName'] ?? '',
      firstName: json['firstName'] ?? '',
      imagePath: json['imagePath'] ?? '',
      countyName: Utils.getDecodedString(json['countyName'] ?? ''),
      institutionName: Utils.getDecodedString(json['institutionName'] ?? ''),
    );
  }
}
