package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.io.entity.CountyEntity;
import com.sapientia.open.days.backend.io.repository.CountyRepository;
import com.sapientia.open.days.backend.service.CountyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@SuppressWarnings("unused")
public class CountyServiceImpl implements CountyService {

	@Autowired
	CountyRepository countyRepository;

	@Override
	public List<String> getAllCountyName() {
		List<String> countyNames = new ArrayList<>();
		Iterable<CountyEntity> countyEntities = countyRepository.findAll();

		for (CountyEntity countyEntity : countyEntities) {
			countyNames.add(countyEntity.getName());
		}

		return countyNames;
	}
}
