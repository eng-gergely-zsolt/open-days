package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.ui.model.request.user.*;
import com.sapientia.open.days.backend.ui.model.User;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;

public interface UserService extends UserDetailsService {

	// Get
	User getUserByPublicId(String publicId);

	List<User> getPaginatedUsers(int pageNumber, int recordPerPage);

	//	Post
	void createUser(CreateUserRequest user);

	// Put

	void updateName(String publicId, UpdateNameRequest payload);

	String updateUsername(String publicId, UpdateUsernameRequest payload);

	void updateImagePath(String publicId, UpdateImagePathRequest payload);

	void updateInstitution(String publicId, UpdateInstitutionRequest payload);

	void verifyEmailByOtpCode(VerifyEmailByOtpCodeRequest payload);

	// Other
	String getUserByUsername(String email);
}
