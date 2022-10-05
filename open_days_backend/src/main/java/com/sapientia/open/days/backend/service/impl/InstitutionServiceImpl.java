package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.io.entity.CountyEntity;
import com.sapientia.open.days.backend.io.entity.InstitutionEntity;
import com.sapientia.open.days.backend.io.entity.SettlementEntity;
import com.sapientia.open.days.backend.io.repository.CountyRepository;
import com.sapientia.open.days.backend.io.repository.InstitutionRepository;
import com.sapientia.open.days.backend.io.repository.SettlementRepository;
import com.sapientia.open.days.backend.service.InstitutionService;
import com.sapientia.open.days.backend.ui.model.response.InstitutionNameResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@SuppressWarnings("unused")
public class InstitutionServiceImpl implements InstitutionService {

	@Autowired
	CountyRepository countyRepository;

	@Autowired
	SettlementRepository settlementRepository;

	@Autowired
	InstitutionRepository institutionRepository;

	@Override
	public List<InstitutionNameResponse> getAllInstitutionNameWithCounty() {

		List<CountyEntity> countyEntities = new ArrayList<>();
		List<SettlementEntity> settlementEntities = new ArrayList<>();
		List<InstitutionEntity> institutionEntities = new ArrayList<>();

		Iterable<CountyEntity> countyEntityIterable = countyRepository.findAll();
		Iterable<SettlementEntity> settlementEntityIterable = settlementRepository.findAll();
		Iterable<InstitutionEntity> institutionEntityIterable = institutionRepository.findAll();

		for (CountyEntity countyEntity : countyEntityIterable) {
			countyEntities.add(countyEntity);
		}

		for (SettlementEntity settlementEntity : settlementEntityIterable) {
			settlementEntities.add(settlementEntity);
		}

		for (InstitutionEntity institutionEntity : institutionEntityIterable) {
			institutionEntities.add(institutionEntity);
		}

		List<InstitutionNameResponse> response = new ArrayList<>();

		for (InstitutionEntity institutionEntity : institutionEntities) {

			InstitutionNameResponse responseItem = new InstitutionNameResponse();
			responseItem.setInstitutionName(institutionEntity.getName());

			for (SettlementEntity settlementEntity : settlementEntities) {
				if (institutionEntity.getSettlement().getId() == settlementEntity.getId()) {
					for (CountyEntity countyEntity : countyEntities) {
						if (settlementEntity.getCounty().getId() == countyEntity.getId()) {
							responseItem.setCountyName(countyEntity.getName());
						}
					}
				}
			}
			response.add(responseItem);
		}
		return response;
	}
}
