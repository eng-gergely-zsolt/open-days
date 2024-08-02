// A basic model when the server returns only a boolean value.
import 'package:open_days_frontend/models/base_error.dart';

class BaseLogicalResponse {
  bool data;
  bool isOperationSuccessful;
  BaseError error = BaseError();

  BaseLogicalResponse({
    this.data = false,
    this.isOperationSuccessful = false,
  });
}
