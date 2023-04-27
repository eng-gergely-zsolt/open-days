import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/user_data_utils.dart';
import '../../../repositories/base_repository.dart';
import '../../registration/models/institution.dart';
import '../../../models/responses/base_response.dart';
import '../../../repositories/profile_repository.dart';
import '../models/institution_modification_payload.dart';

class InstitutionModificationController {
  final ProviderRef _ref;
  final BaseRepository _baseRepository;
  final ProfileRepository _profileRepository;
  final InstitutionModificationPayload _payload = InstitutionModificationPayload();

  final _isLoadingProvider = StateProvider<bool>((ref) => false);
  final _selectedCountyProvider = StateProvider<String>((ref) => '');
  final _selectedInstitutionProvider = StateProvider<String>((ref) => '');

  var _isConfirmAllowed = false;
  late FutureProvider<List<Institution>> _institutionsProvider;

  String? _selectedCounty;
  String? _selectedInstitution;
  BaseResponse? _updateInstitutionResponse;
  List<Institution> _institutions = List.empty();

  InstitutionModificationController(this._ref, this._baseRepository, this._profileRepository) {
    _institutionsProvider = _getAllInstitution();
  }

  bool getConfirmAllowed() {
    return _isConfirmAllowed;
  }

  String getSelectedCounty() {
    return _selectedCounty ?? '';
  }

  String getSelectedInstitution() {
    return _selectedInstitution ?? '';
  }

  StateProvider<bool> getLoadingProvider() {
    return _isLoadingProvider;
  }

  BaseResponse? getUpdateInstitutionResponse() {
    return _updateInstitutionResponse;
  }

  StateProvider<String?> getSelectedCountyProvider() {
    return _selectedCountyProvider;
  }

  StateProvider<String?> getSelectedInstitutionProvider() {
    return _selectedInstitutionProvider;
  }

  FutureProvider<List<Institution>> getInstitutionsProvider() {
    return _institutionsProvider;
  }

  FutureProvider<List<Institution>> _getAllInstitution() {
    return FutureProvider((ref) async {
      _institutions = await _baseRepository.getAllInstitutionRepo();
      return _institutions;
    });
  }

  void deleteUpdateInstitutionResponse() {
    _updateInstitutionResponse = null;
  }

  void setPayload(InstitutionModificationPayload payload) {
    _payload.id = payload.id;
    _payload.county = payload.county;
    _payload.institution = payload.institution;
  }

  void setSelectedCountyProvider(String? selectedCounty) {
    if (selectedCounty != null) {
      _selectedCounty = selectedCounty;
      setConfirmAllowedOnSelectedValueChange();
      _ref.read(_selectedCountyProvider.notifier).state = selectedCounty;
    }
  }

  void setSelectedInstitutionProvider(String? selectedInstitution) {
    if (selectedInstitution != null) {
      _selectedInstitution = selectedInstitution;
      setConfirmAllowedOnSelectedValueChange();
      _ref.read(_selectedInstitutionProvider.notifier).state = selectedInstitution;
    }
  }

  void setSelectedValuesInitially(String initialCounty, String initialInstitution) {
    _selectedCounty ??= initialCounty;
    _selectedInstitution ??= initialInstitution;
  }

  void setConfirmAllowedOnSelectedValueChange() {
    if (_selectedCounty == _payload.county && _selectedInstitution == _payload.institution) {
      _isConfirmAllowed = false;
    } else {
      _isConfirmAllowed = true;
    }
  }

  String getSelectedInstitutionOnCountyChange() {
    String result = '';

    if (UserDataUtils.getInstitutions(_selectedCounty, _institutions)
        .contains(_selectedInstitution)) {
      result = _selectedInstitution ?? '';
    } else {
      result = UserDataUtils.getFirstInstitution(_selectedCounty, _institutions);
    }

    _selectedInstitution = result;

    return result;
  }

  void updateInstitution() async {
    _ref.read(_isLoadingProvider.notifier).state = true;

    _updateInstitutionResponse = await _profileRepository.updateInstitutionRepo(
        _payload.id, _selectedCounty ?? '', _selectedInstitution ?? '');

    _ref.read(_isLoadingProvider.notifier).state = false;
  }
}

final institutionModificationControllerProvider = Provider((ref) {
  final baseRepository = ref.watch(baseRepositoryProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);
  return InstitutionModificationController(ref, baseRepository, profileRepository);
});
