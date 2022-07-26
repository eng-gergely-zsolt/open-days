package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.UserDto;
import org.springframework.security.core.userdetails.UserDetailsService;

public interface UserService extends UserDetailsService {
    UserDto getUser(String email);

    UserDto createUser(UserDto user);
}
