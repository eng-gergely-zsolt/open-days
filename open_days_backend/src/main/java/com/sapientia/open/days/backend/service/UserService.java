package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.UserDto;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;

public interface UserService extends UserDetailsService {
    UserDto getUser(String email);

    UserDto createUser(UserDto user);

    UserDto getUserByObjectId(String objectId);

    UserDto updateUser(UserDto user, String objectId);

    List<UserDto> getUsers(int pageNumber, int recordPerPage);

    void deleteUser(String objectId);

    boolean verifyEmailVerificationToken(String emailVerificationToken);

    boolean requestPasswordReset(String emailAddress);

    boolean resetPassword(String token, String password);
}
