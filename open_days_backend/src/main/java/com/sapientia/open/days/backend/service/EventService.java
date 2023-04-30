package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.CreateEventDto;
import com.sapientia.open.days.backend.ui.model.request.UpdateEventRequestModel;
import com.sapientia.open.days.backend.ui.model.response.EventsResponse;

import java.util.List;

public interface EventService {
	// Get
	List<EventsResponse> getFutureEvents();

	List<EventsResponse> getEventsByUserPublicId(String userPublicId);

	boolean getIsUserAppliedForEvent(long eventId, String userPublicId);

	// Post
	void createEvent(CreateEventDto event);

	void applyUserForEvent(long eventId, String userPublicId);

	void userParticipatesInEvent(long eventId, String userPublicId);

	// Put
	void updateEvent(long eventId, UpdateEventRequestModel updateEventPayload);

	// Delete
	void deleteEvent(long eventId);

	void deleteUserFromEvent(long eventId, String userPublicId);


}
