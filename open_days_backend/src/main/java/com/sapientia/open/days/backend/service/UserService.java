package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.UserDTO;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;

public interface UserService extends UserDetailsService {
    UserDTO getUserByUsername(String email);

    UserDTO createUser(UserDTO user);

    UserDTO getUserByObjectId(String objectId);

    UserDTO updateUser(UserDTO user, String objectId);

    List<UserDTO> getUsers(int pageNumber, int recordPerPage);

    void deleteUser(String objectId);

    boolean verifyEmailVerificationToken(String emailVerificationToken);

    boolean requestPasswordReset(String emailAddress);

    boolean resetPassword(String token, String password);
}
