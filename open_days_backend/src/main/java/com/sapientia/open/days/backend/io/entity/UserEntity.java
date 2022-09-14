package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serial;
import java.io.Serializable;
import java.util.Collection;

@Entity(name = "users")
@SuppressWarnings("unused")
public class UserEntity implements Serializable {

	private String emailVerificationToken;

	@Id
	@GeneratedValue
	private long id;

	@Column(length = 100, unique = true, nullable = false)
	private String email;

	@Column(length = 15, unique = true, nullable = false)
	private String publicId;

	@Column(length = 50, unique = true, nullable = false)
	private String username;

	@Column(length = 50, nullable = false)
	private String lastName;

	@Column(length = 50, nullable = false)
	private String firstName;

	@Column(nullable = false)
	private String encryptedPassword;

	@Column(nullable = false)
	private Boolean emailVerificationStatus = false;

	@Serial
	private static final long serialVersionUID = 232383759086741088L;

	@ManyToOne
	@JoinColumn(name = "institution_id", nullable = false)
	private InstitutionEntity institution;

	// This creates a new table in cases of ManyToManyRelationships.
	@ManyToMany(cascade = {CascadeType.PERSIST}, fetch = FetchType.EAGER)
	@JoinTable(name = "users_roles",
			joinColumns = @JoinColumn(name = "users_id", referencedColumnName = "id"),
			inverseJoinColumns = @JoinColumn(name = "roles_id", referencedColumnName = "id"))
	private Collection<RoleEntity> roles;

	public String getEmailVerificationToken() {
		return emailVerificationToken;
	}

	public void setEmailVerificationToken(String emailVerificationToken) {
		this.emailVerificationToken = emailVerificationToken;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPublicId() {
		return publicId;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getEncryptedPassword() {
		return encryptedPassword;
	}

	public void setEncryptedPassword(String encryptedPassword) {
		this.encryptedPassword = encryptedPassword;
	}

	public Boolean getEmailVerificationStatus() {
		return emailVerificationStatus;
	}

	public void setEmailVerificationStatus(Boolean emailVerificationStatus) {
		this.emailVerificationStatus = emailVerificationStatus;
	}

	public InstitutionEntity getInstitution() {
		return institution;
	}

	public void setInstitution(InstitutionEntity institution) {
		this.institution = institution;
	}

	public Collection<RoleEntity> getRoles() {
		return roles;
	}

	public void setRoles(Collection<RoleEntity> roles) {
		this.roles = roles;
	}
}
