package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.exceptions.BaseException;
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
import com.sapientia.open.days.backend.shared.utils.DateUtils;
import com.sapientia.open.days.backend.ui.model.request.UpdateEventRequest;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.Event;
import com.sapientia.open.days.backend.ui.model.User;
import com.sapientia.open.days.backend.ui.model.response.ParticipatedUsersStatResponse;
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

	DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm");

	// Get
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Returns all events that are about to happen in the future.
	 *
	 * @return The list of the events.
	 */
	public List<Event> getFutureEvents() {
		Event event;
		DateTime eventDateTime;
		ArrayList<Event> events = new ArrayList<>();
		ArrayList<EventEntity> eventEntities = (ArrayList<EventEntity>) eventRepository.findAll();

		for (EventEntity eventEntity : eventEntities) {
			try {
				eventDateTime = DateTime.parse(eventEntity.getDateTime(), formatter);

				if (eventDateTime.isAfterNow()) {
					event = new Event();
					BeanUtils.copyProperties(eventEntity, event);

					event.setActivityName(eventEntity.getActivity().getName());
					event.setOrganizerPublicId(eventEntity.getOrganizer().getPublicId());
					event.setOrganizerLastName(eventEntity.getOrganizer().getLastName());
					event.setOrganizerFirstName(eventEntity.getOrganizer().getFirstName());

					events.add(event);
				}
			} catch (Exception ignored) {
				// Ignored.
			}
		}

		return events;
	}

	/**
	 * Returns the users that were enrolled in an event.
	 */
	@Override
	public List<User> getEnrolledUsers(long eventId) {
		ArrayList<User> enrolledUsers = new ArrayList<>();
		EventEntity eventEntity = eventRepository.findById(eventId);

		if (eventEntity == null) {
			throw new BaseException(ErrorCode.EVENT_NOT_FOUND_WITH_ID.getErrorCode(),
					ErrorMessage.EVENT_NOT_FOUND_WITH_ID.getErrorMessage());
		}

		for (UserEntity userEntity : eventEntity.getEnrolledUsers()) {
			User user = new User();

			BeanUtils.copyProperties(userEntity, user);

			user.setRoleName(userEntity.getRole().getName());
			user.setInstitutionName(userEntity.getInstitution().getName());
			user.setCountyName(userEntity.getInstitution().getSettlement().getCounty().getName());

			enrolledUsers.add(user);
		}

		return enrolledUsers;
	}

	/**
	 * Returns the users that participated in an event.
	 */
	@Override
	public List<User> getParticipatedUsers(long eventId) {
		ArrayList<User> participatedUsers = new ArrayList<>();
		EventEntity eventEntity = eventRepository.findById(eventId);

		if (eventEntity == null) {
			throw new BaseException(ErrorCode.EVENT_NOT_FOUND_WITH_ID.getErrorCode(),
					ErrorMessage.EVENT_NOT_FOUND_WITH_ID.getErrorMessage());
		}

		for (UserEntity userEntity : eventEntity.getParticipatedUsers()) {
			User user = new User();

			BeanUtils.copyProperties(userEntity, user);

			user.setRoleName(userEntity.getRole().getName());
			user.setInstitutionName(userEntity.getInstitution().getName());
			user.setCountyName(userEntity.getInstitution().getSettlement().getCounty().getName());

			participatedUsers.add(user);
		}

		return participatedUsers;
	}

	/**
	 * Returns the events conform to the role of the user.
	 */
	@Override
	public List<Event> getEventsConformToUserRole(String userPublicId) {
		Event event;
		RoleEntity userRoleEntity;
		RoleEntity organizerRoleEntity;
		ArrayList<EventEntity> eventEntities;
		ArrayList<Event> events = new ArrayList<>();
		UserEntity userEntity = userRepository.findByPublicId(userPublicId);

		if (userEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		eventEntities = (ArrayList<EventEntity>) eventRepository.findAll();

		userRoleEntity = roleRepository.findByName(Roles.ROLE_USER.name());
		organizerRoleEntity = roleRepository.findByName(Roles.ROLE_ORGANIZER.name());

		if (userEntity.getRole() == userRoleEntity) {
			DateTime eventDateTime;

			for (EventEntity eventEntity : eventEntities) {
				try {
					eventDateTime = DateTime.parse(eventEntity.getDateTime(), formatter);

					if (eventDateTime.isAfterNow()) {
						event = new Event();
						BeanUtils.copyProperties(eventEntity, event);

						event.setActivityName(eventEntity.getActivity().getName());
						event.setOrganizerPublicId(eventEntity.getOrganizer().getPublicId());
						event.setOrganizerLastName(eventEntity.getOrganizer().getLastName());
						event.setOrganizerFirstName(eventEntity.getOrganizer().getFirstName());

						events.add(event);
					}
				} catch (Exception ignored) {
					// Ignored.
				}
			}
		} else if (userEntity.getRole() == organizerRoleEntity) {
			for (EventEntity eventEntity : eventEntities) {
				if (Objects.equals(userPublicId, eventEntity.getOrganizer().getPublicId())) {
					event = new Event();
					BeanUtils.copyProperties(eventEntity, event);

					event.setActivityName(eventEntity.getActivity().getName());
					event.setOrganizerPublicId(eventEntity.getOrganizer().getPublicId());
					event.setOrganizerLastName(eventEntity.getOrganizer().getLastName());
					event.setOrganizerFirstName(eventEntity.getOrganizer().getFirstName());

					events.add(event);
				}
			}
		} else {
			for (EventEntity eventEntity : eventEntities) {
				event = new Event();
				BeanUtils.copyProperties(eventEntity, event);

				event.setActivityName(eventEntity.getActivity().getName());
				event.setOrganizerPublicId(eventEntity.getOrganizer().getPublicId());
				event.setOrganizerLastName(eventEntity.getOrganizer().getLastName());
				event.setOrganizerFirstName(eventEntity.getOrganizer().getFirstName());

				events.add(event);
			}
		}

		return events;
	}

	@Override
	public List<ParticipatedUsersStatResponse> getParticipatedUserStat(List<String> activityNames) {
		List<ParticipatedUsersStatResponse> response = new ArrayList<>();

		if (activityNames.size() < 2) {
			throw new BaseException(ErrorCode.EVENT_STATISTIC_NOT_ENOUGH_ACTIVITY.getErrorCode(),
					ErrorMessage.EVENT_STATISTIC_NOT_ENOUGH_ACTIVITY.getErrorMessage());
		}

		for (String activityName: activityNames) {
			ActivityEntity activity = activityRepository.findByName(activityName);

			if (activity != null) {
				int participatedUsersNr = 0;
				List<EventEntity> events = eventRepository.findAllByActivityId(activity.getId());
				ParticipatedUsersStatResponse responseElement = new ParticipatedUsersStatResponse();

				for (EventEntity event: events) {
					participatedUsersNr += event.getParticipatedUsers().size();
				}

				responseElement.setActivityName(activityName);
				responseElement.setParticipatedUsersNr(participatedUsersNr);

				response.add(responseElement);
			}
		}

		return response;
	}

	/**
	 * Returns true if the user is already enrolled in the event.
	 */
	@Override
	public boolean isUserEnrolled(long eventId, String userPublicId) {
		Set<UserEntity> enrolledUserEntities;
		HashSet<String> publicIds = new HashSet<>();
		EventEntity eventEntity = eventRepository.findById(eventId);

		if (eventEntity == null) {
			throw new BaseException(ErrorCode.EVENT_NOT_FOUND_WITH_ID.getErrorCode(),
					ErrorMessage.EVENT_NOT_FOUND_WITH_ID.getErrorMessage());
		}

		enrolledUserEntities = eventEntity.getEnrolledUsers();

		for (UserEntity enrolledUserEntity : enrolledUserEntities) {
			publicIds.add(enrolledUserEntity.getPublicId());
		}

		return publicIds.contains(userPublicId);
	}

	// Put
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public void createEvent(Event payload) {
		EventEntity newEventEntity;
		ActivityEntity activityEntity = activityRepository.findByName(payload.getActivityName());
		UserEntity organizerEntity = userRepository.findByPublicId(payload.getOrganizerPublicId());

		if (activityEntity == null) {
			throw new BaseException(ErrorCode.ACTIVITY_NOT_FOUND_WITH_NAME.getErrorCode(),
					ErrorMessage.ACTIVITY_NOT_FOUND_WITH_NAME.getErrorMessage());
		}

		if (organizerEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		newEventEntity = new EventEntity();
		BeanUtils.copyProperties(payload, newEventEntity);

		newEventEntity.setActivity(activityEntity);
		newEventEntity.setOrganizer(organizerEntity);

		try {
			eventRepository.save(newEventEntity);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.EVENT_NOT_SAVED.getErrorCode(),
					ErrorMessage.EVENT_NOT_SAVED.getErrorMessage());
		}

	}

	/**
	 * Enrolls the user in the event. Basically it means that the user want to participate in the event.
	 */
	@Override
	public void enrollUser(long eventId, String userPublicId) {
		Set<UserEntity> enrolledUserEntities;
		EventEntity eventEntity = eventRepository.findById(eventId);
		UserEntity userEntity = userRepository.findByPublicId(userPublicId);

		if (eventEntity == null) {
			throw new BaseException(ErrorCode.EVENT_NOT_FOUND_WITH_ID.getErrorCode(),
					ErrorMessage.EVENT_NOT_FOUND_WITH_ID.getErrorMessage());
		}

		if (userEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		enrolledUserEntities = eventEntity.getEnrolledUsers();

		enrolledUserEntities.add(userEntity);
		eventEntity.setEnrolledUsers(enrolledUserEntities);

		try {
			eventRepository.save(eventEntity);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.EVENT_COULD_NOT_SAVE_ENROLLED_USER.getErrorCode(),
					ErrorMessage.EVENT_COULD_NOT_SAVE_ENROLLED_USER.getErrorMessage());
		}
	}

	/**
	 * Saves the user as a participant in the event. It's called when create QR code is scanned.
	 */
	@Override
	public void saveUserParticipation(long eventId, String userPublicId) {
		Set<UserEntity> participatedUserEntities;
		EventEntity eventEntity = eventRepository.findById(eventId);
		UserEntity userEntity = userRepository.findByPublicId(userPublicId);

		if (eventEntity == null) {
			throw new BaseException(ErrorCode.EVENT_NOT_FOUND_WITH_ID.getErrorCode(),
					ErrorMessage.EVENT_NOT_FOUND_WITH_ID.getErrorMessage());
		}

		if (userEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		participatedUserEntities = eventEntity.getParticipatedUsers();

		participatedUserEntities.add(userEntity);
		eventEntity.setParticipatedUsers(participatedUserEntities);

		try {
			eventRepository.save(eventEntity);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.EVENT_COULD_NOT_SAVE_PARTICIPATED_USER.getErrorCode(),
					ErrorMessage.EVENT_COULD_NOT_SAVE_PARTICIPATED_USER.getErrorMessage());
		}
	}

	// Post
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Updates the data of the event identified by the given event id.
	 */
	@Override
	public void updateEvent(long eventId, UpdateEventRequest payload) {
		EventEntity eventEntity = eventRepository.findById(eventId);
		DateTime dateTime = DateUtils.getDateTimeFromString(payload.getDateTime());
		ActivityEntity activityEntity = activityRepository.findByName(payload.getActivityName());

		if (eventEntity == null) {
			throw new BaseException(ErrorCode.EVENT_NOT_FOUND_WITH_ID.getErrorCode(),
					ErrorMessage.EVENT_NOT_FOUND_WITH_ID.getErrorMessage());
		}

		eventEntity.setIsOnline(payload.getIsOnline());
		eventEntity.setMeetingLink(payload.getMeetingLink());

		if (activityEntity != null) {
			eventEntity.setActivity(activityEntity);
		}

		if (dateTime != null) {
			eventEntity.setDateTime(payload.getDateTime());
		}

		if (payload.getLocation() != null) {
			eventEntity.setLocation(payload.getLocation());
		}

		if (payload.getImagePath() != null) {
			eventEntity.setImagePath(payload.getImagePath());
		}

		if (payload.getDescription() != null) {
			eventEntity.setDescription(payload.getDescription());
		}

		try {
			eventRepository.save(eventEntity);
		} catch (Exception exception) {
			throw new BaseException(ErrorCode.EVENT_NOT_UPDATED.getErrorCode(),
					ErrorMessage.EVENT_NOT_UPDATED.getErrorMessage());
		}
	}

	// Delete
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Deletes the event identified by the given event id.
	 */
	@Override
	public void deleteEvent(long eventId) {
		try {
			eventRepository.deleteById(eventId);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.EVENT_NOT_DELETED.getErrorCode(),
					ErrorMessage.EVENT_NOT_DELETED.getErrorMessage());
		}
	}

	/**
	 * Deletes the enrolled user identified by the userPublicId from the event identified by the event id.
	 */
	@Override
	public void unenrollUser(long eventId, String userPublicId) {
		Set<UserEntity> enrolledUserEntities;
		EventEntity eventEntity = eventRepository.findById(eventId);
		UserEntity userEntity = userRepository.findByPublicId(userPublicId);

		if (eventEntity == null) {
			throw new BaseException(ErrorCode.EVENT_NOT_FOUND_WITH_ID.getErrorCode(),
					ErrorMessage.EVENT_NOT_FOUND_WITH_ID.getErrorMessage());
		}

		if (userEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		enrolledUserEntities = eventEntity.getEnrolledUsers();

		enrolledUserEntities.remove(userEntity);
		eventEntity.setEnrolledUsers(enrolledUserEntities);

		try {
			eventRepository.save(eventEntity);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.EVENT_COULD_NOT_DELETED_ENROLLED_USER.getErrorCode(),
					ErrorMessage.EVENT_COULD_NOT_DELETED_ENROLLED_USER.getErrorMessage());
		}

	}
}
