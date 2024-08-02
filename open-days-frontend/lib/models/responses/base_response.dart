import '../base_error.dart';

/// Contains only basic informations of a response from the server. Use this if no additional
/// information is needed from the server.
class BaseResponse {
  bool isOperationSuccessful;
  BaseError error = BaseError();

  BaseResponse({
    this.isOperationSuccessful = false,
  });
}
