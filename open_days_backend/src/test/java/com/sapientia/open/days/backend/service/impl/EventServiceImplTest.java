package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.io.entity.*;
import com.sapientia.open.days.backend.io.repository.*;
import com.sapientia.open.days.backend.shared.Roles;
import com.sapientia.open.days.backend.ui.model.Event;
import com.sapientia.open.days.backend.ui.model.request.UpdateEventRequest;
import com.sapientia.open.days.backend.ui.model.response.ParticipatedUsersStatResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import com.sapientia.open.days.backend.exceptions.BaseException;
import com.sapientia.open.days.backend.io.repository.UserRepository;
import com.sapientia.open.days.backend.ui.model.User;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import org.mockito.*;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

import static org.mockito.Mockito.when;

public class EventServiceImplTest {

	@InjectMocks
	private EventServiceImpl eventService;

	@Mock
	private UserRepository userRepository;

	@Mock
	private RoleRepository roleRepository;

	@Mock
	private EventRepository eventRepository;

	@Mock
	private ActivityRepository activityRepository;

	private Event event;
	private EventEntity eventEntity;
	private ActivityEntity activityEntity;

	private UserEntity userEntity;
	private UserEntity adminEntity;
	private UserEntity organizerEntity;

	private RoleEntity userRoleEntity;

	private final String publicId = "examplePublicId";
	private final Set<UserEntity> enrolledUsers = new HashSet<>();
	private final Set<UserEntity> participatedUsers = new HashSet<>();
	private final ArrayList<EventEntity> eventEntities = new ArrayList<>();

	@BeforeEach
	void setUp() {
		MockitoAnnotations.openMocks(this);

		String location = "Sapientia";
		String dateTime = "2025-01-10 19:30";
		String imagePath = "user/placeholder.jpg";
		String description = "This is a placeholder description";
		String activityName = "Kampusztúra";
		String organizerPublicId = "qwertyuiopasdf2";
		String organizerLastName = "Gergely";
		String organizerFirstName = "Zsolt";
		String institutionName = "Sapientia";

		UserEntity organizer = new UserEntity();
		activityEntity = new ActivityEntity(1L, activityName);

		userRoleEntity = new RoleEntity(1, "ROLE_USER");
		RoleEntity adminRoleEntity = new RoleEntity(2, "ROLE_ADMIN");
		RoleEntity organizerRoleEntity = new RoleEntity(3, "ROLE_ORGANIZER");

		CountyEntity countyEntity = new CountyEntity(1, "Hargita");
		SettlementEntity settlementEntity = new SettlementEntity(1, "Marosvásárhely", countyEntity);
		InstitutionEntity institutionEntity = new InstitutionEntity(1, institutionName, settlementEntity);

		event = new Event(false, location, dateTime, imagePath, description, null, activityName, organizerPublicId,
				organizerLastName, organizerFirstName);

		eventEntity = new EventEntity(location, dateTime, false, description, organizer, activityEntity);

		adminEntity = new UserEntity(1L, "qwertyuiopasdf1", "admin@mailinator.com", "admin", "Doe",
				"John", "", adminRoleEntity, institutionEntity);

		organizerEntity = new UserEntity(2L, "qwertyuiopasdf2", "gergely.zsolt@gmail.com", "organizer", "Gergely",
				"Zsolt", "", organizerRoleEntity, institutionEntity);

		userEntity = new UserEntity(3L, "qwertyuiopasdf5", "user1@mailinator.com", "user1", "Bőjte",
				"Beáta", "", userRoleEntity, institutionEntity);

		UserEntity userEntity2 = new UserEntity(4L, "qwertyuiopasdf6", "user2@mailinator.com", "user2", "Bodó",
				"Barbara", "", userRoleEntity, institutionEntity);

		UserEntity userEntity3 = new UserEntity(5L, "qwertyuiopasdf7", "user3@mailinator.com", "user3", "Konrád",
				"Anita", "", userRoleEntity, institutionEntity);

		enrolledUsers.add(userEntity);
		enrolledUsers.add(userEntity2);
		enrolledUsers.add(userEntity3);

		participatedUsers.add(userEntity);
		participatedUsers.add(userEntity2);
		participatedUsers.add(userEntity3);

		eventEntities.add(eventEntity);
		eventEntity.setEnrolledUsers(enrolledUsers);
		eventEntity.setParticipatedUsers(participatedUsers);
	}

	// Get
	// -----------------------------------------------------------------------------------------------------------------

	@Test
	void testGetFutureEvents_Success() {
		// Arrange
		when(eventRepository.findAll()).thenReturn(eventEntities);

		// Act
		List<Event> result = eventService.getFutureEvents();

		// Assert
		assertNotNull(result);
		assertEquals(1, result.size());

		// Verify repository interactions
		verify(eventRepository).findAll();
		verifyNoMoreInteractions(eventRepository);
	}

	@Test
	void testGetEnrolledUsers_Success() {
		// Arrange
		long eventId = 1L;

		when(eventRepository.findById(eventId)).thenReturn(eventEntity);

		// Act
		List<User> result = eventService.getEnrolledUsers(eventId);

		// Assert
		assertNotNull(result);
		assertEquals(3, result.size());

		// Verify repository interactions
		verify(eventRepository).findById(eventId);
		verifyNoMoreInteractions(eventRepository);
	}

	@Test
	void testGetParticipatedUsers_Success() {
		// Arrange
		long eventId = 1L;

		when(eventRepository.findById(anyLong())).thenReturn(eventEntity);

		// Act
		List<User> result = eventService.getParticipatedUsers(eventId);

		// Assert
		assertNotNull(result);
		assertEquals(3, result.size());

		// Verify repository interactions
		verify(eventRepository).findById(eventId);
		verifyNoMoreInteractions(eventRepository);
	}

	@Test
	void testGetEventsConformToUserRole_Success_UserRole() {
		// Arrange
		eventEntities.clear();
		eventEntities.add(eventEntity);
		eventEntities.add(eventEntity);
		eventEntities.add(eventEntity);

		when(eventRepository.findAll()).thenReturn(eventEntities);
		when(userRepository.findByPublicId(publicId)).thenReturn(userEntity);

		// Act
		List<Event> result = eventService.getEventsConformToUserRole(publicId);

		// Assert
		assertNotNull(result);
		assertEquals(3, result.size());

		// Verify repository interactions
		verify(eventRepository).findAll();
		verify(userRepository).findByPublicId(publicId);
		verifyNoMoreInteractions(userRepository, eventRepository);
	}

	@Test
	void testGetEventsConformToUserRole_Success_OrganizerRole() {
		// Arrange
		eventEntities.clear();
		eventEntities.add(eventEntity);
		eventEntities.add(eventEntity);
		eventEntities.add(eventEntity);

		when(eventRepository.findAll()).thenReturn(eventEntities);
		when(userRepository.findByPublicId(publicId)).thenReturn(organizerEntity);
		when(roleRepository.findByName(Roles.ROLE_USER.name())).thenReturn(userRoleEntity);

		// Act
		List<Event> result = eventService.getEventsConformToUserRole(publicId);

		// Assert
		assertNotNull(result);
		assertEquals(3, result.size());

		// Verify repository interactions
		verify(eventRepository).findAll();
		verify(userRepository).findByPublicId(publicId);
		verifyNoMoreInteractions(userRepository, eventRepository);
	}

	@Test
	void testGetEventsConformToUserRole_Success_OtherRole() {
		// Arrange
		eventEntities.clear();
		eventEntities.add(eventEntity);
		eventEntities.add(eventEntity);
		eventEntities.add(eventEntity);

		when(eventRepository.findAll()).thenReturn(eventEntities);
		when(userRepository.findByPublicId(publicId)).thenReturn(adminEntity);

		// Act
		List<Event> result = eventService.getEventsConformToUserRole(publicId);

		// Assert
		assertNotNull(result);
		assertEquals(3, result.size());

		// Verify repository interactions
		verify(eventRepository).findAll();
		verify(userRepository).findByPublicId(publicId);
		verifyNoMoreInteractions(userRepository, eventRepository);
	}

	@Test
	void testGetParticipatedUserStat_Success() {
		// Arrange
		ActivityEntity activityEntity1 = new ActivityEntity(1L, "Activity 1");
		ActivityEntity activityEntity2 = new ActivityEntity(2L, "Activity 2");

		List<String> activityNames = new ArrayList<>(Arrays.asList("Activity 1", "Activity 2"));

		when(activityRepository.findByName("Activity 1")).thenReturn(activityEntity1);
		when(activityRepository.findByName("Activity 2")).thenReturn(activityEntity2);

		when(eventRepository.findAllByActivityId(activityEntity1.getId())).thenReturn(eventEntities);
		when(eventRepository.findAllByActivityId(activityEntity2.getId())).thenReturn(eventEntities);

		// Act
		List<ParticipatedUsersStatResponse> result = eventService.getParticipatedUserStat(activityNames);

		// Assert
		assertNotNull(result);
		assertEquals(2, result.size());
		assertEquals("Activity 1", result.get(0).getActivityName());
		assertEquals(3, result.get(0).getParticipatedUsersNr());
		assertEquals("Activity 2", result.get(1).getActivityName());
		assertEquals(3, result.get(1).getParticipatedUsersNr());

		// Verify repository interactions
		verify(activityRepository).findByName("Activity 1");
		verify(activityRepository).findByName("Activity 2");
		verify(eventRepository).findAllByActivityId(activityEntity1.getId());
		verify(eventRepository).findAllByActivityId(activityEntity2.getId());
		verifyNoMoreInteractions(activityRepository, eventRepository);
	}

	@Test
	void testIsUserEnrolled_Success() {
		// Arrange
		long eventId = 1L;
		String userPublicId = "qwertyuiopasdf5";

		when(eventRepository.findById(eventId)).thenReturn(eventEntity);

		// Act
		boolean result = eventService.isUserEnrolled(eventId, userPublicId);

		// Assert
		assertTrue(result);

		// Verify repository interactions
		verify(eventRepository).findById(eventId);
		verifyNoMoreInteractions(eventRepository);
	}

	// Put
	// -----------------------------------------------------------------------------------------------------------------

	@Test
	public void testCreateEvent_Success() {
		// Arrange
		EventEntity capturedEventEntity;
		ArgumentCaptor<EventEntity> eventEntityArgumentCaptor = ArgumentCaptor.forClass(EventEntity.class);

		when(activityRepository.findByName(anyString())).thenReturn(activityEntity);
		when(userRepository.findByPublicId(anyString())).thenReturn(organizerEntity);

		// Act
		eventService.createEvent(event);

		// Verify
		verify(activityRepository).findByName(anyString());
		verify(userRepository).findByPublicId(anyString());
		verify(eventRepository).save(any(EventEntity.class));
		verify(eventRepository).save(eventEntityArgumentCaptor.capture());

		capturedEventEntity = eventEntityArgumentCaptor.getValue();

		// Assert
		assertEquals(event.getId(), capturedEventEntity.getId());

		assertEquals(activityEntity.getId(), capturedEventEntity.getActivity().getId());
		assertEquals(activityEntity.getName(), capturedEventEntity.getActivity().getName());

		assertEquals(organizerEntity.getPublicId(), capturedEventEntity.getOrganizer().getPublicId());
		assertEquals(organizerEntity.getLastName(), capturedEventEntity.getOrganizer().getLastName());
		assertEquals(organizerEntity.getFirstName(), capturedEventEntity.getOrganizer().getFirstName());
	}

	@Test
	public void testCreateEvent_ActivityNotFound() {
		// Arrange
		when(activityRepository.findByName(event.getActivityName())).thenReturn(null);

		// Act
		BaseException exception = assertThrows(BaseException.class, () -> eventService.createEvent(event));

		// Verify
		verifyNoInteractions(eventRepository);
		verify(activityRepository).findByName(event.getActivityName());

		// Assert
		assertEquals(ErrorCode.ACTIVITY_NOT_FOUND_WITH_NAME.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.ACTIVITY_NOT_FOUND_WITH_NAME.getErrorMessage(), exception.getErrorMessage());
	}

	@Test
	public void testEnrollUser_Success() {
		// Arrange
		EventEntity capturedEventEntity;
		ArgumentCaptor<EventEntity> eventEntityArgumentCaptor = ArgumentCaptor.forClass(EventEntity.class);

		when(eventRepository.findById(eventEntity.getId())).thenReturn(eventEntity);
		when(userRepository.findByPublicId(userEntity.getPublicId())).thenReturn(userEntity);

		// Act
		eventService.enrollUser(eventEntity.getId(), userEntity.getPublicId());

		// Verify
		verify(eventRepository).save(any(EventEntity.class));
		verify(eventRepository).findById(eventEntity.getId());
		verify(userRepository).findByPublicId(userEntity.getPublicId());
		verify(eventRepository).save(eventEntityArgumentCaptor.capture());

		capturedEventEntity = eventEntityArgumentCaptor.getValue();

		// Assert
		assertEquals(eventEntity.getId(), capturedEventEntity.getId());
		assertTrue(eventEntity.getEnrolledUsers().contains(userEntity));
	}

	@Test
	public void testSaveUserParticipation_Success() {
		// Arrange
		when(eventRepository.findById(eventEntity.getId())).thenReturn(eventEntity);
		when(eventRepository.save(Mockito.any(EventEntity.class))).thenReturn(eventEntity);
		when(userRepository.findByPublicId(userEntity.getPublicId())).thenReturn(userEntity);

		// Act
		eventService.saveUserParticipation(eventEntity.getId(), userEntity.getPublicId());

		// Verify & assert
		verify(eventRepository).save(any(EventEntity.class));
		verify(eventRepository).findById(eventEntity.getId());
		verify(userRepository).findByPublicId(userEntity.getPublicId());
		assertTrue(eventEntity.getParticipatedUsers().contains(userEntity));
	}

	// Post
	// -----------------------------------------------------------------------------------------------------------------

	@Test
	public void testUpdateEvent_Success() {
		// Arrange
		EventEntity capturedEventEntity;
		ArgumentCaptor<EventEntity> eventEntityArgumentCaptor = ArgumentCaptor.forClass(EventEntity.class);

		UpdateEventRequest payload = new UpdateEventRequest("Sapientia", event.getDateTime(), "user/placeholder.jpg",
				event.getDescription(), null, "Kampusztúra", false);

		when(eventRepository.findById(eventEntity.getId())).thenReturn(eventEntity);
		when(activityRepository.findByName(activityEntity.getName())).thenReturn(activityEntity);

		// Act
		eventService.updateEvent(eventEntity.getId(), payload);

		// Verify
		verify(eventRepository).findById(eventEntity.getId());
		verify(activityRepository).findByName(activityEntity.getName());
		verify(eventRepository).save(eventEntityArgumentCaptor.capture());

		capturedEventEntity = eventEntityArgumentCaptor.getValue();

		// Assert
		assertFalse(eventEntity.isOnline());
		assertEquals(event.getId(), capturedEventEntity.getId());
		assertEquals(event.getIsOnline(), capturedEventEntity.isOnline());
		assertEquals(event.getDateTime(), capturedEventEntity.getDateTime());
		assertEquals(event.getLocation(), capturedEventEntity.getLocation());
		assertEquals(event.getImagePath(), capturedEventEntity.getImagePath());
		assertEquals(event.getDescription(), capturedEventEntity.getDescription());
		assertEquals(event.getMeetingLink(), capturedEventEntity.getMeetingLink());
		assertEquals(event.getActivityName(), capturedEventEntity.getActivity().getName());
	}

	// Delete
	// -----------------------------------------------------------------------------------------------------------------

	@Test
	public void testDeleteEvent_Success() {
		// Act
		eventService.deleteEvent(eventEntity.getId());

		// Assert
		verify(eventRepository, times(1)).deleteById(event.getId());
	}

	@Test
	public void testDeleteEvent_Error() {
		// Arrange
		doThrow(new RuntimeException()).when(eventRepository).deleteById(event.getId());

		// Act & Assert
		BaseException exception = assertThrows(BaseException.class, () -> eventService.deleteEvent(event.getId()));

		assertEquals(ErrorCode.EVENT_NOT_DELETED.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.EVENT_NOT_DELETED.getErrorMessage(), exception.getErrorMessage());
	}

	@Test
	public void testUnenrollUser_Success() {
		// Arrange
		EventEntity capturedEventEntity;
		ArgumentCaptor<EventEntity> eventEntityArgumentCaptor = ArgumentCaptor.forClass(EventEntity.class);

		when(eventRepository.findById(eventEntity.getId())).thenReturn(eventEntity);
		when(userRepository.findByPublicId(userEntity.getPublicId())).thenReturn(userEntity);

		// Act
		eventService.unenrollUser(eventEntity.getId(), userEntity.getPublicId());

		// Verify
		verify(eventRepository, times(1)).save(eventEntity);
		verify(eventRepository).save(eventEntityArgumentCaptor.capture());

		capturedEventEntity = eventEntityArgumentCaptor.getValue();

		// Assert
		assertFalse(capturedEventEntity.getEnrolledUsers().contains(userEntity));
	}

}
