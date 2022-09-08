package com.sapientia.open.days.backend.io.repository;

import com.sapientia.open.days.backend.io.entity.CountyEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CountyRepository extends CrudRepository<CountyEntity, Long> {
	CountyEntity findByName(String name);
}
