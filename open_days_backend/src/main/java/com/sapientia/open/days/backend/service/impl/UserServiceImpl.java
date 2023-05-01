package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.exceptions.BaseException;
import com.sapientia.open.days.backend.exceptions.GeneralServiceException;
import com.sapientia.open.days.backend.io.entity.*;
import com.sapientia.open.days.backend.io.repository.*;
import com.sapientia.open.days.backend.security.SecurityConstants;
import com.sapientia.open.days.backend.security.UserPrincipal;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.EmailService;
import com.sapientia.open.days.backend.shared.Utils;
import com.sapientia.open.days.backend.shared.dto.UserDTO;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateImagePathReq;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateInstitutionReq;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateNameReq;
import com.sapientia.open.days.backend.ui.model.request.user.VerifyEmailByOtpCodeReq;
import com.sapientia.open.days.backend.ui.model.request.user.UpdateUsernameReq;
import com.sapientia.open.days.backend.ui.model.resource.ErrorCode;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import com.sapientia.open.days.backend.ui.model.User;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.*;

import static com.sapientia.open.days.backend.security.SecurityConstants.TOKEN_PREFIX;

@Service
@SuppressWarnings("unused")
public class UserServiceImpl implements UserService {

	@Autowired
	Utils utils;

	@Autowired
	EmailService emailService;

	@Autowired
	UserRepository userRepository;

	@Autowired
	RoleRepository roleRepository;

	@Autowired
	CountyRepository countyRepository;

	@Autowired
	SettlementRepository settlementRepository;

	@Autowired
	InstitutionRepository institutionRepository;

	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;

	@Autowired
	PasswordResetTokenRepository passwordResetTokenRepository;

	// Get
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Returns the user data identified by the given public id.
	 */
	@Override
	public User getUserByPublicId(String publicId) {
		SettlementEntity settlement;
		InstitutionEntity institution;

		User result = new User();
		List<String> userRoles = new ArrayList<>();
		UserEntity user = userRepository.findByPublicId(publicId);

		if (publicId.length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		if (user == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		BeanUtils.copyProperties(user, result);

		result.setRoleName(user.getRole().getName());
		result.setInstitutionName(user.getInstitution().getName());
		result.setCountyName(user.getInstitution().getSettlement().getCounty().getName());

		return result;
	}

	/**
	 * Returns the list of users paginated.
	 * @param pageNumber The number of page.
	 * @param recordPerPage The number of returned users on a single page.
	 */
	@Override
	public List<UserDTO> getUsers(int pageNumber, int recordPerPage) {

		List<UserDTO> result = new ArrayList<>();

		if (pageNumber < 0) pageNumber = 1;
		if (pageNumber > 0) pageNumber -= 1;

		Pageable pageableRequest = PageRequest.of(pageNumber, recordPerPage);

		Page<UserEntity> userPage = userRepository.findAll(pageableRequest);
		List<UserEntity> users = userPage.getContent();

		for (UserEntity user : users) {
			UserDTO userDTO = new UserDTO();
			BeanUtils.copyProperties(user, userDTO);
			result.add(userDTO);
		}

		return result;
	}

	// Post
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Creates a new user at registration.
	 */
	@Override
	public void createUser(UserDTO user) {
		InstitutionEntity institution = institutionRepository.findByName(user.getInstitution());

		if (institution == null) {
			throw new GeneralServiceException(ErrorCode.INSTITUTION_NOT_EXISTS.getErrorCode(),
					ErrorMessage.INSTITUTION_NOT_EXISTS.getErrorMessage());
		}

		if (userRepository.findByEmail(user.getEmail()) != null) {
			throw new GeneralServiceException(ErrorCode.EMAIL_ALREADY_REGISTERED.getErrorCode(),
					ErrorMessage.EMAIL_ALREADY_REGISTERED.getErrorMessage());
		}

		UserEntity userEntity = new UserEntity();
		BeanUtils.copyProperties(user, userEntity);

		String publicId = utils.generatePublicId(15);
		RoleEntity role = roleRepository.findByName(user.getRole());

		userEntity.setRoles(role);
		userEntity.setPublicId(publicId);
		userEntity.setInstitution(institution);
		userEntity.setEmailVerificationStatus(false);
		userEntity.setEncryptedPassword(bCryptPasswordEncoder.encode(user.getPassword()));

		int otpCode = Utils.generateSixDigitNumber();
		userEntity.setOtpCode(otpCode);

		try {
			new EmailService().sendOtpCodeViaEmail(user.getEmail(), otpCode);
			UserEntity storedUserDetails = userRepository.save(userEntity);
		} catch (Exception e) {
			throw new BaseException(ErrorCode.REGISTRATION_EMAIL_NOT_SENT.getErrorCode(),
					ErrorMessage.REGISTRATION_EMAIL_NOT_SENT.getErrorMessage());
		}
	}

	// Put
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Updates the first and last name of the user identified by the given public id.
	 */
	@Override
	public void updateName(UpdateNameReq payload) {
		UserEntity user;

		if (payload.getPublicId() == null || payload.getPublicId().length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		if (payload.getLastName() == null || payload.getLastName().length() < 3 || payload.getLastName().length() > 50) {
			throw new BaseException(ErrorCode.USER_INVALID_LAST_NAME.getErrorCode(),
					ErrorMessage.USER_INVALID_LAST_NAME.getErrorMessage());
		}

		if (payload.getFirstName() == null || payload.getFirstName().length() < 3 || payload.getFirstName().length() > 50) {
			throw new BaseException(ErrorCode.USER_INVALID_FIRST_NAME.getErrorCode(),
					ErrorMessage.USER_INVALID_FIRST_NAME.getErrorMessage());
		}

		user = userRepository.findByPublicId(payload.getPublicId());

		if (user == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		user.setLastName(payload.getLastName());
		user.setFirstName(payload.getFirstName());

		try {
			userRepository.save(user);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.DB_USER_NOT_SAVED.getErrorCode(),
					ErrorMessage.DB_USER_NOT_SAVED.getErrorMessage());
		}
	}

	/**
	 * Updates the image path of the user identified by the given public id.
	 */
	@Override
	public void updateImagePath(UpdateImagePathReq payload) {
		UserEntity user;

		if (payload.getPublicId() == null || payload.getPublicId().length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		user = userRepository.findByPublicId(payload.getPublicId());

		if (user == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		user.setImagePath(payload.getImagePath());

		try {
			userRepository.save(user);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.DB_USER_NOT_SAVED.getErrorCode(),
					ErrorMessage.DB_USER_NOT_SAVED.getErrorMessage());
		}
	}

	/**
	 * Updates the username of the user identified by the given public id.
	 */
	@Override
	public String updateUsername(UpdateUsernameReq payload) {
		UserEntity user;
		String authorizationToken;

		if (payload.getPublicId() == null || payload.getPublicId().length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		if (payload.getUsername() == null || payload.getUsername().length() < 3 || payload.getUsername().length() > 50) {
			throw new BaseException(ErrorCode.USER_INVALID_USERNAME.getErrorCode(),
					ErrorMessage.USER_INVALID_USERNAME.getErrorMessage());
		}

		user = userRepository.findByUsername(payload.getUsername());

		if (user != null) {
			throw new BaseException(ErrorCode.USER_USERNAME_ALREADY_TAKEN.getErrorCode(),
					ErrorMessage.USER_USERNAME_ALREADY_TAKEN.getErrorMessage());
		}

		user = userRepository.findByPublicId(payload.getPublicId());

		if (user == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		user.setUsername(payload.getUsername());

		try {
			userRepository.save(user);

			authorizationToken = TOKEN_PREFIX + Jwts.builder()
					.setSubject(payload.getUsername())
					.setExpiration(new Date(System.currentTimeMillis() + SecurityConstants.EXPIRATION_TIME))
					.signWith(SignatureAlgorithm.HS512, SecurityConstants.getJwtSecretKey())
					.compact();
		} catch (Exception error) {
			throw new BaseException(ErrorCode.DB_USER_NOT_SAVED.getErrorCode(),
					ErrorMessage.DB_USER_NOT_SAVED.getErrorMessage());
		}

		return authorizationToken;
	}

	/**
	 * Updates the data of a user identified by the public id.
	 */
	@Override
	public UserDTO updateUser(UserDTO user, String publicId) {
		UserEntity userEntity = userRepository.findByPublicId(publicId);

		if (userEntity == null) {
			throw new GeneralServiceException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		if (user.getLastName().length() >= 3 && user.getLastName().length() <= 50) {
			userEntity.setLastName(user.getLastName());
		}

		if (user.getFirstName().length() >= 3 && user.getFirstName().length() <= 50) {
			userEntity.setFirstName(user.getFirstName());
		}

		UserEntity updatedUserDetails = userRepository.save(userEntity);

		UserDTO result = new UserDTO();
		BeanUtils.copyProperties(updatedUserDetails, result);

		return result;
	}

	/**
	 * Updates the institution of the user identified by the given public id.
	 */
	@Override
	public void updateInstitution(UpdateInstitutionReq payload) {
		UserEntity user;
		InstitutionEntity institution = null;
		List<InstitutionEntity> institutions;

		if (payload.getPublicId() == null || payload.getPublicId().length() != 15) {
			throw new BaseException(ErrorCode.USER_INVALID_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_INVALID_PUBLIC_ID.getErrorMessage());
		}

		user = userRepository.findByPublicId(payload.getPublicId());

		if (user == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		institutions = institutionRepository.findAllByName(payload.getInstitutionName());

		for (InstitutionEntity institutionTemp : institutions) {
			if (Objects.equals(institutionTemp.getSettlement().getCounty().getName(), payload.getCountyName())) {
				institution = institutionTemp;
			}
		}

		if (institution == null) {
			throw new BaseException(ErrorCode.USER_INSTITUTION_NOT_FOUND.getErrorCode(),
					ErrorMessage.USER_INSTITUTION_NOT_FOUND.getErrorMessage());
		}

		user.setInstitution(institution);

		try {
			userRepository.save(user);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.DB_USER_NOT_SAVED.getErrorCode(),
					ErrorMessage.DB_USER_NOT_SAVED.getErrorMessage());
		}
	}

	/**
	 * Authenticates the email by the code that was sent to the user via email.
	 */
	@Override
	public void verifyEmailByOtpCode(VerifyEmailByOtpCodeReq payload) {
		UserEntity user = userRepository.findByEmail(payload.getEmail());

		if (user == null) {
			throw new BaseException(ErrorCode.EMAIL_VERIFICATION_INVALID_EMAIL.getErrorCode(),
					ErrorMessage.EMAIL_VERIFICATION_INVALID_EMAIL.getErrorMessage());
		}

		if (user.getEmailVerificationStatus()) {
			throw new BaseException(ErrorCode.EMAIL_VERIFICATION_EMAIL_ALREADY_VERIFIED.getErrorCode(),
					ErrorMessage.EMAIL_VERIFICATION_EMAIL_ALREADY_VERIFIED.getErrorMessage());
		}

		if (user.getOtpCode() != payload.getOtpCode()) {
			throw new BaseException(ErrorCode.EMAIL_VERIFICATION_INVALID_OTP_CODE.getErrorCode(),
					ErrorMessage.EMAIL_VERIFICATION_INVALID_OTP_CODE.getErrorMessage());
		}

		user.setOtpCode(null);
		user.setEmailVerificationStatus(true);

		try {
			userRepository.save(user);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.UNSPECIFIED_ERROR.getErrorCode(), error.getMessage());
		}
	}

	// Delete
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Deletes a user identified by the public id.
	 */
	@Override
	public void deleteUser(String publicId) {

		UserEntity userEntity = userRepository.findByPublicId(publicId);

		if (userEntity == null) {
			throw new GeneralServiceException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		userRepository.delete(userEntity);
	}

	// Other
	// -----------------------------------------------------------------------------------------------------------------
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		UserEntity userEntity = userRepository.findByUsername(username);

		if (userEntity == null)
			throw new UsernameNotFoundException(username);

		return new UserPrincipal(userEntity);
	}

	@Override
	public UserDTO getUserByUsername(String username) {
		UserEntity userEntity = userRepository.findByUsername(username);

		if (userEntity == null) {
			throw new GeneralServiceException(ErrorCode.USER_NOT_FOUND_WITH_USERNAME.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_USERNAME.getErrorMessage());
		}

		UserDTO result = new UserDTO();
		BeanUtils.copyProperties(userEntity, result);

		return result;
	}
}
