package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.BaseException;
import com.sapientia.open.days.backend.service.EventService;
import com.sapientia.open.days.backend.ui.model.request.UpdateEventRequest;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.Event;
import com.sapientia.open.days.backend.ui.model.User;
import com.sapientia.open.days.backend.ui.model.response.ParticipatedUsersStatResponse;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
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
	 */
	@GetMapping(path = "/future-events")
	public List<Event> getFutureEvents() {
		return eventService.getFutureEvents();
	}

	/**
	 * Returns the users that were enrolled in an event.
	 */
	@GetMapping(path = "/enrolled-users/{eventId}")

	public List<User> getEnrolledUsers(@PathVariable long eventId) {
		return eventService.getEnrolledUsers(eventId);
	}

	/**
	 * Returns the users that participated in an event.
	 */
	@GetMapping(path = "/participated-users/{eventId}")
	public List<User> getParticipatedUsers(@PathVariable long eventId) {
		return eventService.getParticipatedUsers(eventId);
	}

	/**
	 * Returns the events conform to the role of the user.
	 */
	@GetMapping(path = "/events-conform-to-user-role")
	public List<Event> getEventsConformToUserRole(@RequestHeader(value = "User-Public-ID") String userPublicId) {
		if (userPublicId == null || userPublicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		return eventService.getEventsConformToUserRole(userPublicId);
	}

	/**
	 * Returns true if the user is already enrolled in the event.
	 */
	@ResponseBody
	@GetMapping(path = "/is-user-enrolled/{eventId}")
	public boolean isUserEnrolled(@PathVariable long eventId,
	                              @RequestHeader(value = "User-Public-ID") String userPublicId) {
		if (eventId < 1) {
			throw new BaseException(ErrorCode.EVENT_INVALID_ID.getErrorCode(),
					ErrorMessage.EVENT_INVALID_ID.getErrorMessage());
		}

		if (userPublicId == null || userPublicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		return eventService.isUserEnrolled(eventId, userPublicId);
	}

	// Post
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Enrolls the user in the event. Basically it means that the user want to participate in the event.
	 */
	@PostMapping(path = "/enroll_user/{eventId}")
	public void enrollUser(@PathVariable long eventId, @RequestHeader(value = "User-Public-ID") String userPublicId) {
		if (eventId < 1) {
			throw new BaseException(ErrorCode.EVENT_INVALID_ID.getErrorCode(),
					ErrorMessage.EVENT_INVALID_ID.getErrorMessage());
		}

		if (userPublicId == null || userPublicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		eventService.enrollUser(eventId, userPublicId);
	}

	/**
	 * Saves the user as a participant in the event. It's called when create QR code is scanned.
	 */
	@PostMapping(path = "/save-user-participation/{eventId}")
	public void saveUserParticipation(@PathVariable long eventId,
	                                  @RequestHeader(value = "User-Public-ID") String userPublicId) {
		if (eventId < 1) {
			throw new BaseException(ErrorCode.EVENT_INVALID_ID.getErrorCode(),
					ErrorMessage.EVENT_INVALID_ID.getErrorMessage());
		}

		if (userPublicId == null || userPublicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		eventService.saveUserParticipation(eventId, userPublicId);
	}

	@PostMapping(path = "/create-event")
	void createEvent(@RequestBody Event payload) {
		if (payload.getActivityName().isEmpty()) {
			throw new BaseException(ErrorCode.ACTIVITY_INVALID_NAME.getErrorCode(),
					ErrorMessage.ACTIVITY_INVALID_NAME.getErrorMessage());
		}

		if (payload.getLocation().isEmpty()) {
			throw new BaseException(ErrorCode.EVENT_INVALID_LOCATION.getErrorCode(),
					ErrorMessage.EVENT_INVALID_LOCATION.getErrorMessage());
		}

		if (payload.getOrganizerPublicId().isEmpty()) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		if (payload.getDateTime().isEmpty()) {
			throw new BaseException(ErrorCode.EVENT_INVALID_DATE_TIME.getErrorCode(),
					ErrorMessage.EVENT_INVALID_DATE_TIME.getErrorMessage());
		}

		if (payload.isIsOnline() && payload.getMeetingLink().isEmpty()) {
			throw new BaseException(ErrorCode.EVENT_INVALID_MEETING_LINK.getErrorCode(),
					ErrorMessage.EVENT_INVALID_MEETING_LINK.getErrorMessage());
		}

		try {
			DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm");
			DateTime.parse(payload.getDateTime(), formatter);
		} catch (Exception exception) {
			throw new BaseException(ErrorCode.EVENT_INVALID_DATE_TIME.getErrorCode(),
					ErrorMessage.EVENT_INVALID_DATE_TIME.getErrorMessage());
		}

		eventService.createEvent(payload);
	}

	// Put
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Updates the data of the event identified by the given event id.
	 */
	@PutMapping(path = "/update-event/{eventId}")
	public void updateEvent(@PathVariable long eventId, @RequestBody UpdateEventRequest payload) {
		if (eventId < 1) {
			throw new BaseException(ErrorCode.EVENT_INVALID_ID.getErrorCode(),
					ErrorMessage.EVENT_INVALID_ID.getErrorMessage());
		}

		eventService.updateEvent(eventId, payload);
	}

	/**
	 * Returns the number of participated users to the given activities.
	 */
	@PutMapping(path = "/participated-users-statistic")
	public List<ParticipatedUsersStatResponse> getParticipatedUsersStat(@RequestBody List<String> payload) {
		return eventService.getParticipatedUserStat(payload);
	}

	// Delete
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Deletes the event identified by the given event id.
	 */
	@DeleteMapping(path = "/delete_event/{eventId}")
	public void deleteEvent(@PathVariable long eventId) {
		eventService.deleteEvent(eventId);
	}

	/**
	 * Deletes the enrolled user identified by the userPublicId from the event identified by the event id.
	 */
	@DeleteMapping(path = "/unenroll-user/{eventId}")
	public void unenrollUser(@PathVariable long eventId,
	                         @RequestHeader(value = "User-Public-ID") String userPublicId) {
		if (eventId < 1) {
			throw new BaseException(ErrorCode.EVENT_INVALID_ID.getErrorCode(),
					ErrorMessage.EVENT_INVALID_ID.getErrorMessage());
		}

		if (userPublicId == null || userPublicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		eventService.unenrollUser(eventId, userPublicId);
	}
}
