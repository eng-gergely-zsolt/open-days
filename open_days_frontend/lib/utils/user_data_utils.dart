import '../models/institution.dart';

class UserDataUtils {
  static List<String> getCounties(List<Institution> institutions) {
    List<String> countyNames = [];

    for (Institution it in institutions) {
      if (!countyNames.contains(it.countyName)) {
        countyNames.add(it.countyName);
      }
    }

    countyNames.sort();
    return countyNames;
  }

  static List<String> getInstitutions(String? selectedCounty, List<Institution> institutions) {
    List<String> institutionNames = [];

    for (Institution it in institutions) {
      if (it.countyName == selectedCounty && !institutionNames.contains(it.institutionName)) {
        institutionNames.add(it.institutionName);
      }
    }

    institutionNames.sort();
    return institutionNames;
  }

  static String getFirstInstitution(String? selectedCounty, List<Institution> institutions) {
    List<String> institutionNames = [];

    for (Institution it in institutions) {
      if (it.countyName == selectedCounty && !institutionNames.contains(it.institutionName)) {
        institutionNames.add(it.institutionName);
      }
    }

    institutionNames.sort();
    return institutionNames.isNotEmpty ? institutionNames[0] : "";
  }
}
