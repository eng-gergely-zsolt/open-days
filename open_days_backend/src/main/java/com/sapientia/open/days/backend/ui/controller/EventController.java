package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.GeneralServiceException;
import com.sapientia.open.days.backend.service.EventService;
import com.sapientia.open.days.backend.shared.dto.CreateEventDto;
import com.sapientia.open.days.backend.ui.model.request.UpdateEventReq;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.Event;
import com.sapientia.open.days.backend.ui.model.OperationStatus;
import com.sapientia.open.days.backend.ui.model.User;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("event")
public class EventController {

	@Autowired
	EventService eventService;

	// Get
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Returns all events that are about to happen in the future.
	 * @return The list of the events.
	 */
	@GetMapping(path = "/future-events")
	public List<Event> getFutureEvents() {
		return eventService.getFutureEvents();
	}

	@GetMapping(path = "/enrolled-users/{eventId}")
	public List<User> getEnrolledUsers(@PathVariable long eventId) {
		return eventService.getEnrolledUsers(eventId);
	}

	/**
	 * Returns the events conform to the role of the user.
	 *
	 * @param userPublicId The public id of the user.
	 * @return The list of the events.
	 */
	@GetMapping(path = "/events-by-user-id")
	public List<Event> getEventsByUserPublicId(@RequestHeader(value = "User-Public-ID") String userPublicId) {
		return eventService.getEventsByUserPublicId(userPublicId);
	}

	@ResponseBody
	@GetMapping(path = "/is-user-applied-for-event/{eventId}/{userPublicId}")
	public boolean isUserAppliedForEvent(@PathVariable long eventId, @PathVariable String userPublicId) {
		return eventService.getIsUserAppliedForEvent(eventId, userPublicId);
	}

	// Post
	// -----------------------------------------------------------------------------------------------------------------

	@PostMapping(path = "/apply_user_for_event/{eventId}/{userPublicId}")
	public void applyUserForEvent(@PathVariable long eventId, @PathVariable String userPublicId) {
		eventService.applyUserForEvent(eventId, userPublicId);
	}

	@PostMapping(path = "/user_participates_in_event/{eventId}/{userPublicId}")
	public void userParticipatesInEvent(@PathVariable long eventId, @PathVariable String userPublicId) {
		eventService.userParticipatesInEvent(eventId, userPublicId);
	}

	@PostMapping
	OperationStatus createEvent(@RequestBody Event event) {

		if (event.getLocation().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.EVENT_MISSING_LOCATION.getErrorCode(),
					ErrorMessage.EVENT_MISSING_LOCATION.getErrorMessage());
		}

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

		if (event.isIsOnline() && event.getMeetingLink().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.EVENT_MISSING_MEETING_LINK.getErrorCode(),
					ErrorMessage.EVENT_MISSING_MEETING_LINK.getErrorMessage());
		}

		try {
			DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm");
			DateTime.parse(event.getDateTime(), formatter);
		} catch (Exception exception) {
			throw new GeneralServiceException(ErrorCode.EVENT_INVALID_DATE_TIME.getErrorCode(),
					ErrorMessage.EVENT_INVALID_DATE_TIME.getErrorMessage());
		}

		CreateEventDto eventDto = new CreateEventDto();
		BeanUtils.copyProperties(event, eventDto);

		eventService.createEvent(eventDto);

		OperationStatus response = new OperationStatus();
		response.setOperationResult(com.sapientia.open.days.backend.ui.model.resource.OperationStatus.SUCCESS.name());

		return response;
	}

	// Put
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * It updates the data of the event with the specified id in the path.
	 *
	 * @param eventId            The unique id of the event.
	 * @param updateEventPayload It contains the data that we use to update the existing record in the database.
	 */
	@PutMapping(path = "/update_event/{eventId}")
	public void updateEvent(@PathVariable long eventId, @RequestBody UpdateEventReq updateEventPayload) {
		eventService.updateEvent(eventId, updateEventPayload);
	}

	// Delete
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * It deletes and event from the database by id.
	 *
	 * @param eventId The unique id of the event.
	 */
	@DeleteMapping(path = "/delete_event/{eventId}")
	public void deleteEvent(@PathVariable long eventId) {
		eventService.deleteEvent(eventId);
	}

	@DeleteMapping(path = "/delete_user_from_event/{eventId}/{userPublicId}")
	public void deleteUserFromEvent(@PathVariable long eventId, @PathVariable String userPublicId) {
		eventService.deleteUserFromEvent(eventId, userPublicId);
	}
}
