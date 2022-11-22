package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serial;
import java.io.Serializable;
import java.util.Set;

@Entity(name = "users")
@SuppressWarnings("unused")
public class UserEntity implements Serializable {

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

	@Column(nullable = true)
	private String emailVerificationToken;

	@Column(nullable = false)
	private Boolean emailVerificationStatus = false;

	@Serial
	private static final long serialVersionUID = 232383759086741088L;

	@ManyToMany(mappedBy = "users")
	private Set<EventEntity> userEvents;

	@OneToMany(mappedBy = "organizer")
	private Set<EventEntity> events;

	@ManyToOne
	@JoinColumn(name = "institution_id", nullable = false)
	private InstitutionEntity institution;

	// This creates a new table in cases of ManyToManyRelationships.
	@ManyToMany(cascade = {CascadeType.PERSIST}, fetch = FetchType.EAGER)
	@JoinTable(name = "users_roles",
			joinColumns = @JoinColumn(name = "users_id", referencedColumnName = "id"),
			inverseJoinColumns = @JoinColumn(name = "roles_id", referencedColumnName = "id"))
	private Set<RoleEntity> roles;

	public String getEmailVerificationToken() {
		return emailVerificationToken;
	}

	public long getId() {
		return id;
	}

	public String getEmail() {
		return email;
	}

	public String getPublicId() {
		return publicId;
	}

	public String getUsername() {
		return username;
	}

	public String getLastName() {
		return lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	public String getEncryptedPassword() {
		return encryptedPassword;
	}

	public Boolean getEmailVerificationStatus() {
		return emailVerificationStatus;
	}

	public InstitutionEntity getInstitution() {
		return institution;
	}

	public Set<RoleEntity> getRoles() {
		return roles;
	}

	public void setEmailVerificationToken(String emailVerificationToken) {
		this.emailVerificationToken = emailVerificationToken;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setEncryptedPassword(String encryptedPassword) {
		this.encryptedPassword = encryptedPassword;
	}

	public void setEmailVerificationStatus(Boolean emailVerificationStatus) {
		this.emailVerificationStatus = emailVerificationStatus;
	}

	public void setInstitution(InstitutionEntity institution) {
		this.institution = institution;
	}

	public void setRoles(Set<RoleEntity> roles) {
		this.roles = roles;
	}
}
