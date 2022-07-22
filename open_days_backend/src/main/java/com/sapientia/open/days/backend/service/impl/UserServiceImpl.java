package com.sapientia.open.days.backend.service.impl;

import com.sapientia.open.days.backend.UserRepository;
import com.sapientia.open.days.backend.io.entity.UserEntity;
import com.sapientia.open.days.backend.service.UserService;
import com.sapientia.open.days.backend.shared.dto.UserDto;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    UserRepository userRepository;

    @Override
    public UserDto createUser(UserDto user) {
        UserEntity userEntity = new UserEntity();
        BeanUtils.copyProperties(user, userEntity);

        userEntity.setEncryptedPassword("test");
        userEntity.setObjectId("testUserId");

        UserEntity storedUserDetails =  userRepository.save(userEntity);

        UserDto returnValue = new UserDto();
        BeanUtils.copyProperties(storedUserDetails, returnValue);

        return returnValue;
    }
}
