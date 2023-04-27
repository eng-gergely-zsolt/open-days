/// A basic model to represent an error from the server.
class BaseErrorResponse {
  int errorCode;
  String errorMessage;

  BaseErrorResponse({
    this.errorCode = -1,
    this.errorMessage = '',
  });

  factory BaseErrorResponse.fromJson(Map<String, dynamic> json) {
    return BaseErrorResponse(
      errorCode: json['errorCode'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}
