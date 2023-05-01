package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.CreateEventDto;
import com.sapientia.open.days.backend.ui.model.request.UpdateEventReq;
import com.sapientia.open.days.backend.ui.model.Event;
import com.sapientia.open.days.backend.ui.model.User;

import java.util.List;

public interface EventService {
	// Get
	List<Event> getFutureEvents();

	List<User> getEnrolledUsers(long eventId);

	List<Event> getEventsByUserPublicId(String userPublicId);

	boolean getIsUserAppliedForEvent(long eventId, String userPublicId);

	// Post
	void createEvent(CreateEventDto event);

	void applyUserForEvent(long eventId, String userPublicId);

	void userParticipatesInEvent(long eventId, String userPublicId);

	// Put
	void updateEvent(long eventId, UpdateEventReq updateEventPayload);

	// Delete
	void deleteEvent(long eventId);

	void deleteUserFromEvent(long eventId, String userPublicId);


}
