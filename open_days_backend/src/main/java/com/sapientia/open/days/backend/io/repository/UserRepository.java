package com.sapientia.open.days.backend.io.repository;

import com.sapientia.open.days.backend.io.entity.UserEntity;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends PagingAndSortingRepository<UserEntity, Long> {

	UserEntity findByEmail(String email);

	UserEntity findByUsername(String username);

	UserEntity findByPublicId(String publicId);

	UserEntity findUserByEmailVerificationToken(String emailVerificationToken);
}
