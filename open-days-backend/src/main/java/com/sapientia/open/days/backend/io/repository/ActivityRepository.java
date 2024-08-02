package com.sapientia.open.days.backend.io.repository;

import com.sapientia.open.days.backend.io.entity.ActivityEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ActivityRepository extends CrudRepository<ActivityEntity, Long> {
	ActivityEntity findByName(String name);
}
