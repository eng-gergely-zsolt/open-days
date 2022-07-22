package com.sapientia.open.days.backend.ui.controller;

import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.dto.UserDto;
import com.sapientia.open.days.backend.ui.model.request.UserDetailsRequestModel;
import com.sapientia.open.days.backend.ui.model.response.UserRest;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("users")
public class UserController {

    @Autowired
    UserService userService;

    @GetMapping
    public String getUser() {return "getUser was called";}

    @PostMapping
    public UserRest createUser(@RequestBody UserDetailsRequestModel userDetails) {
        UserRest returnValue = new UserRest();

        UserDto userDto = new UserDto();
        BeanUtils.copyProperties(userDetails, userDto);

        UserDto createdUser = userService.createUser(userDto);
        BeanUtils.copyProperties(createdUser, returnValue);

        return returnValue;
    }

    @PutMapping
    public String updateUser() {return "updateUser was called";}

    @DeleteMapping
    public String deleteUser() {return "deleteUser was called";}
}
