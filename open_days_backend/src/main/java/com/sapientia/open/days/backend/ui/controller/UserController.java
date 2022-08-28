package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.UserServiceException;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.dto.UserDto;
import com.sapientia.open.days.backend.ui.model.request.PasswordResetModel;
import com.sapientia.open.days.backend.ui.model.request.PasswordResetRequestModel;
import com.sapientia.open.days.backend.ui.model.request.UserDetailsRequestModel;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.resource.OperationStatus;
import com.sapientia.open.days.backend.ui.model.response.*;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("users")
public class UserController {

    @Autowired
    UserService userService;

    @GetMapping(path = "/{objectId}")
    public UserResponseModel getUser(@PathVariable String objectId) {
        UserResponseModel result = new UserResponseModel();

        UserDto userDto = userService.getUserByObjectId(objectId);
        BeanUtils.copyProperties(userDto, result);

        return result;
    }

    @GetMapping
    public List<UserResponseModel> getUsers(@RequestParam(value = "page", defaultValue = "0") int page,
                                            @RequestParam(value = "limit", defaultValue = "25") int limit) {
        List<UserResponseModel> result = new ArrayList<>();

        List<UserDto> users = userService.getUsers(page, limit);

        for (UserDto user : users) {
            UserResponseModel userModel = new UserResponseModel();
            BeanUtils.copyProperties(user, userModel);
            result.add(userModel);
        }

        return result;
    }

    @PostMapping
    public UserResponseModel createUser(@RequestBody UserDetailsRequestModel userDetails) throws Exception {
        UserResponseModel response = new UserResponseModel();

        if (userDetails.getFirstName().isEmpty())
            throw new UserServiceException(ErrorMessage.MISSING_REQUIRED_FIELD.getErrorMessage());

        UserDto userDto = new UserDto();
        BeanUtils.copyProperties(userDetails, userDto);

        UserDto createdUser = userService.createUser(userDto);
        BeanUtils.copyProperties(createdUser, response);

        return response;
    }

    @PutMapping(path = "/{objectId}")
    public UserResponseModel updateUser(@PathVariable String objectId, @RequestBody UserDetailsRequestModel userDetails) {
        UserResponseModel result = new UserResponseModel();

        if (userDetails.getFirstName().isEmpty())
            throw new UserServiceException(ErrorMessage.MISSING_REQUIRED_FIELD.getErrorMessage());

        UserDto userDto = new UserDto();
        BeanUtils.copyProperties(userDetails, userDto);

        UserDto updatedUser = userService.updateUser(userDto, objectId);
        BeanUtils.copyProperties(updatedUser, result);

        return result;
    }

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
    public OperationStatusModel  requestPasswordReset(@RequestBody PasswordResetRequestModel passwordResetRequestModel) {

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
