/// A basic model to represent an error from the server.
class BaseError {
  int errorCode;
  String errorMessage;

  BaseError({
    this.errorCode = -1,
    this.errorMessage = '',
  });

  factory BaseError.fromJson(Map<String, dynamic> json) {
    return BaseError(
      errorCode: json['errorCode'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}
