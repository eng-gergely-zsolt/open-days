package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.UserDto;

public interface UserService {
    UserDto createUser(UserDto user);
}
