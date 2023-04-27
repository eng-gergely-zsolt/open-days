package com.sapientia.open.days.backend.service;

import com.sapientia.open.days.backend.shared.dto.UserDTO;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateImagePathReq;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateInstitutionReq;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateNameReq;
import com.sapientia.open.days.backend.ui.model.request.VerifyEmailByOtpCodeReq;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateUsernameReq;
import com.sapientia.open.days.backend.ui.model.response.UserResponse;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;

public interface UserService extends UserDetailsService {

	void createUser(UserDTO user);

	void deleteUser(String publicId);

	void updateName(UpdateNameReq payload);

	void updateImagePath(UpdateImagePathReq payload);

	String updateUsername(UpdateUsernameReq payload);

	void updateInstitution(UpdateInstitutionReq payload);

	UserDTO updateUser(UserDTO user, String publicId);

	void verifyEmailByOtpCode(VerifyEmailByOtpCodeReq payload);

	boolean requestPasswordReset(String emailAddress);

	boolean resetPassword(String token, String password);

	UserDTO getUserByUsername(String email);

	UserResponse getUserByPublicId(String publicId);

	List<UserDTO> getUsers(int pageNumber, int recordPerPage);
}
