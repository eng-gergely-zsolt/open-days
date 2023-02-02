package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.CreateEventDto;
import com.sapientia.open.days.backend.shared.dto.EventDto;

import java.util.List;

public interface EventService {
	List<EventDto> getAllEvent();

	void deleteEvent(long eventId);

	void createEvent(CreateEventDto event);

	void applyUserForEvent(long eventId, String userPublicId);

	void deleteUserFromEvent(long eventId, String userPublicId);

	void userParticipatesInEvent(long eventId, String userPublicId);

	boolean getIsUserAppliedForEvent(long eventId, String userPublicId);
}
