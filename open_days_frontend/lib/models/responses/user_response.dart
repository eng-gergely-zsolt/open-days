import '../../utils/utils.dart';
import './base_error_response.dart';

class UserResponse {
  String id;
  String email;
  String county;
  String roleName;
  String username;
  String lastName;
  String firstName;
  String imagePath;
  String institution;
  bool isOperationSuccessful;
  BaseErrorResponse error = BaseErrorResponse();

  UserResponse({
    this.id = '',
    this.email = '',
    this.county = '',
    this.roleName = '',
    this.username = '',
    this.lastName = '',
    this.firstName = '',
    this.imagePath = '',
    this.institution = '',
    this.isOperationSuccessful = false,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['publicId'] ?? '',
      email: json['email'] ?? '',
      county: Utils.getDecodedString(json['county'] ?? ''),
      roleName: json['roleName'] ?? '',
      username: json['username'] ?? '',
      lastName: json['lastName'] ?? '',
      firstName: json['firstName'] ?? '',
      imagePath: json['imagePath'] ?? '',
      institution: Utils.getDecodedString(json['institution'] ?? ''),
    );
  }
}
