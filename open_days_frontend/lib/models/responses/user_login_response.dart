class UserLoginResponse {
  int operationResultCode;

  String id;
  String roleName;
  String operationResult;
  String authorizationToken;
  String operationResultMessage;

  UserLoginResponse({
    this.operationResultCode = -1,
    this.id = '',
    this.roleName = '',
    this.operationResult = '',
    this.authorizationToken = '',
    this.operationResultMessage = '',
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      roleName: json['roleName'] ?? '',
      operationResultCode: json['code'] ?? -1,
      operationResultMessage: json['message'] ?? '',
      operationResult: json['operationResult'] ?? '',
    );
  }
}
