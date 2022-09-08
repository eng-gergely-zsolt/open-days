package com.sapientia.open.days.backend.io.repository;

import com.sapientia.open.days.backend.io.entity.SettlementEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SettlementRepository extends CrudRepository<SettlementEntity, Long> {
	SettlementEntity findByName(String name);
}
