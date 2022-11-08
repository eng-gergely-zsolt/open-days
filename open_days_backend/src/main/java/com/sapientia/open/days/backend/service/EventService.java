package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.CreateEventDto;
import com.sapientia.open.days.backend.shared.dto.EventDto;

import java.util.List;

public interface EventService {
	List<EventDto> getAllEvent();

	void createEvent(CreateEventDto event);
}
