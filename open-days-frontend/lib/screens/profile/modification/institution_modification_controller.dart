import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/institution.dart';
import '../../../utils/user_data_utils.dart';
import '../../../repositories/base_repository.dart';
import '../../../models/responses/base_response.dart';
import '../../../repositories/profile_repository.dart';
import '../models/institution_modification_payload.dart';
import '../../../models/responses/institution_response.dart';

class InstitutionModificationController {
  final ProviderRef _ref;
  final BaseRepository _baseRepository;
  final ProfileRepository _profileRepository;
  final InstitutionModificationPayload _payload = InstitutionModificationPayload();

  final _isLoadingProvider = StateProvider<bool>((ref) => false);
  final _selectedCountyProvider = StateProvider<String>((ref) => '');
  final _selectedInstitutionProvider = StateProvider<String>((ref) => '');

  var _isConfirmAllowed = false;
  late FutureProvider<InstitutionsResponse> _institutionsProvider;

  String? _selectedCounty;
  String? _selectedInstitution;
  BaseResponse? _updateInstitutionResponse;
  List<Institution> _institutions = List.empty();

  InstitutionModificationController(this._ref, this._baseRepository, this._profileRepository) {
    _institutionsProvider = _getInstitutions();
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

  FutureProvider<InstitutionsResponse> getInstitutionsProvider() {
    return _institutionsProvider;
  }

  FutureProvider<InstitutionsResponse> _getInstitutions() {
    return FutureProvider((ref) async {
      InstitutionsResponse response = await _baseRepository.getInstitutionsRepo();
      _institutions = response.institutions;
      return response;
    });
  }

  void deleteUpdateInstitutionResponse() {
    _updateInstitutionResponse = null;
  }

  void setPayload(InstitutionModificationPayload payload) {
    _payload.id = payload.id;
    _payload.countyName = payload.countyName;
    _payload.institutionName = payload.institutionName;
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
    if (_selectedCounty == _payload.countyName &&
        _selectedInstitution == _payload.institutionName) {
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
        _selectedCounty ?? '', _selectedInstitution ?? '');

    _ref.read(_isLoadingProvider.notifier).state = false;
  }
}

final institutionModificationControllerProvider = Provider((ref) {
  final baseRepository = ref.watch(baseRepositoryProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);
  return InstitutionModificationController(ref, baseRepository, profileRepository);
});
