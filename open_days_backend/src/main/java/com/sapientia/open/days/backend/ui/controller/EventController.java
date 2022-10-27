package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.GeneralServiceException;
import com.sapientia.open.days.backend.service.EventService;
import com.sapientia.open.days.backend.shared.dto.EventDto;
import com.sapientia.open.days.backend.ui.model.request.EventRequestModel;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.resource.OperationStatus;
import com.sapientia.open.days.backend.ui.model.response.EventResponseModel;
import com.sapientia.open.days.backend.ui.model.response.OperationStatusModel;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("event")
public class EventController {

	@Autowired
	EventService eventService;

	@GetMapping(path = "/all-event")
	public List<EventResponseModel> getAllEvent() {
		List<EventResponseModel> response = new ArrayList<>();

		List<EventDto> rawEvents = eventService.getAllEvent();

		for (EventDto event : rawEvents) {
			EventResponseModel eventTemp = new EventResponseModel();
			BeanUtils.copyProperties(event, eventTemp);
			response.add(eventTemp);
		}

		return response;
	}

	@PostMapping
	OperationStatusModel createEvent(@RequestBody EventRequestModel event) {

		if (event.getDateTime().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.EVENT_MISSING_DATE_TIME.getErrorCode(),
					ErrorMessage.EVENT_MISSING_DATE_TIME.getErrorMessage());
		}

		if (event.getOrganizerId().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.EVENT_MISSING_ORGANIZER_ID.getErrorCode(),
					ErrorMessage.EVENT_MISSING_ORGANIZER_ID.getErrorMessage());
		}

		if (event.getActivityName().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.EVENT_MISSING_ACTIVITY_NAME.getErrorCode(),
					ErrorMessage.EVENT_MISSING_ACTIVITY_NAME.getErrorMessage());
		}

		if (event.getOnline() && event.getMeetingLink().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.EVENT_MISSING_MEETING_LINK.getErrorCode(),
					ErrorMessage.EVENT_MISSING_MEETING_LINK.getErrorMessage());
		}

		try {
			DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
			DateTime.parse(event.getDateTime(), formatter);
		} catch (Exception exception) {
			throw new GeneralServiceException(ErrorCode.EVENT_INVALID_DATE_TIME.getErrorCode(),
					ErrorMessage.EVENT_INVALID_DATE_TIME.getErrorMessage());
		}

		EventDto eventDto = new EventDto();
		BeanUtils.copyProperties(event, eventDto);

		eventService.createEvent(eventDto);

		OperationStatusModel response = new OperationStatusModel();
		response.setOperationResult(OperationStatus.SUCCESS.name());

		return response;
	}
}
