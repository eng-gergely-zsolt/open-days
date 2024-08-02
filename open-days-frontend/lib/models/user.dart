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
      id: Utils.getDecodedString(json['publicId'] ?? ''),
      email: Utils.getDecodedString(json['email'] ?? ''),
      roleName: Utils.getDecodedString(json['roleName'] ?? ''),
      username: Utils.getDecodedString(json['username'] ?? ''),
      lastName: Utils.getDecodedString(json['lastName'] ?? ''),
      firstName: Utils.getDecodedString(json['firstName'] ?? ''),
      imagePath: Utils.getDecodedString(json['imagePath'] ?? ''),
      countyName: Utils.getDecodedString(json['countyName'] ?? ''),
      institutionName: Utils.getDecodedString(json['institutionName'] ?? ''),
    );
  }
}
