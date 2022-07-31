package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.exceptions.UserServiceException;
import com.sapientia.open.days.backend.io.entity.UserEntity;
import com.sapientia.open.days.backend.io.repository.UserRepository;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.Utils;
import com.sapientia.open.days.backend.shared.dto.UserDto;
import com.sapientia.open.days.backend.ui.model.response.ErrorMessages;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    Utils utils;
    @Autowired
    UserRepository userRepository;

    @Autowired
    BCryptPasswordEncoder bCryptPasswordEncoder;

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
    public UserDto createUser(UserDto user) {
        UserEntity userEntity = new UserEntity();
        BeanUtils.copyProperties(user, userEntity);

        String objectId = utils.generateObjectId(15);

        userEntity.setObjectId(objectId);
        userEntity.setEncryptedPassword(bCryptPasswordEncoder.encode(user.getPassword()));

        UserEntity storedUserDetails = userRepository.save(userEntity);

        UserDto result = new UserDto();
        BeanUtils.copyProperties(storedUserDetails, result);

        return result;
    }

    @Override
    public UserDto updateUser(UserDto user, String objectId) {
        UserDto result = new UserDto();
        UserEntity userEntity = userRepository.findByObjectId(objectId);

        if (userEntity == null) throw new UserServiceException(ErrorMessages.NO_RECORD_FOUND.getErrorMessage());

        userEntity.setFirstName(user.getFirstName());
        userEntity.setLastName(user.getLastName());

        UserEntity updatedUserDetails = userRepository.save(userEntity);

        BeanUtils.copyProperties(updatedUserDetails, result);

        return result;
    }

    @Override
    public void deleteUser(String objectId) {
        UserEntity userEntity = userRepository.findByObjectId(objectId);

        if (userEntity == null) throw new UserServiceException(ErrorMessages.NO_RECORD_FOUND.getErrorMessage());

        userRepository.delete(userEntity);
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        UserEntity userEntity = userRepository.findByEmail(email);

        if (userEntity == null) throw new UsernameNotFoundException(email);

        return new User(userEntity.getEmail(), userEntity.getEncryptedPassword(), new ArrayList<>());
    }
}
