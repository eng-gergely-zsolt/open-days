package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.exceptions.GeneralServiceException;
import com.sapientia.open.days.backend.io.entity.ActivityEntity;
import com.sapientia.open.days.backend.io.repository.ActivityRepository;
import com.sapientia.open.days.backend.service.ActivityService;
import com.sapientia.open.days.backend.shared.dto.ActivityDto;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@SuppressWarnings("unused")
public class ActivityServiceImpl implements ActivityService {

	@Autowired
	ActivityRepository activityRepository;

	@Override
	public void createActivity(ActivityDto activity) {

		if (activityRepository.findByName(activity.getName()) != null) {
			throw new GeneralServiceException(ErrorCode.ACTIVITY_ALREADY_EXISTING_NAME.getErrorCode(),
					ErrorMessage.ACTIVITY_ALREADY_EXISTING_NAME.getErrorMessage());
		}

		ActivityEntity newActivity = new ActivityEntity();
		BeanUtils.copyProperties(activity, newActivity);

		activityRepository.save(newActivity);
	}
}
