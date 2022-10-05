package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.ui.model.response.InstitutionNameResponse;

import java.util.List;

public interface InstitutionService {
	List<InstitutionNameResponse> getAllInstitutionNameWithCounty();
}
