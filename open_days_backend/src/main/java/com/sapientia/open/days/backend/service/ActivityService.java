package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.ActivityDto;

import java.util.List;

public interface ActivityService {
	List<ActivityDto> getAllActivity();

	void createActivity(ActivityDto activity);
}
