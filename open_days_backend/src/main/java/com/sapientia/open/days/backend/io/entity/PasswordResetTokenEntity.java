package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serial;

@Entity(name = "password_reset_tokens")
public class PasswordResetTokenEntity {
    @Serial
    private static final long serialVersionUID = 1872855450348605762L;

    @Id
    @GeneratedValue
    private long id;

    private String token;

    @OneToOne()
    @JoinColumn(name = "users_id")
    private UserEntity userDetails;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public UserEntity getUserDetails() {
        return userDetails;
    }

    public void setUserDetails(UserEntity userDetails) {
        this.userDetails = userDetails;
    }
}
