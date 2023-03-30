package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;

@SuppressWarnings("unused")
@Entity(name = "password_reset_tokens")
public class PasswordResetTokenEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	private String token;

	@OneToOne()
	@JoinColumn(name = "users_id")
	private UserEntity userDetails;

	private static final long serialVersionUID = 1872855450348605762L;

	public long getId() {
		return id;
	}

	public String getToken() {
		return token;
	}

	public UserEntity getUserDetails() {
		return userDetails;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public void setUserDetails(UserEntity userDetails) {
		this.userDetails = userDetails;
	}
}
