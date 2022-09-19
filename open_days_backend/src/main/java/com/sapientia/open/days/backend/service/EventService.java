package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.EventDto;

public interface EventService {
	void createEvent(EventDto event);
}
