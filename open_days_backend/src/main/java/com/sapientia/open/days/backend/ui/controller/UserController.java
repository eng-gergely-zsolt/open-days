package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.exceptions.UserServiceException;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.dto.UserDto;
import com.sapientia.open.days.backend.ui.model.request.UserDetailsRequestModel;
import com.sapientia.open.days.backend.ui.model.response.ErrorMessages;
import com.sapientia.open.days.backend.ui.model.response.OperationStatusModel;
import com.sapientia.open.days.backend.ui.model.response.RequestOperationStatus;
import com.sapientia.open.days.backend.ui.model.response.UserRest;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("users")
public class UserController {

    @Autowired
    UserService userService;

    @GetMapping(path = "/{objectId}")
    public UserRest getUser(@PathVariable String objectId) {
        UserRest result = new UserRest();

        UserDto userDto = userService.getUserByObjectId(objectId);
        BeanUtils.copyProperties(userDto, result);

        return result;
    }

    @GetMapping
    public List<UserRest> getUsers(@RequestParam(value = "page", defaultValue = "0") int page,
                                   @RequestParam(value = "limit", defaultValue = "25") int limit) {
        List<UserRest> result = new ArrayList<>();

        List<UserDto> users = userService.getUsers(page, limit);

        for (UserDto user : users) {
            UserRest userModel = new UserRest();
            BeanUtils.copyProperties(user, userModel);
            result.add(userModel);
        }

        return result;
    }

    @PostMapping
    public UserRest createUser(@RequestBody UserDetailsRequestModel userDetails) throws Exception {
        UserRest returnValue = new UserRest();

        if (userDetails.getFirstName().isEmpty())
            throw new UserServiceException(ErrorMessages.MISSING_REQUIRED_FIELD.getErrorMessage());

        UserDto userDto = new UserDto();
        BeanUtils.copyProperties(userDetails, userDto);

        UserDto createdUser = userService.createUser(userDto);
        BeanUtils.copyProperties(createdUser, returnValue);

        return returnValue;
    }

    @PutMapping(path = "/{objectId}")
    public UserRest updateUser(@PathVariable String objectId, @RequestBody UserDetailsRequestModel userDetails) {
        UserRest result = new UserRest();

        if (userDetails.getFirstName().isEmpty())
            throw new UserServiceException(ErrorMessages.MISSING_REQUIRED_FIELD.getErrorMessage());

        UserDto userDto = new UserDto();
        BeanUtils.copyProperties(userDetails, userDto);

        UserDto updatedUser = userService.updateUser(userDto, objectId);
        BeanUtils.copyProperties(updatedUser, result);

        return result;
    }

    @DeleteMapping(path = "/{objectId}")
    public OperationStatusModel deleteUser(@PathVariable String objectId) {
        OperationStatusModel result = new OperationStatusModel();
        result.setOperationName(RequestOperationName.DELETE.name());

        userService.deleteUser(objectId);

        result.setOperationResult(RequestOperationStatus.SUCCESS.name());
        return result;
    }

    /*
     * http://localhost:8080/mobile-app-ws/users/email-verification?token=<token>
     **/
    @GetMapping(path = "/email-verification")
    public OperationStatusModel verifyEmailToken(@RequestParam(value = "token") String emailVerificationToken) {
        OperationStatusModel returnValue = new OperationStatusModel();
        returnValue.setOperationName(RequestOperationName.VERIFY_EMAIL.name());

        boolean isVerified = userService.verifyEmailVerificationToken(emailVerificationToken);

        if (isVerified) {
            returnValue.setOperationResult(RequestOperationStatus.SUCCESS.name());
        } else {
            returnValue.setOperationResult(RequestOperationStatus.ERROR.name());
        }

        return returnValue;
    }
}
