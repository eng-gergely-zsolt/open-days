package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.service.InstitutionService;
import com.sapientia.open.days.backend.ui.model.response.InstitutionNameResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("institution")
public class InstitutionController {

	@Autowired
	InstitutionService institutionService;

	@GetMapping(path = "/all-name-with-county")
	public List<InstitutionNameResponse> getAllInstitutionNameWithCounty() {
		return institutionService.getAllInstitutionNameWithCounty();
	}
}
