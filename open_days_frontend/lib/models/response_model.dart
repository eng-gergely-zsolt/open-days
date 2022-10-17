class ResponseModel {
  int code;
  String message;
  String bearer;
  String operationResult;

  ResponseModel({
    this.code = -1,
    this.bearer = '',
    this.message = '',
    this.operationResult = '',
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      operationResult: json['operationResult'] ?? '',
    );
  }
}
