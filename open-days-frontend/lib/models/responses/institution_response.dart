import '../base_error.dart';
import '../institution.dart';

class InstitutionsResponse {
  bool isOperationSuccessful;
  BaseError error = BaseError();
  List<Institution> institutions;

  InstitutionsResponse({
    this.institutions = const [],
    this.isOperationSuccessful = false,
  });
}
