package com.sapientia.open.days.backend.io.repository;

import com.sapientia.open.days.backend.io.entity.InstitutionEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InstitutionRepository extends CrudRepository<InstitutionEntity, Long> {
	InstitutionEntity findByName(String name);

	List<InstitutionEntity> findAllByName(String name);
}
