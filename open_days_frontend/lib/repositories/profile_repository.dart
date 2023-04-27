import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/base_response.dart';
import '../services/profile/update_name_svc.dart';
import '../services/profile/update_username_svc.dart';
import '../services/profile/update_image_path_svc.dart';
import '../services/profile/update_institution_svc.dart';
import '../models/responses/update_username_response.dart';

final profileRepositoryProvider = Provider((_) => ProfileRepository());

class ProfileRepository {
  Future<BaseResponse> updateImagePathRepo(String id, String imagePath) async {
    return await updateImagePathSvc(id, imagePath);
  }

  Future<UpdateUsernameResponse> updateUsernameRepo(String id, String username) async {
    return await updateUsernameSvc(id, username);
  }

  Future<BaseResponse> updateNameRepo(String id, String lastName, String firstName) async {
    return await updateNameSvc(id, lastName, firstName);
  }

  Future<BaseResponse> updateInstitutionRepo(String id, String county, String institution) async {
    return await updateInstitutionSvc(id, county, institution);
  }
}
