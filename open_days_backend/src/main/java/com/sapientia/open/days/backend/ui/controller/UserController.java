package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.GeneralServiceException;
import com.sapientia.open.days.backend.io.repository.OrganizerEmailRepository;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.Roles;
import com.sapientia.open.days.backend.shared.dto.UserDTO;
import com.sapientia.open.days.backend.ui.model.request.user.*;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.response.BaseResponse;
import com.sapientia.open.days.backend.ui.model.OperationStatus;
import com.sapientia.open.days.backend.ui.model.User;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("users")
public class UserController {

	@Autowired
	UserService userService;

	@Autowired
	OrganizerEmailRepository organizerEmailRepository;

	// Get
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Has only testing purpose.
	 */
	@GetMapping(path = "/test")
	public void getTest() {
	}

	/**
	 * Verifies if the given authorization token is valid or not.
	 */
	@GetMapping(path = "/token-verification")
	public BaseResponse verifyAuthorizationToken() {
		return new BaseResponse(true);
	}

	/**
	 * Returns the user data identified by the given public id.
	 */
	@PostAuthorize("hasRole('ADMIN') or returnObject.publicId == principal.publicId")
	@GetMapping(path = "/{publicId}")
	public User getUserByPublicId(@PathVariable String publicId) {
		return userService.getUserByPublicId(publicId);
	}

	/**
	 * Returns the list of users paginated.
	 * @param pageNumber The number of page.
	 * @param recordPerPage The number of returned users on a single page.
	 */
	@GetMapping
	public List<User> getUsers(
			@RequestParam(value = "page", defaultValue = "0") int pageNumber,
			@RequestParam(value = "limit", defaultValue = "25") int recordPerPage) {

		List<User> response = new ArrayList<>();
		List<UserDTO> users = userService.getUsers(pageNumber, recordPerPage);

		for (UserDTO user : users) {
			User userModel = new User();
			BeanUtils.copyProperties(user, userModel);
			response.add(userModel);
		}

		return response;
	}

	// Post
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Creates a new user at registration.
	 */
	@PostMapping
	public OperationStatus createUser(@RequestBody CreateUserReq createUserRequest) {

		if (createUserRequest.getEmail().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.MISSING_EMAIL.getErrorCode(),
					ErrorMessage.MISSING_EMAIL.getErrorMessage());
		}

		if (createUserRequest.getPassword().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.MISSING_PASSWORD.getErrorCode(),
					ErrorMessage.MISSING_PASSWORD.getErrorMessage());
		}

		if (createUserRequest.getUsername() == null || createUserRequest.getUsername().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.MISSING_USERNAME.getErrorCode(),
					ErrorMessage.MISSING_USERNAME.getErrorMessage());
		}

		if (createUserRequest.getLastName().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.MISSING_LAST_NAME.getErrorCode(),
					ErrorMessage.MISSING_LAST_NAME.getErrorMessage());
		}

		if (createUserRequest.getFirstName().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.MISSING_FIRST_NAME.getErrorCode(),
					ErrorMessage.MISSING_FIRST_NAME.getErrorMessage());
		}

		if (createUserRequest.getInstitutionName().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.MISSING_INSTITUTION.getErrorCode(),
					ErrorMessage.MISSING_INSTITUTION.getErrorMessage());
		}

		String role;
		UserDTO userDTO = new UserDTO();
		BeanUtils.copyProperties(createUserRequest, userDTO);

		if (organizerEmailRepository.findByEmail(createUserRequest.getEmail()) == null) {
			role = Roles.ROLE_USER.name();
		} else {
			role = Roles.ROLE_ORGANIZER.name();
		}

		userDTO.setRole(role);
		userService.createUser(userDTO);

		OperationStatus createUserResponse = new OperationStatus();
		createUserResponse.setOperationResult(com.sapientia.open.days.backend.ui.model.resource.OperationStatus.SUCCESS.name());

		return createUserResponse;
	}

	// Put
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Updates the first and last name of the user identified by the given public id.
	 */
	@PutMapping(path = "/update-name")
	public void updateName(@RequestBody UpdateNameReq payload) {
		userService.updateName(payload);
	}

	/**
	 * Updates the image path of the user identified by the given public id.
	 */
	@PutMapping(path = "/update-image-path")
	public void updateImagePath(@RequestBody UpdateImagePathReq payload) {
		userService.updateImagePath(payload);
	}

	/**
	 * Updates the institution of the user identified by the given public id.
	 */
	@PutMapping(path = "/update-institution")
	public void updateInstitution(@RequestBody UpdateInstitutionReq payload) {
		userService.updateInstitution(payload);
	}

	/**
	 * Updates the username of the user identified by the given public id.
	 */
	@PutMapping(path = "/update-username")
	public ResponseEntity<Void> updateUsername(@RequestBody UpdateUsernameReq payload) {
		HttpHeaders headers = new HttpHeaders();
		String authorizationToken = userService.updateUsername(payload);

		headers.add("Authorization", authorizationToken);
		return new ResponseEntity<>(headers, HttpStatus.OK);
	}

	/**
	 * Updates the data of a user identified by the public id.
	 */
	@PutMapping(path = "/{publicId}")
	public User updateUser(@PathVariable String publicId, @RequestBody UpdateUserReq updateUserRequest) {

		if (publicId.length() != 15) {
			throw new GeneralServiceException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		User response = new User();

		UserDTO userDTO = new UserDTO();
		BeanUtils.copyProperties(updateUserRequest, userDTO);

		UserDTO updatedUser = userService.updateUser(userDTO, publicId);
		BeanUtils.copyProperties(updatedUser, response);

		return response;
	}

	/**
	 * Authenticates the email by the code that was sent to the user via email.
	 */
	@PutMapping("/email-verification-otp-code")
	public void verifyEmailByOtpCode(@RequestBody VerifyEmailByOtpCodeReq payload) {
		userService.verifyEmailByOtpCode(payload);
	}

	/**
	 * Deletes a user identified by the public id.
	 */
	@PreAuthorize("hasRole('ROLE_ADMIN') or #publicId == principal.publicId")
	@DeleteMapping(path = "/{publicId}")
	public OperationStatus deleteUser(@PathVariable String publicId) {

		if (publicId.length() != 15) {
			throw new GeneralServiceException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		OperationStatus result = new OperationStatus();

		userService.deleteUser(publicId);

		result.setOperationResult(com.sapientia.open.days.backend.ui.model.resource.OperationStatus.SUCCESS.name());

		return result;
	}
}
