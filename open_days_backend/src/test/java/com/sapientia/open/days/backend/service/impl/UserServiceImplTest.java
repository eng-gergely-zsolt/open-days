package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.exceptions.BaseException;
import com.sapientia.open.days.backend.io.entity.*;
import com.sapientia.open.days.backend.io.repository.InstitutionRepository;
import com.sapientia.open.days.backend.io.repository.OrganizerEmailRepository;
import com.sapientia.open.days.backend.io.repository.RoleRepository;
import com.sapientia.open.days.backend.io.repository.UserRepository;
import com.sapientia.open.days.backend.shared.EmailService;
import com.sapientia.open.days.backend.shared.Utils;
import com.sapientia.open.days.backend.ui.model.User;
import com.sapientia.open.days.backend.ui.model.request.user.*;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.SignatureAlgorithm;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.*;

import static com.sapientia.open.days.backend.shared.Roles.ROLE_ORGANIZER;
import static com.sapientia.open.days.backend.shared.Roles.ROLE_USER;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@SpringBootTest
class UserServiceImplTest {

	@Mock
	Utils utils;

	@Mock
	EmailService emailService;

	@InjectMocks
	private UserServiceImpl userService;

	@Mock
	private RoleRepository roleRepository;

	@Mock
	private UserRepository userRepository;

	@Mock
	private BCryptPasswordEncoder bCryptPasswordEncoder;

	@Mock
	private InstitutionRepository institutionRepository;

	@Mock
	private OrganizerEmailRepository organizerEmailRepository;

	private UserEntity userEntity;
	private RoleEntity userRoleEntity;
	private RoleEntity organizerRoleEntity;
	private CreateUserRequest createUserRequest;
	private InstitutionEntity institutionEntity;

	private final int otpCode = 1234;
	private final String firstName = "Zsolt";
	private final String lastName = "Gergely";
	private final String username = "gergely.zsolt";
	private final String publicId = "examplePublicId";
	private final String institutionName = "Sapientia";
	private final String email = "gergely.zsolt@gmail.com";

	@BeforeEach
	void setUp() {
		MockitoAnnotations.openMocks(this);

		CountyEntity countyEntity = new CountyEntity(1, "Hargita");
		SettlementEntity settlementEntity = new SettlementEntity(1, "Marosvásárhely", countyEntity);

		userRoleEntity = new RoleEntity(1, "ROLE_USER");
		organizerRoleEntity = new RoleEntity(2, "ROLE_ORGANIZER");
		institutionEntity = new InstitutionEntity(1, institutionName, settlementEntity);

		String password = "Pass1234";
		createUserRequest = new CreateUserRequest(email, password, username, lastName, firstName,
				institutionName);

		String encryptedPassword = "$2a$10$z9BeqAxh0nY.kdpuvDi.xuP0mwIPgqK2WPtkTghwX3iAJJoHQ0MMm";
		userEntity = new UserEntity(1, publicId, email, username, lastName, firstName, encryptedPassword,
				userRoleEntity, institutionEntity);

		userEntity.setOtpCode(otpCode);
	}

	// Get
	// -----------------------------------------------------------------------------------------------------------------

	@Test
	public void testGetUserByPublicId_Success() {
		when(userRepository.findByPublicId(publicId)).thenReturn(userEntity);

		User result = userService.getUserByPublicId(publicId);

		assertNotNull(result);
		assertEquals(email, result.getEmail());
		assertEquals(publicId, result.getPublicId());
		assertEquals(lastName, result.getLastName());
		assertEquals(publicId, result.getPublicId());
		assertEquals(username, result.getUsername());
		assertEquals(firstName, result.getFirstName());
		assertEquals(userRoleEntity.getName(), result.getRoleName());
		assertEquals(userEntity.getInstitution().getName(), result.getInstitutionName());
		assertEquals(userEntity.getInstitution().getSettlement().getCounty().getName(), result.getCountyName());
	}

	@Test
	final void testGetUserByPublicId_UserNotFoundWithPublicIdException() {
		when(userRepository.findByPublicId(anyString())).thenReturn(null);

		BaseException exception = assertThrows(BaseException.class, () -> userService.getUserByPublicId(publicId));

		assertEquals(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage(), exception.getErrorMessage());
	}

	@Test
	@SuppressWarnings("unchecked")
	final void testGetPaginatedUsers_Success() {
		int pageNumber = -1;
		int recordPerPage = 10;

		Page<UserEntity> userPage = mock(Page.class);

		when(userPage.getContent()).thenReturn(new ArrayList<>());
		when(userRepository.findAll(any(Pageable.class))).thenReturn(userPage);

		List<User> result = userService.getPaginatedUsers(pageNumber, recordPerPage);

		assertNotNull(result);
	}

	// Post
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Tests the CreateUser method when the method is successful.
	 */
	@Test
	final void testCreateUser_Success() {
		UserEntity capturedUserEntity;
		int roleRandom = new Random().nextInt(1, 3);
		OrganizerEmailEntity organizerEmailEntity = new OrganizerEmailEntity();
		ArgumentCaptor<UserEntity> userEntityArgumentCaptor = ArgumentCaptor.forClass(UserEntity.class);

		createUserRequest.setEmail("anomakyr@gmail.com");

		doNothing().when(emailService).sendOtpCodeViaEmail(anyString(), anyInt());

		when(utils.generatePublicId(15)).thenReturn(publicId);
		when(institutionRepository.findByName(anyString())).thenReturn(institutionEntity);

		when(roleRepository.findByName(ROLE_USER.name())).thenReturn(userRoleEntity);
		when(roleRepository.findByName(ROLE_ORGANIZER.name())).thenReturn(organizerRoleEntity);

		if (roleRandom == 1) {
			when(organizerEmailRepository.findByEmail(anyString())).thenReturn(null);
		} else {
			when(organizerEmailRepository.findByEmail(anyString())).thenReturn(organizerEmailEntity);
		}

		userService.createUser(createUserRequest);

		verify(userRepository).save(userEntityArgumentCaptor.capture());

		capturedUserEntity = userEntityArgumentCaptor.getValue();

		assertEquals(15, capturedUserEntity.getPublicId().length());
		assertEquals(capturedUserEntity.getEmailVerificationStatus(), false);
		assertEquals(4, capturedUserEntity.getOtpCode().toString().length());

		assertNotNull(capturedUserEntity.getEmail());
		assertNotNull(capturedUserEntity.getUsername());

		if (roleRandom == 1) {
			assertEquals(ROLE_USER.name(), capturedUserEntity.getRole().getName());
		} else {
			assertEquals(ROLE_ORGANIZER.name(), capturedUserEntity.getRole().getName());
		}
	}

	/**
	 * Tests the CreateUser method when it returns the email already exists error.
	 */
	@Test
	final void testCreateUser_EmailAlreadyTakenException() {
		when(userRepository.findByEmail(anyString())).thenReturn(userEntity);

		BaseException exception = assertThrows(BaseException.class, () -> userService.createUser(createUserRequest));

		assertEquals(ErrorCode.USER_EMAIL_ALREADY_TAKEN.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.USER_EMAIL_ALREADY_TAKEN.getErrorMessage(), exception.getErrorMessage());
	}

	/**
	 * Tests the CreateUser method when it returns the username already exists error.
	 */
	@Test
	final void testCreateUser_UsernameAlreadyTakenException() {
		when(userRepository.findByUsername(anyString())).thenReturn(userEntity);

		BaseException exception = assertThrows(BaseException.class, () -> userService.createUser(createUserRequest));

		assertEquals(ErrorCode.USER_USERNAME_ALREADY_TAKEN.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.USER_USERNAME_ALREADY_TAKEN.getErrorMessage(), exception.getErrorMessage());
	}

	/**
	 * Tests the CreateUser method when it returns the institution not found with given name error.
	 */
	@Test
	final void testCreateUser_InstitutionNotFoundWithNameException() {
		when(institutionRepository.findByName(anyString())).thenReturn(null);

		BaseException exception = assertThrows(BaseException.class, () -> userService.createUser(createUserRequest));

		assertEquals(ErrorCode.INSTITUTION_NOT_FOUND_WITH_NAME.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.INSTITUTION_NOT_FOUND_WITH_NAME.getErrorMessage(), exception.getErrorMessage());
	}

	/**
	 * Tests the CreateUser method when it returns the email not sent error.
	 */
	@Test
	final void testCreateUser_RegistrationEmailNotSentException() {
		when(roleRepository.findByName(anyString())).thenReturn(userRoleEntity);
		when(organizerEmailRepository.findByEmail(anyString())).thenReturn(null);
		when(institutionRepository.findByName(anyString())).thenReturn(institutionEntity);

		BaseException exception = assertThrows(BaseException.class, () -> userService.createUser(createUserRequest));

		assertEquals(ErrorCode.REGISTRATION_EMAIL_NOT_SENT.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.REGISTRATION_EMAIL_NOT_SENT.getErrorMessage(), exception.getErrorMessage());
	}

	/**
	 * Tests the CreateUser method when it returns the email not sent error.
	 */
	@Test
	final void testCreateUser_UserNotSavedException() {
		createUserRequest.setEmail("geergely.zsolt@gmail.com");

		when(roleRepository.findByName(anyString())).thenReturn(userRoleEntity);
		when(organizerEmailRepository.findByEmail(anyString())).thenReturn(null);
		when(institutionRepository.findByName(anyString())).thenReturn(institutionEntity);

		doNothing().when(emailService).sendOtpCodeViaEmail(anyString(), anyInt());
		doThrow(new RuntimeException()).when(userRepository).save(any(UserEntity.class));

		BaseException exception = assertThrows(BaseException.class, () -> userService.createUser(createUserRequest));

		assertEquals(ErrorCode.USER_NOT_SAVED.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.USER_NOT_SAVED.getErrorMessage(), exception.getErrorMessage());
	}

	// Put
	// -----------------------------------------------------------------------------------------------------------------

	@Test
	final void testUpdateName_Success() {
		UserEntity capturedUserEntity;
		UpdateNameRequest payload = new UpdateNameRequest(lastName, firstName);
		ArgumentCaptor<UserEntity> userEntityCaptor = ArgumentCaptor.forClass(UserEntity.class);

		when(userRepository.findByPublicId(publicId)).thenReturn(userEntity);

		userService.updateName(publicId, payload);

		verify(userRepository).save(userEntityCaptor.capture());

		capturedUserEntity = userEntityCaptor.getValue();

		assertEquals(lastName, capturedUserEntity.getLastName());
		assertEquals(firstName, capturedUserEntity.getFirstName());
	}

	@Test
	final void testUpdateName_UserNotFoundWithPublicId() {
		BaseException exception;
		UpdateNameRequest payload = new UpdateNameRequest(lastName, firstName);

		when(userRepository.findByPublicId(publicId)).thenReturn(null);

		exception = assertThrows(BaseException.class, () -> userService.updateName(publicId, payload));

		assertEquals(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage(), exception.getErrorMessage());
	}

	@Test
	final void testUpdateName_UserNotSaved() {
		BaseException exception;
		UpdateNameRequest payload = new UpdateNameRequest(lastName, firstName);

		when(userRepository.findByPublicId(publicId)).thenReturn(userEntity);
		doThrow(new RuntimeException()).when(userRepository).save(any(UserEntity.class));

		exception = assertThrows(BaseException.class, () -> userService.updateName(publicId, payload));

		assertEquals(ErrorCode.USER_NOT_SAVED.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.USER_NOT_SAVED.getErrorMessage(), exception.getErrorMessage());
	}

	@Test
	final void testUpdateUsername_Success() {
		UserEntity capturedUserEntity;
		String expectedToken = "expectedToken";
		JwtBuilder jwtBuilder = mock(JwtBuilder.class);
		UpdateUsernameRequest payload = new UpdateUsernameRequest("updated-username");
		ArgumentCaptor<UserEntity> userEntityArgumentCaptor = ArgumentCaptor.forClass(UserEntity.class);

		when(userRepository.findByPublicId(publicId)).thenReturn(userEntity);
		when(userRepository.findByUsername(payload.getUsername())).thenReturn(null);

		when(jwtBuilder.setSubject(payload.getUsername())).thenReturn(jwtBuilder);
		when(jwtBuilder.setExpiration(any(Date.class))).thenReturn(jwtBuilder);
		when(jwtBuilder.signWith(any(SignatureAlgorithm.class), anyString())).thenReturn(jwtBuilder);
		when(jwtBuilder.compact()).thenReturn(expectedToken);

		String result = userService.updateUsername(publicId, payload);

		verify(userRepository).save(userEntityArgumentCaptor.capture());

		capturedUserEntity = userEntityArgumentCaptor.getValue();

		assertNotNull(capturedUserEntity.getEmail());
		assertNotNull(capturedUserEntity.getUsername());
		assertNotNull(capturedUserEntity.getEncryptedPassword());
		assertEquals(15, capturedUserEntity.getPublicId().length());
		assertEquals("updated-username", capturedUserEntity.getUsername());

		assertNotNull(result);
		assertTrue(result.length() > 0);
	}

	@Test
	final void testUpdateUsername_UsernameAlreadyTaken() {
		BaseException exception;
		UpdateUsernameRequest payload = new UpdateUsernameRequest(username);

		when(userRepository.findByUsername(anyString())).thenReturn(userEntity);

		exception = assertThrows(BaseException.class, () -> userService.updateUsername(publicId, payload));

		assertEquals(ErrorCode.USER_USERNAME_ALREADY_TAKEN.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.USER_USERNAME_ALREADY_TAKEN.getErrorMessage(), exception.getErrorMessage());
	}

	@Test
	final void testUpdateUsername_UserNotFoundWithPublicId() {
		BaseException exception;
		UpdateUsernameRequest payload = new UpdateUsernameRequest(username);

		when(userRepository.findByPublicId(anyString())).thenReturn(null);
		when(userRepository.findByUsername(anyString())).thenReturn(null);

		exception = assertThrows(BaseException.class, () -> userService.updateUsername(publicId, payload));

		assertEquals(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage(), exception.getErrorMessage());
	}

	@Test
	final void testUpdateUsername_UserNotSaved() {
		BaseException exception;
		UpdateUsernameRequest payload = new UpdateUsernameRequest(username);

		when(userRepository.findByUsername(anyString())).thenReturn(null);
		when(userRepository.findByPublicId(anyString())).thenReturn(userEntity);

		doThrow(new RuntimeException()).when(userRepository).save(any(UserEntity.class));

		exception = assertThrows(BaseException.class, () -> userService.updateUsername(publicId, payload));

		assertEquals(ErrorCode.USER_NOT_SAVED.getErrorCode(), exception.getErrorCode());
		assertEquals(ErrorMessage.USER_NOT_SAVED.getErrorMessage(), exception.getErrorMessage());
	}

	@Test
	final void updateImagePath_Success() {
		UserEntity capturedUserEntity;
		String updatedImagePath = "updated-image-path";
		UpdateImagePathRequest payload = new UpdateImagePathRequest(updatedImagePath);
		ArgumentCaptor<UserEntity> userEntityCaptor = ArgumentCaptor.forClass(UserEntity.class);

		when(userRepository.findByPublicId(publicId)).thenReturn(userEntity);

		userService.updateImagePath(publicId, payload);

		verify(userRepository).save(userEntityCaptor.capture());

		capturedUserEntity = userEntityCaptor.getValue();

		assertEquals(updatedImagePath, capturedUserEntity.getImagePath());
	}

	@Test
	final void updateInstitution_Success() {
		// Arrange
		List<InstitutionEntity> institutionEntities = new ArrayList<>();
		String countyName = "Hargita";
		UpdateInstitutionRequest payload = new UpdateInstitutionRequest(countyName, institutionName);

		institutionEntities.add(institutionEntity);

		when(userRepository.findByPublicId(publicId)).thenReturn(userEntity);
		when(institutionRepository.save(institutionEntity)).thenReturn(institutionEntity);
		when(institutionRepository.findAllByName(anyString())).thenReturn(institutionEntities);

		for (InstitutionEntity institutionEntityTemp : institutionEntities) {
			if (Objects.equals(institutionEntityTemp.getSettlement().getCounty().getName(), countyName)) {
				institutionEntity = institutionEntityTemp;
				break;
			}
		}

		// Act
		assertDoesNotThrow(() -> userService.updateInstitution(publicId, payload));

		// Assert
		assertEquals(institutionEntity, userEntity.getInstitution());

		// Verify repository interactions
		verify(userRepository).save(userEntity);
		verify(userRepository).findByPublicId(publicId);
		verify(institutionRepository).findAllByName(institutionName);
		verifyNoMoreInteractions(userRepository, institutionRepository);
	}

	@Test
	void testVerifyEmailByOtpCode_Success() {
		// Arrange
		VerifyEmailByOtpCodeRequest payload = new VerifyEmailByOtpCodeRequest(otpCode, email);

		when(userRepository.findByEmail(email)).thenReturn(userEntity);

		// Act
		assertDoesNotThrow(() -> userService.verifyEmailByOtpCode(payload));

		// Assert
		assertTrue(userEntity.getEmailVerificationStatus());
		assertNull(userEntity.getOtpCode());

		// Verify repository interactions
		verify(userRepository).findByEmail(email);
		verify(userRepository).save(userEntity);
		verifyNoMoreInteractions(userRepository);
	}

	// Other
	// -----------------------------------------------------------------------------------------------------------------

	@Test
	void testLoadUserByUsername_Success() {
		when(userRepository.findByUsername(username)).thenReturn(userEntity);

		// Act
		UserDetails userDetails = assertDoesNotThrow(() -> userService.loadUserByUsername(username));

		// Assert
		assertNotNull(userDetails);
		assertEquals(username, userDetails.getUsername());

		// Verify repository interactions
		verify(userRepository).findByUsername(username);
		verifyNoMoreInteractions(userRepository);
	}

	@Test
	void testGetUserByUsername_UserFound() {
		when(userRepository.findByUsername(username)).thenReturn(userEntity);

		// Act
		String result = assertDoesNotThrow(() -> userService.getUserByUsername(username));

		// Assert
		assertNotNull(result);
		assertEquals(publicId, result);

		// Verify repository interactions
		verify(userRepository).findByUsername(username);
		verifyNoMoreInteractions(userRepository);
	}
}