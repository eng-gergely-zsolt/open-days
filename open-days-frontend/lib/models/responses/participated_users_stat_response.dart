import '../base_error.dart';
import '../participated_users_stat.dart';

class ParticipatedUsersStatResponse {
  bool isOperationSuccessful;
  BaseError error = BaseError();
  List<ParticipatedUsersStat> stats;

  ParticipatedUsersStatResponse({
    this.stats = const [],
    this.isOperationSuccessful = false,
  });
}
