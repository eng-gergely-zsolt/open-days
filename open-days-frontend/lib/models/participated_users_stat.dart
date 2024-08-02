import '../utils/utils.dart';

class ParticipatedUsersStat {
  String activityName;
  int participatedUsersNr;

  ParticipatedUsersStat({
    this.activityName = '',
    this.participatedUsersNr = 0,
  });

  factory ParticipatedUsersStat.fromJson(Map<String, dynamic> json) {
    return ParticipatedUsersStat(
      activityName: Utils.getDecodedString(json['activityName'] ?? ''),
      participatedUsersNr: json['participatedUsersNr'] ?? 0,
    );
  }
}
