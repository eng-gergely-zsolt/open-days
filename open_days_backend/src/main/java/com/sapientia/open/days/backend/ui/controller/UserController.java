package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.BaseException;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.ui.model.request.user.*;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("user")
public class UserController {

	@Autowired
	UserService userService;

	// Get
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Has only testing purposes.
	 */
	@GetMapping(path = "/test")
	public void getTest() {
	}

	/**
	 * Verifies if the given authorization token is valid or not.
	 */
	@GetMapping(path = "/verify-authorization-token")
	public void verifyAuthorizationToken() {
	}

	/**
	 * Returns the user data identified by the given public id.
	 */
	@GetMapping(value = "/user-by-id")
	@PostAuthorize("hasRole('ADMIN') or returnObject.publicId == principal.publicId")
	public User getUserByPublicId(@RequestHeader(value = "User-Public-ID") String publicId) {
		if (publicId == null || publicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		return userService.getUserByPublicId(publicId);
	}

	/**
	 * Returns the list of users paginated.
	 *
	 * @param pageNumber    The number of page.
	 * @param recordPerPage The number of returned users on a single page.
	 */
	@GetMapping(path = "/paginated-users")
	public List<User> getPaginatedUsers(
			@RequestParam(value = "page", defaultValue = "0") int pageNumber,
			@RequestParam(value = "limit", defaultValue = "25") int recordPerPage) {
		return userService.getPaginatedUsers(pageNumber, recordPerPage);
	}

	// Post
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Creates a new user at registration.
	 */
	@PostMapping(path = "/create-user")
	public void createUser(@RequestBody CreateUserRequest payload) {

		if (payload.getEmail().isEmpty()) {
			throw new BaseException(ErrorCode.USER_INVALID_EMAIL.getErrorCode(),
					ErrorMessage.USER_INVALID_EMAIL.getErrorMessage());
		}

		if (payload.getPassword().isEmpty()) {
			throw new BaseException(ErrorCode.USER_INVALID_FIRST_PASSWORD.getErrorCode(),
					ErrorMessage.USER_INVALID_FIRST_PASSWORD.getErrorMessage());
		}

		if (payload.getUsername() == null || payload.getUsername().isEmpty()) {
			throw new BaseException(ErrorCode.USER_INVALID_USERNAME.getErrorCode(),
					ErrorMessage.USER_INVALID_USERNAME.getErrorMessage());
		}

		if (payload.getLastName().isEmpty()) {
			throw new BaseException(ErrorCode.USER_INVALID_LAST_NAME.getErrorCode(),
					ErrorMessage.USER_INVALID_LAST_NAME.getErrorMessage());
		}

		if (payload.getFirstName().isEmpty()) {
			throw new BaseException(ErrorCode.USER_INVALID_FIRST_NAME.getErrorCode(),
					ErrorMessage.USER_INVALID_FIRST_NAME.getErrorMessage());
		}

		if (payload.getInstitutionName().isEmpty()) {
			throw new BaseException(ErrorCode.INSTITUTION_INVALID_NAME.getErrorCode(),
					ErrorMessage.INSTITUTION_INVALID_NAME.getErrorMessage());
		}

		userService.createUser(payload);
	}

	// Put
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Updates the first and last name of the user identified by the given public id.
	 */
	@PutMapping(path = "/update-name")
	public void updateName(@RequestBody UpdateNameRequest payload,
	                       @RequestHeader(value = "User-Public-ID") String publicId) {
		if (publicId == null || publicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		if (payload.getLastName() == null || payload.getLastName().length() < 3 || payload.getLastName().length() > 50) {
			throw new BaseException(ErrorCode.USER_INVALID_LAST_NAME.getErrorCode(),
					ErrorMessage.USER_INVALID_LAST_NAME.getErrorMessage());
		}

		if (payload.getFirstName() == null || payload.getFirstName().length() < 3 || payload.getFirstName().length() > 50) {
			throw new BaseException(ErrorCode.USER_INVALID_FIRST_NAME.getErrorCode(),
					ErrorMessage.USER_INVALID_FIRST_NAME.getErrorMessage());
		}

		userService.updateName(publicId, payload);
	}

	/**
	 * Updates the image path of the user identified by the given public id.
	 */
	@PutMapping(path = "/update-image-path")
	public void updateImagePath(@RequestBody UpdateImagePathRequest payload,
	                            @RequestHeader(value = "User-Public-ID") String publicId) {
		if (publicId == null || publicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		if (payload.getImagePath() == null) {
			throw new BaseException(ErrorCode.USER_INVALID_IMAGE_PATH.getErrorCode(),
					ErrorMessage.USER_INVALID_IMAGE_PATH.getErrorMessage());
		}

		userService.updateImagePath(publicId, payload);
	}

	/**
	 * Updates the institution of the user identified by the given public id.
	 */
	@PutMapping(path = "/update-institution")
	public void updateInstitution(@RequestBody UpdateInstitutionRequest payload,
	                              @RequestHeader(value = "User-Public-ID") String publicId) {
		if (publicId == null || publicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		if (payload.getCountyName() == null) {
			throw new BaseException(ErrorCode.COUNTY_INVALID_NAME.getErrorCode(),
					ErrorMessage.COUNTY_INVALID_NAME.getErrorMessage());
		}

		if (payload.getInstitutionName() == null) {
			throw new BaseException(ErrorCode.INSTITUTION_INVALID_NAME.getErrorCode(),
					ErrorMessage.INSTITUTION_INVALID_NAME.getErrorMessage());
		}

		userService.updateInstitution(publicId, payload);
	}

	/**
	 * Updates the username of the user identified by the given public id.
	 */
	@PutMapping(path = "/update-username")
	public ResponseEntity<Void> updateUsername(@RequestBody UpdateUsernameRequest payload,
	                                           @RequestHeader(value = "User-Public-ID") String publicId) {
		if (publicId == null || publicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		if (payload.getUsername() == null || payload.getUsername().length() < 3 || payload.getUsername().length() > 50) {
			throw new BaseException(ErrorCode.USER_INVALID_USERNAME.getErrorCode(),
					ErrorMessage.USER_INVALID_USERNAME.getErrorMessage());
		}

		HttpHeaders headers = new HttpHeaders();
		String authorizationToken = userService.updateUsername(publicId, payload);

		headers.add("Authorization", authorizationToken);
		return new ResponseEntity<>(headers, HttpStatus.OK);
	}

	/**
	 * Authenticates the email by the code that was sent to the user via email.
	 */
	@PutMapping("/verify-email-by-otp-code")
	public void verifyEmailByOtpCode(@RequestBody VerifyEmailByOtpCodeRequest payload) {
		if (payload.getEmail() == null) {
			throw new BaseException(ErrorCode.USER_INVALID_EMAIL.getErrorCode(),
					ErrorMessage.USER_INVALID_EMAIL.getErrorMessage());
		}

		if (payload.getOtpCode() < 1000 || payload.getOtpCode() > 9999) {
			throw new BaseException(ErrorCode.USER_INVALID_OTP_CODE.getErrorCode(),
					ErrorMessage.USER_INVALID_OTP_CODE.getErrorMessage());
		}

		userService.verifyEmailByOtpCode(payload);
	}
}
