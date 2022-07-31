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
}
