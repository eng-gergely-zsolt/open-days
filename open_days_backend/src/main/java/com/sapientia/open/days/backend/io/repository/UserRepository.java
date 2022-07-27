package com.sapientia.open.days.backend.io.repository;

import com.sapientia.open.days.backend.io.entity.UserEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends CrudRepository<UserEntity, Long> {
    // The names here are strictly generated. findBy+column name.
    UserEntity findByEmail(String email);

    UserEntity findByObjectId(String objectId);
}
