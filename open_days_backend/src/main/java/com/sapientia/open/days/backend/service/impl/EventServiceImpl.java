package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.exceptions.GeneralServiceException;
import com.sapientia.open.days.backend.io.entity.ActivityEntity;
import com.sapientia.open.days.backend.io.entity.EventEntity;
import com.sapientia.open.days.backend.io.entity.UserEntity;
import com.sapientia.open.days.backend.io.repository.ActivityRepository;
import com.sapientia.open.days.backend.io.repository.EventRepository;
import com.sapientia.open.days.backend.io.repository.UserRepository;
import com.sapientia.open.days.backend.service.EventService;
import com.sapientia.open.days.backend.shared.dto.EventDto;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import org.joda.time.DateTime;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@SuppressWarnings("unused")
public class EventServiceImpl implements EventService {

	@Autowired
	UserRepository userRepository;

	@Autowired
	EventRepository eventRepository;

	@Autowired
	ActivityRepository activityRepository;

	@Override
	public void createEvent(EventDto event) {

		UserEntity organizer = userRepository.findByPublicId(event.getOrganizerId());
		ActivityEntity activity = activityRepository.findByName(event.getActivityName());

		if (organizer == null) {
			throw new GeneralServiceException(ErrorCode.EVENT_INVALID_ORGANIZER_ID.getErrorCode(),
					ErrorMessage.EVENT_INVALID_ORGANIZER_ID.getErrorMessage());
		}

		if (activity == null) {
			throw new GeneralServiceException(ErrorCode.EVENT_INVALID_ACTIVITY.getErrorCode(),
					ErrorMessage.EVENT_INVALID_ACTIVITY.getErrorMessage());
		}



		EventEntity newEvent = new EventEntity();
		BeanUtils.copyProperties(event, newEvent);

		newEvent.setActivity(activity);
		newEvent.setOrganizer(organizer);

		eventRepository.save(newEvent);
	}
}
