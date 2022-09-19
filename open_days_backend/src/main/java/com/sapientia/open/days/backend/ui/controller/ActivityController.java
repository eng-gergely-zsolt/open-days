package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.GeneralServiceException;
import com.sapientia.open.days.backend.service.ActivityService;
import com.sapientia.open.days.backend.shared.dto.ActivityDto;
import com.sapientia.open.days.backend.ui.model.request.ActivityModel;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.resource.OperationStatus;
import com.sapientia.open.days.backend.ui.model.response.OperationStatusModel;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("activity")
public class ActivityController {

	@Autowired
	ActivityService activityService;

	@PostMapping
	OperationStatusModel createActivity(@RequestBody ActivityModel activity) {

		if (activity.getName().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.ACTIVITY_MISSING_NAME.getErrorCode(),
					ErrorMessage.ACTIVITY_MISSING_NAME.getErrorMessage());
		}

		if (activity.getLocation().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.ACTIVITY_MISSING_LOCATION.getErrorCode(),
					ErrorMessage.ACTIVITY_MISSING_LOCATION.getErrorMessage());
		}

		ActivityDto activityDto = new ActivityDto();
		BeanUtils.copyProperties(activity, activityDto);

		activityService.createActivity(activityDto);

		OperationStatusModel response = new OperationStatusModel();
		response.setOperationResult(OperationStatus.SUCCESS.name());

		return response;
	}
}
