class UserResponseModel {
  int code;
  String id;
  String message;
  String bearer;
  String operationResult;

  UserResponseModel({
    this.code = -1,
    this.id = '',
    this.bearer = '',
    this.message = '',
    this.operationResult = '',
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      operationResult: json['operationResult'] ?? '',
    );
  }
}
