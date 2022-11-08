package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.GeneralServiceException;
import com.sapientia.open.days.backend.service.ActivityService;
import com.sapientia.open.days.backend.shared.dto.ActivityDto;
import com.sapientia.open.days.backend.ui.model.request.ActivityRequestModel;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.resource.OperationStatus;
import com.sapientia.open.days.backend.ui.model.response.ActivityResponseModel;
import com.sapientia.open.days.backend.ui.model.response.OperationStatusModel;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("activity")
public class ActivityController {

	@Autowired
	ActivityService activityService;

	@GetMapping(path = "/all-activity")
	public List<ActivityResponseModel> getAllActivity() {

		List<ActivityResponseModel> response = new ArrayList<>();
		List<ActivityDto> rawActivities = activityService.getAllActivity();

		for (ActivityDto activity : rawActivities) {
			ActivityResponseModel activityTemp = new ActivityResponseModel();
			BeanUtils.copyProperties(activity, activityTemp);
			response.add(activityTemp);
		}

		return response;
	}

	@PostMapping
	OperationStatusModel createActivity(@RequestBody ActivityRequestModel activity) {

		if (activity.getName().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.ACTIVITY_MISSING_NAME.getErrorCode(),
					ErrorMessage.ACTIVITY_MISSING_NAME.getErrorMessage());
		}

		ActivityDto activityDto = new ActivityDto();
		BeanUtils.copyProperties(activity, activityDto);

		activityService.createActivity(activityDto);

		OperationStatusModel response = new OperationStatusModel();
		response.setOperationResult(OperationStatus.SUCCESS.name());

		return response;
	}
}
