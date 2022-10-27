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
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

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
	public List<EventDto> getAllEvent() {
		ArrayList<EventDto> events = new ArrayList<>();
		Iterable<EventEntity> rawEvents = eventRepository.findAll();

		for (EventEntity event: rawEvents) {
			DateTime eventDateTime;

			try {
				DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm");
				eventDateTime =  DateTime.parse(event.getDateTime(), formatter);
			} catch (Exception exception) {
				throw new GeneralServiceException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
						ErrorMessage.UNSPECIFIED_ERROR .getErrorMessage());
			}

			if (eventDateTime != null && eventDateTime.isAfterNow()) {
				EventDto eventTemp = new EventDto();
				BeanUtils.copyProperties(event, eventTemp);

				eventTemp.setActivityName(event.getActivity().getName());
				eventTemp.setOrganizerId(event.getOrganizer().getPublicId());
				eventTemp.setOrganizerLastName(event.getOrganizer().getLastName());
				eventTemp.setOrganizerFirstName(event.getOrganizer().getFirstName());

				events.add(eventTemp);
			}
		}

		return events;
	}

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
