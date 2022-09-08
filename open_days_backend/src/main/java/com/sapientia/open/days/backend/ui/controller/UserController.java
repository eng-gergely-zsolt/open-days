package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.UserServiceException;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.Roles;
import com.sapientia.open.days.backend.shared.dto.UserDTO;
import com.sapientia.open.days.backend.ui.model.request.PasswordResetModel;
import com.sapientia.open.days.backend.ui.model.request.PasswordResetRequestModel;
import com.sapientia.open.days.backend.ui.model.request.CreateUserRequestModel;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.resource.OperationStatus;
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
public class UserController {

	@Autowired
	UserService userService;

	@PostAuthorize("hasRole('ADMIN') or returnObject.objectId == principal.userId")
	@GetMapping(path = "/{objectId}")
	public UserResponseModel getUser(@PathVariable String objectId) {
		UserResponseModel result = new UserResponseModel();

		UserDTO userDto = userService.getUserByObjectId(objectId);
		BeanUtils.copyProperties(userDto, result);

		return result;
	}

	@GetMapping
	public List<UserResponseModel> getUsers(@RequestParam(value = "page", defaultValue = "0") int page,
	                                        @RequestParam(value = "limit", defaultValue = "25") int limit) {
		List<UserResponseModel> result = new ArrayList<>();

		List<UserDTO> users = userService.getUsers(page, limit);

		for (UserDTO user : users) {
			UserResponseModel userModel = new UserResponseModel();
			BeanUtils.copyProperties(user, userModel);
			result.add(userModel);
		}

		return result;
	}

	@PostMapping
	public OperationStatusModel createUser(@RequestBody CreateUserRequestModel createUserRequest) {

		if (createUserRequest.getEmail().isEmpty()) {
			throw new UserServiceException(ErrorCode.MISSING_EMAIL.getErrorCode(),
					ErrorMessage.MISSING_EMAIL.getErrorMessage());
		}

		if (createUserRequest.getPassword().isEmpty()) {
			throw new UserServiceException(ErrorCode.MISSING_PASSWORD.getErrorCode(),
					ErrorMessage.MISSING_PASSWORD.getErrorMessage());
		}

		if (createUserRequest.getUsername().isEmpty()) {
			throw new UserServiceException(ErrorCode.MISSING_USERNAME.getErrorCode(),
					ErrorMessage.MISSING_USERNAME.getErrorMessage());
		}

		if (createUserRequest.getLastName().isEmpty()) {
			throw new UserServiceException(ErrorCode.MISSING_LAST_NAME.getErrorCode(),
					ErrorMessage.MISSING_LAST_NAME.getErrorMessage());
		}

		if (createUserRequest.getFirstName().isEmpty()) {
			throw new UserServiceException(ErrorCode.MISSING_FIRST_NAME.getErrorCode(),
					ErrorMessage.MISSING_FIRST_NAME.getErrorMessage());
		}

		if (createUserRequest.getInstitution().isEmpty()) {
			throw new UserServiceException(ErrorCode.MISSING_INSTITUTION.getErrorCode(),
					ErrorMessage.MISSING_INSTITUTION.getErrorMessage());
		}

		UserDTO userDTO = new UserDTO();
		userDTO.setRoles(new HashSet<>(List.of(Roles.ROLE_USER.name())));

		BeanUtils.copyProperties(createUserRequest, userDTO);

		userService.createUser(userDTO);

		OperationStatusModel createUserResponse = new OperationStatusModel();
		createUserResponse.setOperationResult(OperationStatus.SUCCESS.name());

		return createUserResponse;
	}

	@PutMapping(path = "/{objectId}")
	public UserResponseModel updateUser(@PathVariable String objectId, @RequestBody CreateUserRequestModel userDetails) {
		UserResponseModel result = new UserResponseModel();

		if (userDetails.getFirstName().isEmpty())
			throw new UserServiceException(0, ErrorMessage.MISSING_REQUIRED_FIELD.getErrorMessage());

		UserDTO userDto = new UserDTO();
		BeanUtils.copyProperties(userDetails, userDto);

		UserDTO updatedUser = userService.updateUser(userDto, objectId);
		BeanUtils.copyProperties(updatedUser, result);

		return result;
	}

	@PreAuthorize("hasRole('ROLE_ADMIN') or #id == principal.userId")
//    @Secured("ROLE_ADMIN")
//    @PreAuthorize("hasAuthority('DELETE_AUTHORITY')")
	@DeleteMapping(path = "/{objectId}")
	public OperationStatusModel deleteUser(@PathVariable String objectId) {
		OperationStatusModel result = new OperationStatusModel();

		userService.deleteUser(objectId);

		result.setOperationResult(OperationStatus.SUCCESS.name());
		return result;
	}

	/*
	 * http://localhost:8080/open-days/users/email-verification?token=<token>
	 **/
	@GetMapping(path = "/email-verification")
	public ResponseEntity<OperationStatusModel> verifyEmailToken(@RequestParam(value = "token") String emailVerificationToken) {

		HttpHeaders responseHeaders = new HttpHeaders();
		OperationStatusModel responseBody = new OperationStatusModel();

		responseHeaders.set("Access-Control-Allow-Origin", "*");

		boolean isVerified = userService.verifyEmailVerificationToken(emailVerificationToken);

		if (isVerified) {
			responseBody.setOperationResult(OperationStatus.SUCCESS.name());
		} else {
			responseBody.setOperationResult(OperationStatus.ERROR.name());
		}

		return new ResponseEntity<>(responseBody, responseHeaders, HttpStatus.OK);
	}

	/*
	 * http://localhost:8080/open-days/users/password-reset-request
	 **/
	@PostMapping(path = "/password-reset-request")
	public OperationStatusModel requestPasswordReset(@RequestBody PasswordResetRequestModel passwordResetRequestModel) {

		OperationStatusModel response = new OperationStatusModel();
		boolean operationResult = userService.requestPasswordReset(passwordResetRequestModel.getEmail());

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
	public OperationStatusModel resetPassword(@RequestBody PasswordResetModel passwordResetModel) {

		OperationStatusModel responseBody = new OperationStatusModel();

		boolean operationResult = userService.resetPassword(
				passwordResetModel.getToken(),
				passwordResetModel.getPassword());

		responseBody.setOperationResult(OperationStatus.ERROR.name());

		if (operationResult) {
			responseBody.setOperationResult(OperationStatus.SUCCESS.name());
		}

		return responseBody;
	}
}
