class ResponseModel {
  final int code;
  final String message;
  final String operationResult;

  ResponseModel({
    required this.code,
    required this.message,
    required this.operationResult,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      operationResult: json['operationResult'] ?? '',
    );
  }
}
