package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.exceptions.UserServiceException;
import com.sapientia.open.days.backend.io.entity.PasswordResetTokenEntity;
import com.sapientia.open.days.backend.io.entity.RoleEntity;
import com.sapientia.open.days.backend.io.entity.UserEntity;
import com.sapientia.open.days.backend.io.repository.PasswordResetTokenRepository;
import com.sapientia.open.days.backend.io.repository.RoleRepository;
import com.sapientia.open.days.backend.io.repository.UserRepository;
import com.sapientia.open.days.backend.security.UserPrincipal;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.EmailVerificationService;
import com.sapientia.open.days.backend.shared.Utils;
import com.sapientia.open.days.backend.shared.dto.UserDto;
import com.sapientia.open.days.backend.ui.model.resource.ErrorMessage;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    Utils utils;
    @Autowired
    UserRepository userRepository;

    @Autowired
    PasswordResetTokenRepository passwordResetTokenRepository;

    @Autowired
    BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    RoleRepository roleRepository;

    @Override
    public UserDto getUser(String email) {
        UserEntity userEntity = userRepository.findByEmail(email);

        if (userEntity == null) throw new UsernameNotFoundException(email);

        UserDto returnValue = new UserDto();
        BeanUtils.copyProperties(userEntity, returnValue);
        return returnValue;
    }

    @Override
    public UserDto getUserByObjectId(String objectId) {
        UserDto result = new UserDto();
        UserEntity userEntity = userRepository.findByObjectId(objectId);

        if (userEntity == null) throw new UsernameNotFoundException("User with ID: " + objectId + "not found");

        BeanUtils.copyProperties(userEntity, result);

        return result;
    }

    @Override
    public List<UserDto> getUsers(int pageNumber, int recordPerPage) {
        List<UserDto> result = new ArrayList<>();

        if (pageNumber < 0) pageNumber = 1;
        if (pageNumber > 0) pageNumber -= 1;

        Pageable pageableRequest = PageRequest.of(pageNumber, recordPerPage);

        Page<UserEntity> userPage = userRepository.findAll(pageableRequest);
        List<UserEntity> users = userPage.getContent();

        for (UserEntity user : users) {
            UserDto userDto = new UserDto();
            BeanUtils.copyProperties(user, userDto);
            result.add(userDto);
        }

        return result;
    }

    @Override
    public UserDto createUser(UserDto user) {

        if (userRepository.findByEmail(user.getEmail()) != null) {
            throw new RuntimeException("This email already used");
        }

        UserEntity userEntity = new UserEntity();
        BeanUtils.copyProperties(user, userEntity);

        String objectId = utils.generateObjectId(15);

        userEntity.setObjectId(objectId);
        userEntity.setEncryptedPassword(bCryptPasswordEncoder.encode(user.getPassword()));
        userEntity.setEmailVerificationToken(utils.generateEmailVerificationToken(objectId));
        userEntity.setEmailVerificationStatus(false);

        Collection<RoleEntity> roleEntities = new HashSet<>();
        for (String role: user.getRoles()) {
            RoleEntity roleEntity = roleRepository.findByName(role);
            if (roleEntity != null) {
                roleEntities.add(roleEntity);
            }
        }

        userEntity.setRoles(roleEntities);

        UserEntity storedUserDetails = userRepository.save(userEntity);

        UserDto result = new UserDto();
        BeanUtils.copyProperties(storedUserDetails, result);

        // Send an email message to user to verify their email address
        new EmailVerificationService().verifyEmail(result);

        return result;
    }

    @Override
    public UserDto updateUser(UserDto user, String objectId) {
        UserDto result = new UserDto();
        UserEntity userEntity = userRepository.findByObjectId(objectId);

        if (userEntity == null) throw new UserServiceException(ErrorMessage.NO_RECORD_FOUND.getErrorMessage());

        userEntity.setFirstName(user.getFirstName());
        userEntity.setLastName(user.getLastName());

        UserEntity updatedUserDetails = userRepository.save(userEntity);

        BeanUtils.copyProperties(updatedUserDetails, result);

        return result;
    }

    @Override
    public void deleteUser(String objectId) {
        UserEntity userEntity = userRepository.findByObjectId(objectId);

        if (userEntity == null) throw new UserServiceException(ErrorMessage.NO_RECORD_FOUND.getErrorMessage());

        userRepository.delete(userEntity);
    }

    // Verifies the token if it's expired ot not.
    @Override
    public boolean verifyEmailVerificationToken(String emailVerificationToken) {
        boolean result = false;

        // Find user by token
        UserEntity userEntity = userRepository.findUserByEmailVerificationToken(emailVerificationToken);

        if (userEntity != null) {
            boolean hasTokenExpired = Utils.hasTokenExpired(emailVerificationToken);
            if (!hasTokenExpired) {
                userEntity.setEmailVerificationToken(null);
                userEntity.setEmailVerificationStatus(Boolean.TRUE);
                userRepository.save(userEntity);
                result = true;
            }
        }

        return result;
    }

    @Override
    public boolean requestPasswordReset(String emailAddress) {
        boolean returnValue = false;

        UserEntity userEntity = userRepository.findByEmail(emailAddress);

        if (userEntity == null) {
            return returnValue;
        }

        String token = new Utils().generatePasswordResetToken(userEntity.getObjectId());

        PasswordResetTokenEntity passwordResetTokenEntity = new PasswordResetTokenEntity();
        passwordResetTokenEntity.setToken(token);
        passwordResetTokenEntity.setUserDetails(userEntity);
        passwordResetTokenRepository.save(passwordResetTokenEntity);

        returnValue = new EmailVerificationService().sendPasswordResetRequest(
                userEntity.getFirstName(),
                userEntity.getEmail(),
                token);

        return returnValue;
    }

    @Override
    public boolean resetPassword(String token, String password) {
        boolean returnValue = false;

        if (Utils.hasTokenExpired(token)) {
            return returnValue;
        }

        PasswordResetTokenEntity passwordResetTokenEntity = passwordResetTokenRepository.findByToken(token);

        if (passwordResetTokenEntity == null) {
            return returnValue;
        }

        // Prepare new password
        String encodedPassword = bCryptPasswordEncoder.encode(password);

        // Update User password in database
        UserEntity userEntity = passwordResetTokenEntity.getUserDetails();
        userEntity.setEncryptedPassword(encodedPassword);
        UserEntity savedUserEntity = userRepository.save(userEntity);

        // Verify if password was saved successfully
        if (savedUserEntity != null && savedUserEntity.getEncryptedPassword().equalsIgnoreCase(encodedPassword)) {
            returnValue = true;
        }

        // Remove Password Reset token from database;
        passwordResetTokenRepository.delete(passwordResetTokenEntity);

        return returnValue;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        UserEntity userEntity = userRepository.findByEmail(email);

        if (userEntity == null)
            throw new UsernameNotFoundException(email);

        return new UserPrincipal(userEntity);
    }
}
