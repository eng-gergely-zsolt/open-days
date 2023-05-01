package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.UserDTO;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateImagePathReq;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateInstitutionReq;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateNameReq;
import com.sapientia.open.days.backend.ui.model.request.user.VerifyEmailByOtpCodeReq;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateUsernameReq;
import com.sapientia.open.days.backend.ui.model.User;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;

public interface UserService extends UserDetailsService {

	// Get
	User getUserByPublicId(String publicId);

	List<UserDTO> getUsers(int pageNumber, int recordPerPage);

	//	Post
	void createUser(UserDTO user);

	// Put
	void updateName(UpdateNameReq payload);

	void updateImagePath(UpdateImagePathReq payload);

	String updateUsername(UpdateUsernameReq payload);

	UserDTO updateUser(UserDTO user, String publicId);

	void updateInstitution(UpdateInstitutionReq payload);

	void verifyEmailByOtpCode(VerifyEmailByOtpCodeReq payload);

	// Delete
	void deleteUser(String publicId);

	// Other
	UserDTO getUserByUsername(String email);
}
