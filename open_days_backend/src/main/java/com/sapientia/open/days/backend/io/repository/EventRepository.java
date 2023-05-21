package com.sapientia.open.days.backend.io.repository;

import com.sapientia.open.days.backend.io.entity.EventEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EventRepository extends CrudRepository<EventEntity, Long> {
	EventEntity findById(long id);

	EventEntity findByLocation(String location);

	List<EventEntity> findAllByActivityId(long activityId);
}
