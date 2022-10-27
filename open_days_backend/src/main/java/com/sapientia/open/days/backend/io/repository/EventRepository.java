package com.sapientia.open.days.backend.io.repository;

import com.sapientia.open.days.backend.io.entity.EventEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EventRepository extends CrudRepository<EventEntity, Long> {
	EventEntity findByLocation(String location);
}
