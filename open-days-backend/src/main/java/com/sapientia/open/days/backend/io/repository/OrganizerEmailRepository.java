package com.sapientia.open.days.backend.io.repository;

import com.sapientia.open.days.backend.io.entity.OrganizerEmailEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrganizerEmailRepository extends CrudRepository<OrganizerEmailEntity, Long> {
	OrganizerEmailEntity findByEmail(String email);
}
