package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.service.CountyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("county")
public class CountyController {

	@Autowired
	CountyService countyService;

	@GetMapping(path = "/counties")
	public List<String> getCounties() {
		return countyService.getAllCountyName();
	}
}
