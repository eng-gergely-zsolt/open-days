package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.UserDto;
import org.springframework.security.core.userdetails.UserDetailsService;

public interface UserService extends UserDetailsService {
    UserDto getUser(String email);

    UserDto createUser(UserDto user);

    UserDto getUserByObjectId(String objectId);

    UserDto updateUser(UserDto user, String objectId);

    void deleteUser(String objectId);
}
