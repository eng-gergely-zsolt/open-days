class Institution {
  final String countyName;
  final String settlementName;
  final String institutionName;

  Institution({
    required this.countyName,
    required this.settlementName,
    required this.institutionName,
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      countyName: json['countyName'] ?? '',
      settlementName: json['settlementName'] ?? '',
      institutionName: json['institutionName'] ?? '',
    );
  }
}
