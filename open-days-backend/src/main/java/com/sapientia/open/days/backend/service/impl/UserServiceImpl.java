package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.exceptions.BaseException;
import com.sapientia.open.days.backend.io.entity.*;
import com.sapientia.open.days.backend.io.repository.*;
import com.sapientia.open.days.backend.security.SecurityConstants;
import com.sapientia.open.days.backend.security.UserPrincipal;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.EmailService;
import com.sapientia.open.days.backend.shared.Roles;
import com.sapientia.open.days.backend.shared.Utils;
import com.sapientia.open.days.backend.ui.model.request.user.*;
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
	OrganizerEmailRepository organizerEmailRepository;

	// Get
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Returns the user data identified by the given public id.
	 */
	@Override
	public User getUserByPublicId(String publicId) {
		User user = new User();
		UserEntity userEntity = userRepository.findByPublicId(publicId);

		if (userEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		BeanUtils.copyProperties(userEntity, user);

		user.setRoleName(userEntity.getRole().getName());
		user.setInstitutionName(userEntity.getInstitution().getName());
		user.setCountyName(userEntity.getInstitution().getSettlement().getCounty().getName());

		return user;
	}

	/**
	 * Returns the list of users paginated.
	 *
	 * @param pageNumber    The number of page.
	 * @param recordPerPage The number of returned users on a single page.
	 */
	@Override
	public List<User> getPaginatedUsers(int pageNumber, int recordPerPage) {
		Pageable pageableRequest;
		Page<UserEntity> userPage;
		List<UserEntity> userEntities;
		List<User> users = new ArrayList<>();

		if (pageNumber < 0) pageNumber = 1;
		if (pageNumber > 0) pageNumber -= 1;

		pageableRequest = PageRequest.of(pageNumber, recordPerPage);
		userPage = userRepository.findAll(pageableRequest);
		userEntities = userPage.getContent();

		for (UserEntity userEntity : userEntities) {
			User user = new User();
			BeanUtils.copyProperties(userEntity, user);

			user.setRoleName(userEntity.getRole().getName());
			user.setInstitutionName(userEntity.getInstitution().getName());
			user.setCountyName(userEntity.getInstitution().getSettlement().getCounty().getName());

			users.add(user);
		}

		return users;
	}

	// Post
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Creates a new user at registration.
	 */
	@Override
	public void createUser(CreateUserRequest payload) {
		int otpCode;
		boolean isPublicIdValid = false;
		InstitutionEntity institutionEntity;
		OrganizerEmailEntity organizerEmailEntity;
		UserEntity newUserEntity = new UserEntity();
		UserEntity userEntity = userRepository.findByEmail(payload.getEmail());

		if (userEntity != null) {
			throw new BaseException(ErrorCode.USER_EMAIL_ALREADY_TAKEN.getErrorCode(),
					ErrorMessage.USER_EMAIL_ALREADY_TAKEN.getErrorMessage());
		}

		userEntity = userRepository.findByUsername(payload.getUsername());

		if (userEntity != null) {
			throw new BaseException(ErrorCode.USER_USERNAME_ALREADY_TAKEN.getErrorCode(),
					ErrorMessage.USER_USERNAME_ALREADY_TAKEN.getErrorMessage());
		}

		institutionEntity = institutionRepository.findByName(payload.getInstitutionName());

		if (institutionEntity == null) {
			throw new BaseException(ErrorCode.INSTITUTION_NOT_FOUND_WITH_NAME.getErrorCode(),
					ErrorMessage.INSTITUTION_NOT_FOUND_WITH_NAME.getErrorMessage());
		}

		otpCode = Utils.generateSixDigitNumber();
		organizerEmailEntity = organizerEmailRepository.findByEmail(payload.getEmail());

		BeanUtils.copyProperties(payload, newUserEntity);

		newUserEntity.setOtpCode(otpCode);
		newUserEntity.setInstitution(institutionEntity);
		newUserEntity.setEmailVerificationStatus(false);
		newUserEntity.setEncryptedPassword(bCryptPasswordEncoder.encode(payload.getPassword()));

		while (!isPublicIdValid) {
			String publicId = utils.generatePublicId(15);
			userEntity = userRepository.findByPublicId(publicId);
			if (userEntity == null) {
				isPublicIdValid = true;
				newUserEntity.setPublicId(publicId);
			}
		}

		if (organizerEmailEntity == null) {
			newUserEntity.setRole(roleRepository.findByName(Roles.ROLE_USER.name()));
		} else {
			newUserEntity.setRole(roleRepository.findByName(Roles.ROLE_ORGANIZER.name()));
		}

		try {
			new EmailService().sendOtpCodeViaEmail(payload.getEmail(), otpCode);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.REGISTRATION_EMAIL_NOT_SENT.getErrorCode(),
					ErrorMessage.REGISTRATION_EMAIL_NOT_SENT.getErrorMessage());
		}

		try {
			userRepository.save(newUserEntity);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.USER_NOT_SAVED.getErrorCode(),
					ErrorMessage.USER_NOT_SAVED.getErrorMessage());
		}
	}

	// Put
	// -----------------------------------------------------------------------------------------------------------------

	/**
	 * Updates the first and last name of the user identified by the given public id.
	 */
	@Override
	public void updateName(String publicId, UpdateNameRequest payload) {
		UserEntity userEntity = userRepository.findByPublicId(publicId);

		if (userEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		userEntity.setLastName(payload.getLastName());
		userEntity.setFirstName(payload.getFirstName());

		try {
			userRepository.save(userEntity);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.USER_NOT_SAVED.getErrorCode(),
					ErrorMessage.USER_NOT_SAVED.getErrorMessage());
		}
	}

	/**
	 * Updates the username of the user identified by the given public id.
	 */
	@Override
	public String updateUsername(String publicId, UpdateUsernameRequest payload) {
		String authorizationToken;
		UserEntity userEntity = userRepository.findByUsername(payload.getUsername());

		if (userEntity != null) {
			throw new BaseException(ErrorCode.USER_USERNAME_ALREADY_TAKEN.getErrorCode(),
					ErrorMessage.USER_USERNAME_ALREADY_TAKEN.getErrorMessage());
		}

		userEntity = userRepository.findByPublicId(publicId);

		if (userEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		userEntity.setUsername(payload.getUsername());

		try {
			userRepository.save(userEntity);

			authorizationToken = TOKEN_PREFIX + Jwts.builder()
					.setSubject(payload.getUsername())
					.setExpiration(new Date(System.currentTimeMillis() + SecurityConstants.EXPIRATION_TIME))
					.signWith(SignatureAlgorithm.HS512, SecurityConstants.getJwtSecretKey())
					.compact();
		} catch (Exception error) {
			throw new BaseException(ErrorCode.USER_NOT_SAVED.getErrorCode(),
					ErrorMessage.USER_NOT_SAVED.getErrorMessage());
		}

		return authorizationToken;
	}

	/**
	 * Updates the image path of the user identified by the given public id.
	 */
	@Override
	public void updateImagePath(String publicId, UpdateImagePathRequest payload) {
		UserEntity userEntity = userRepository.findByPublicId(publicId);

		if (userEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		userEntity.setImagePath(payload.getImagePath());

		try {
			userRepository.save(userEntity);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.USER_NOT_SAVED.getErrorCode(),
					ErrorMessage.USER_NOT_SAVED.getErrorMessage());
		}
	}

	/**
	 * Updates the institution of the user identified by the given public id.
	 */
	@Override
	public void updateInstitution(String publicId, UpdateInstitutionRequest payload) {
		InstitutionEntity institutionEntity = null;
		List<InstitutionEntity> institutionEntities;
		UserEntity user = userRepository.findByPublicId(publicId);

		if (user == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		institutionEntities = institutionRepository.findAllByName(payload.getInstitutionName());

		for (InstitutionEntity institutionEntityTemp : institutionEntities) {
			if (Objects.equals(institutionEntityTemp.getSettlement().getCounty().getName(), payload.getCountyName())) {
				institutionEntity = institutionEntityTemp;
			}
		}

		if (institutionEntity == null) {
			throw new BaseException(ErrorCode.INSTITUTION_NOT_FOUND_WITH_NAME.getErrorCode(),
					ErrorMessage.INSTITUTION_NOT_FOUND_WITH_NAME.getErrorMessage());
		}

		user.setInstitution(institutionEntity);

		try {
			userRepository.save(user);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.USER_NOT_SAVED.getErrorCode(),
					ErrorMessage.USER_NOT_SAVED.getErrorMessage());
		}
	}

	/**
	 * Authenticates the email by the code that was sent to the user via email.
	 */
	@Override
	public void verifyEmailByOtpCode(VerifyEmailByOtpCodeRequest payload) {
		UserEntity userEntity = userRepository.findByEmail(payload.getEmail());

		if (userEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_PUBLIC_ID.getErrorMessage());
		}

		if (userEntity.getOtpCode() != payload.getOtpCode()) {
			throw new BaseException(ErrorCode.USER_INVALID_OTP_CODE.getErrorCode(),
					ErrorMessage.USER_INVALID_OTP_CODE.getErrorMessage());
		}

		if (userEntity.getEmailVerificationStatus()) {
			throw new BaseException(ErrorCode.EMAIL_VERIFICATION_EMAIL_ALREADY_VERIFIED.getErrorCode(),
					ErrorMessage.EMAIL_VERIFICATION_EMAIL_ALREADY_VERIFIED.getErrorMessage());
		}

		userEntity.setOtpCode(null);
		userEntity.setEmailVerificationStatus(true);

		try {
			userRepository.save(userEntity);
		} catch (Exception error) {
			throw new BaseException(ErrorCode.USER_NOT_SAVED.getErrorCode(),
					ErrorMessage.USER_NOT_SAVED.getErrorMessage());
		}
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
	public String getUserByUsername(String username) {
		UserEntity userEntity = userRepository.findByUsername(username);

		if (userEntity == null) {
			throw new BaseException(ErrorCode.USER_NOT_FOUND_WITH_USERNAME.getErrorCode(),
					ErrorMessage.USER_NOT_FOUND_WITH_USERNAME.getErrorMessage());
		}

		return  userEntity.getPublicId();
	}
}
