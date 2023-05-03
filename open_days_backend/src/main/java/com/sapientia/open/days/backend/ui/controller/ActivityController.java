package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.service.ActivityService;
import com.sapientia.open.days.backend.ui.model.Activity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("activity")
public class ActivityController {

	@Autowired
	ActivityService activityService;

	@GetMapping(path = "/activities")
	public List<Activity> getActivities() {
		return activityService.getActivities();
	}
}
