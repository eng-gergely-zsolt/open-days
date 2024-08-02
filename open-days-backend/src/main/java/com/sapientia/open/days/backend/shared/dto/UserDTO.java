package com.sapientia.open.days.backend.shared.dto;

import java.io.Serializable;

@SuppressWarnings("unused")
public class UserDTO implements Serializable {

	private long id;
	private String role;
	private String email;
	private String publicId;
	private String password;
	private String username;
	private String lastName;
	private String roleName;
	private String firstName;
	private String institution;
	private String encryptedPassword;
	private String emailVerificationToken;
	private Boolean emailVerificationStatus = false;

	public long getId() {
		return id;
	}

	public String getRole() {
		return role;
	}

	public String getEmail() {
		return email;
	}

	public String getPublicId() {
		return publicId;
	}

	public String getPassword() {
		return password;
	}

	public String getUsername() {
		return username;
	}

	public String getLastName() {
		return lastName;
	}

	public String getRoleName() {
		return roleName;
	}

	public String getFirstName() {
		return firstName;
	}

	public String getInstitution() {
		return institution;
	}

	public String getEncryptedPassword() {
		return encryptedPassword;
	}

	public String getEmailVerificationToken() {
		return emailVerificationToken;
	}

	public Boolean getEmailVerificationStatus() {
		return emailVerificationStatus;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setInstitution(String institution) {
		this.institution = institution;
	}

	public void setEncryptedPassword(String encryptedPassword) {
		this.encryptedPassword = encryptedPassword;
	}

	public void setEmailVerificationToken(String emailVerificationToken) {
		this.emailVerificationToken = emailVerificationToken;
	}

	public void setEmailVerificationStatus(Boolean emailVerificationStatus) {
		this.emailVerificationStatus = emailVerificationStatus;
	}
}
