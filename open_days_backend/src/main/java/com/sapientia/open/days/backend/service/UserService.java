package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.UserDTO;
import com.sapientia.open.days.backend.ui.model.response.BaseResponse;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;

public interface UserService extends UserDetailsService {

	void createUser(UserDTO user);

	void deleteUser(String publicId);

	boolean requestPasswordReset(String emailAddress);

	boolean resetPassword(String token, String password);

	UserDTO getUserByUsername(String email);

	UserDTO getUserByPublicId(String publicId);

	UserDTO updateUser(UserDTO user, String publicId);

	BaseResponse verifyEmail(String emailVerificationToken);

	List<UserDTO> getUsers(int pageNumber, int recordPerPage);
}
