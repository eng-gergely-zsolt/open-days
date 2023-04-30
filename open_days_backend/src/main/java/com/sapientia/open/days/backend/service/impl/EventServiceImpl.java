package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.exceptions.BaseException;
import com.sapientia.open.days.backend.exceptions.GeneralServiceException;
import com.sapientia.open.days.backend.io.entity.ActivityEntity;
import com.sapientia.open.days.backend.io.entity.EventEntity;
import com.sapientia.open.days.backend.io.entity.RoleEntity;
import com.sapientia.open.days.backend.io.entity.UserEntity;
import com.sapientia.open.days.backend.io.repository.ActivityRepository;
import com.sapientia.open.days.backend.io.repository.EventRepository;
import com.sapientia.open.days.backend.io.repository.RoleRepository;
import com.sapientia.open.days.backend.io.repository.UserRepository;
import com.sapientia.open.days.backend.service.EventService;
import com.sapientia.open.days.backend.shared.Roles;
import com.sapientia.open.days.backend.shared.dto.CreateEventDto;
import com.sapientia.open.days.backend.shared.utils.DateUtils;
import com.sapientia.open.days.backend.ui.model.request.UpdateEventRequestModel;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.response.EventsResponse;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@SuppressWarnings("unused")
public class EventServiceImpl implements EventService {

	@Autowired
	UserRepository userRepository;

	@Autowired
	RoleRepository roleRepository;

	@Autowired
	EventRepository eventRepository;

	@Autowired
	ActivityRepository activityRepository;

	// Get

	/**
	 * Returns the events conform to the role of the user.
	 *
	 * @param userPublicId The public id of the user.
	 * @return The list of the events.
	 */
	@Override
	public List<EventsResponse> getEvents(String userPublicId) {
		UserEntity user;
		RoleEntity userRole;
		RoleEntity adminRole;
		RoleEntity organizerRole;
		ArrayList<EventEntity> rawEvents;
		ArrayList<EventsResponse> events = new ArrayList<>();

		if (userPublicId == null || userPublicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		user = userRepository.findByPublicId(userPublicId);

		if (user == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		rawEvents = (ArrayList<EventEntity>) eventRepository.findAll();

		userRole = roleRepository.findByName(Roles.ROLE_USER.name());
		organizerRole = roleRepository.findByName(Roles.ROLE_ORGANIZER.name());

		if (user.getRole() == userRole) {
			DateTime eventDateTime;
			EventsResponse eventTemp;
			DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm");

			for (EventEntity event : rawEvents) {
				try {
					eventDateTime = DateTime.parse(event.getDateTime(), formatter);

					if (eventDateTime.isAfterNow()) {
						eventTemp = new EventsResponse();
						BeanUtils.copyProperties(event, eventTemp);

						eventTemp.setActivityName(event.getActivity().getName());
						eventTemp.setOrganizerId(event.getOrganizer().getPublicId());
						eventTemp.setOrganizerLastName(event.getOrganizer().getLastName());
						eventTemp.setOrganizerFirstName(event.getOrganizer().getFirstName());

						events.add(eventTemp);
					}
				} catch (Exception ignored) {
					// Ignored.
				}
			}
		} else if (user.getRole() == organizerRole) {
			for (EventEntity event : rawEvents) {
				if (Objects.equals(userPublicId, event.getOrganizer().getPublicId())) {
					EventsResponse eventTemp = new EventsResponse();
					BeanUtils.copyProperties(event, eventTemp);

					eventTemp.setActivityName(event.getActivity().getName());
					eventTemp.setOrganizerId(event.getOrganizer().getPublicId());
					eventTemp.setOrganizerLastName(event.getOrganizer().getLastName());
					eventTemp.setOrganizerFirstName(event.getOrganizer().getFirstName());

					events.add(eventTemp);
				}
			}
		} else {
			for (EventEntity event : rawEvents) {
				EventsResponse eventTemp = new EventsResponse();
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
	public boolean getIsUserAppliedForEvent(long eventId, String userPublicId) {
		EventEntity event = eventRepository.findById(eventId);
		Set<UserEntity> users = event.getUsers();
		HashSet<String> publicIds = new HashSet<>();

		for (UserEntity user : users) {
			publicIds.add(user.getPublicId());
		}

		return publicIds.contains(userPublicId);
	}

	// Put
	@Override
	public void createEvent(CreateEventDto event) {
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

	@Override
	public void applyUserForEvent(long eventId, String userPublicId) {
		EventEntity event = eventRepository.findById(eventId);
		UserEntity user = userRepository.findByPublicId(userPublicId);

		if (user != null && event != null) {
			try {
				Set<UserEntity> users = event.getUsers();
				users.add(user);
				event.setUsers(users);
				eventRepository.save(event);
			} catch (Exception e) {
				throw new GeneralServiceException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
						ErrorMessage.UNSPECIFIED_ERROR.getErrorMessage());
			}
		} else {
			throw new GeneralServiceException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
					ErrorMessage.UNSPECIFIED_ERROR.getErrorMessage());
		}
	}

	@Override
	public void userParticipatesInEvent(long eventId, String userPublicId) {
		EventEntity event = eventRepository.findById(eventId);
		UserEntity user = userRepository.findByPublicId(userPublicId);

		if (user != null && event != null) {
			try {
				Set<UserEntity> participatedUsers = event.getParticipatedUsers();
				participatedUsers.add(user);
				event.setParticipatedUsers(participatedUsers);
				eventRepository.save(event);
			} catch (Exception e) {
				throw new GeneralServiceException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
						ErrorMessage.UNSPECIFIED_ERROR.getErrorMessage());
			}
		} else {
			throw new GeneralServiceException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
					ErrorMessage.UNSPECIFIED_ERROR.getErrorMessage());
		}
	}

	// Post
	@Override
	public void updateEvent(long eventId, UpdateEventRequestModel updateEventPayload) {
		EventEntity event = eventRepository.findById(eventId);
		ActivityEntity activity = activityRepository.findByName(updateEventPayload.getActivityName());

		DateTime dateTime = DateUtils.getDateTimeFromString(updateEventPayload.getDateTime());

		if (event == null) {
			throw new GeneralServiceException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
					ErrorMessage.UNSPECIFIED_ERROR.getErrorMessage());
		}

		event.setIsOnline(updateEventPayload.getIsOnline());
		event.setMeetingLink(updateEventPayload.getMeetingLink());

		if (activity != null) {
			event.setActivity(activity);
		}

		if (dateTime != null) {
			event.setDateTime(updateEventPayload.getDateTime());
		}

		if (updateEventPayload.getLocation() != null) {
			event.setLocation(updateEventPayload.getLocation());
		}

		if (updateEventPayload.getImageLink() != null) {
			event.setImageLink(updateEventPayload.getImageLink());
		}

		if (updateEventPayload.getDescription() != null) {
			event.setDescription(updateEventPayload.getDescription());
		}

		try {
			eventRepository.save(event);
		} catch (Exception exception) {
			throw new GeneralServiceException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
					ErrorMessage.UNSPECIFIED_ERROR.getErrorMessage());
		}
	}

	// Delete
	@Override
	public void deleteEvent(long eventId) {
		try {
			eventRepository.deleteById(eventId);
		} catch (Exception e) {
			throw new GeneralServiceException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
					ErrorMessage.UNSPECIFIED_ERROR.getErrorMessage());
		}
	}

	@Override
	public void deleteUserFromEvent(long eventId, String userPublicId) {
		EventEntity event = eventRepository.findById(eventId);
		UserEntity user = userRepository.findByPublicId(userPublicId);

		if (user != null && event != null) {
			try {
				Set<UserEntity> users = event.getUsers();
				users.remove(user);
				event.setUsers(users);
				eventRepository.save(event);
			} catch (Exception e) {
				throw new GeneralServiceException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
						ErrorMessage.UNSPECIFIED_ERROR.getErrorMessage());
			}
		} else {
			throw new GeneralServiceException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(),
					ErrorMessage.UNSPECIFIED_ERROR.getErrorMessage());
		}
	}
}
