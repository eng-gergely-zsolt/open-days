package com.sapientia.open.days.backend.io.repository;

import com.sapientia.open.days.backend.io.entity.RoleEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoleRepository extends CrudRepository<RoleEntity, Long> {
	RoleEntity findByName(String name);
}
