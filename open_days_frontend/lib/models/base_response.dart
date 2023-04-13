class BaseResponse {
  int? errorCode;
  String? errorMessage = "";
  bool isOperationSuccessful = false;

  BaseResponse({
    this.isOperationSuccessful = false,
  });

  BaseResponse.withError({
    required this.errorCode,
    required this.errorMessage,
    this.isOperationSuccessful = false,
  });

  BaseResponse.fromJson(Map<String, dynamic> json)
      : errorCode = json['errorCode'],
        errorMessage = json['errorMessage'];
}
