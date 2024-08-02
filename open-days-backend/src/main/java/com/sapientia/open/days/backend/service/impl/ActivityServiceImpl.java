package com.sapientia.open.days.backend.service.impl;


import com.sapientia.open.days.backend.io.entity.ActivityEntity;
import com.sapientia.open.days.backend.io.repository.ActivityRepository;
import com.sapientia.open.days.backend.service.ActivityService;
import com.sapientia.open.days.backend.ui.model.Activity;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@SuppressWarnings("unused")
public class ActivityServiceImpl implements ActivityService {

	@Autowired
	ActivityRepository activityRepository;

	@Override
	public List<Activity> getActivities() {
		ArrayList<Activity> activities = new ArrayList<>();
		Iterable<ActivityEntity> activityEntities = activityRepository.findAll();

		for (ActivityEntity activityEntity: activityEntities) {
			Activity activity = new Activity();
			BeanUtils.copyProperties(activityEntity, activity);
			activities.add(activity);
		}

		return activities;
	}
}
