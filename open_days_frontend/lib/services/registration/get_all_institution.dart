import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../modules/registration/models/institution.dart';

Future<List<Institution>> getAllInstitutionSvc() async {
  const uri = 'http://10.0.2.2:8081/open-days/institution/all-name-with-county';
  final response = await http.get(Uri.parse(uri)).timeout(const Duration(seconds: 5));

  if (response.statusCode == 200) {
    Iterable decodedResponse = json.decode(response.body);
    return decodedResponse.map((e) => Institution.fromJson(e)).toList();
  } else {
    throw Exception('Failed to get county names');
  }
}