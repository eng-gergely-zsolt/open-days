import '../utils/utils.dart';

class Institution {
  final String countyName;
  final String settlementName;
  final String institutionName;

  Institution({
    this.countyName = '',
    this.settlementName = '',
    this.institutionName = '',
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      countyName: json['countyName'] ?? '',
      settlementName: json['settlementName'] ?? '',
      institutionName: Utils.getDecodedString(json['institutionName'] ?? ''),
    );
  }
}
