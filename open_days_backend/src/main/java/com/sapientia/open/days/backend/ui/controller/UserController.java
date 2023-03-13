package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.GeneralServiceException;
import com.sapientia.open.days.backend.io.repository.OrganizerEmailRepository;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.Roles;
import com.sapientia.open.days.backend.shared.dto.UserDTO;
import com.sapientia.open.days.backend.ui.model.request.UserCreateRequestModel;
import com.sapientia.open.days.backend.ui.model.request.PasswordResetModel;
import com.sapientia.open.days.backend.ui.model.request.PasswordResetRequestModel;
import com.sapientia.open.days.backend.ui.model.request.UserUpdateRequestModel;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.resource.OperationStatus;
import com.sapientia.open.days.backend.ui.model.response.BaseResponse;
import com.sapientia.open.days.backend.ui.model.response.OperationStatusModel;
import com.sapientia.open.days.backend.ui.model.response.UserResponseModel;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

@RestController
@RequestMapping("users")
//@CrossOrigin(origins = "*")
public class UserController {

	@Autowired
	UserService userService;

	@Autowired
	OrganizerEmailRepository organizerEmailRepository;

	@PostAuthorize("hasRole('ADMIN') or returnObject.publicId == principal.publicId")
	@GetMapping(path = "/{publicId}")
	public UserResponseModel getUser(@PathVariable String publicId) {

		if (publicId.length() != 15) {
			throw new GeneralServiceException(ErrorCode.INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.INVALID_PUBLIC_ID.getErrorMessage());
		}

		UserResponseModel response = new UserResponseModel();

		UserDTO userDTO = userService.getUserByPublicId(publicId);
		BeanUtils.copyProperties(userDTO, response);

		return response;
	}

	@GetMapping
	public List<UserResponseModel> getUsers(
			@RequestParam(value = "page", defaultValue = "0") int page,
			@RequestParam(value = "limit", defaultValue = "25") int limit) {

		List<UserResponseModel> response = new ArrayList<>();
		List<UserDTO> users = userService.getUsers(page, limit);

		for (UserDTO user : users) {
			UserResponseModel userModel = new UserResponseModel();
			BeanUtils.copyProperties(user, userModel);
			response.add(userModel);
		}

		return response;
	}

	@PostMapping
	public OperationStatusModel createUser(@RequestBody UserCreateRequestModel createUserRequest) {

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

		if (createUserRequest.getInstitution().isEmpty()) {
			throw new GeneralServiceException(ErrorCode.MISSING_INSTITUTION.getErrorCode(),
					ErrorMessage.MISSING_INSTITUTION.getErrorMessage());
		}

		UserDTO userDTO = new UserDTO();
		BeanUtils.copyProperties(createUserRequest, userDTO);


		HashSet<String> roles = new HashSet<>(List.of(Roles.ROLE_USER.name()));

		if (organizerEmailRepository.findByEmail(createUserRequest.getEmail()) != null) {
			roles.add(Roles.ROLE_ORGANIZER.name());
		}

		userDTO.setRoles(roles);
		userService.createUser(userDTO);

		OperationStatusModel createUserResponse = new OperationStatusModel();
		createUserResponse.setOperationResult(OperationStatus.SUCCESS.name());

		return createUserResponse;
	}

	@PutMapping(path = "/{publicId}")
	public UserResponseModel updateUser(@PathVariable String publicId, @RequestBody UserUpdateRequestModel updateUserRequest) {

		if (publicId.length() != 15) {
			throw new GeneralServiceException(ErrorCode.INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.INVALID_PUBLIC_ID.getErrorMessage());
		}

		UserResponseModel response = new UserResponseModel();

		UserDTO userDTO = new UserDTO();
		BeanUtils.copyProperties(updateUserRequest, userDTO);

		UserDTO updatedUser = userService.updateUser(userDTO, publicId);
		BeanUtils.copyProperties(updatedUser, response);

		return response;
	}

	@PreAuthorize("hasRole('ROLE_ADMIN') or #publicId == principal.publicId")
//    @Secured("ROLE_ADMIN")
//    @PreAuthorize("hasAuthority('DELETE_AUTHORITY')")
	@DeleteMapping(path = "/{publicId}")
	public OperationStatusModel deleteUser(@PathVariable String publicId) {

		if (publicId.length() != 15) {
			throw new GeneralServiceException(ErrorCode.INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.INVALID_PUBLIC_ID.getErrorMessage());
		}

		OperationStatusModel result = new OperationStatusModel();

		userService.deleteUser(publicId);

		result.setOperationResult(OperationStatus.SUCCESS.name());

		return result;
	}

	/**
	 * It verifies the token that was sent to check the user's email.
	 *
	 * @param emailVerificationToken The token that was sent to the user.
	 * @return It returns a base response.
	 */
	@CrossOrigin(origins = "*")
	@GetMapping(path = "/email-verification")
	public BaseResponse verifyEmail(@RequestParam(value = "token") String emailVerificationToken) {
		return userService.verifyEmail(emailVerificationToken);
	}

	/*
	 * http://localhost:8080/open-days/users/password-reset-request
	 **/
	@PostMapping(path = "/password-reset-request")
	public OperationStatusModel requestPasswordReset(@RequestBody PasswordResetRequestModel passwordResetRequestPayload) {

		OperationStatusModel response = new OperationStatusModel();
		boolean operationResult = userService.requestPasswordReset(passwordResetRequestPayload.getEmail());

		response.setOperationResult(OperationStatus.ERROR.name());

		if (operationResult) {
			response.setOperationResult(OperationStatus.SUCCESS.name());
		}

		return response;
	}

	/*
	 * http://localhost:8080/open-days/users/password-reset
	 **/
	@PostMapping(path = "/password-reset")
	public OperationStatusModel resetPassword(@RequestBody PasswordResetModel passwordResetPayload) {

		OperationStatusModel response = new OperationStatusModel();

		boolean operationResult = userService.resetPassword(
				passwordResetPayload.getToken(),
				passwordResetPayload.getPassword());

		response.setOperationResult(OperationStatus.ERROR.name());

		if (operationResult) {
			response.setOperationResult(OperationStatus.SUCCESS.name());
		}

		return response;
	}
}
