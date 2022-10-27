class UserResponseModel {
  int operationResultCode;

  String id;
  String roleName;
  String operationResult;
  String authorizationToken;
  String operationResultMessage;

  UserResponseModel({
    this.operationResultCode = -1,
    this.id = '',
    this.roleName = '',
    this.operationResult = '',
    this.authorizationToken = '',
    this.operationResultMessage = '',
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      roleName: json['roleName'] ?? '',
      operationResultCode: json['code'] ?? -1,
      operationResultMessage: json['message'] ?? '',
      operationResult: json['operationResult'] ?? '',
    );
  }
}
