package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Set;

@Entity(name = "users")
@SuppressWarnings("unused")
public class UserEntity implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(length = 15, unique = true, nullable = false)
	private String publicId;

	@Column(length = 100, unique = true, nullable = false)
	private String email;

	@Column(length = 50, unique = true, nullable = false)
	private String username;

	@Column(length = 50, nullable = false)
	private String lastName;

	@Column(length = 50, nullable = false)
	private String firstName;

	@Column
	private Integer otpCode;

	@Column
	private String imagePath;

	@Column(nullable = false)
	private String encryptedPassword;

	@Column(nullable = false)
	private Boolean emailVerificationStatus = false;

	// Contains all the events that the user organized.
	@OneToMany(mappedBy = "organizer")
	private Set<EventEntity> events;

	// It's the role that the use has.
	@ManyToOne
	@JoinColumn(name = "role_id", nullable = false)
	private RoleEntity role;

	// It's the institution the user belongs to.
	@ManyToOne
	@JoinColumn(name = "institution_id", nullable = false)
	private InstitutionEntity institution;

	// Contains all the events thad the user enrolled in.
	@ManyToMany(mappedBy = "enrolledUsers")
	private Set<EventEntity> enrolledEvents;

	// Contains all the events that the user participated in.
	@ManyToMany(mappedBy = "participatedUsers")
	private Set<EventEntity> participatedEvents;

	public long getId() {
		return id;
	}

	public String getEmail() {
		return email;
	}

	public Integer getOtpCode() {
		return otpCode;
	}

	public RoleEntity getRole() {
		return role;
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

	public String getImagePath() {
		return imagePath;
	}

	public InstitutionEntity getInstitution() {
		return institution;
	}

	public String getEncryptedPassword() {
		return encryptedPassword;
	}

	public Boolean getEmailVerificationStatus() {
		return emailVerificationStatus;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setRole(RoleEntity role) {
		this.role = role;
	}

	public void setOtpCode(Integer otpCode) {
		this.otpCode = otpCode;
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

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public void setInstitution(InstitutionEntity institution) {
		this.institution = institution;
	}

	public void setEncryptedPassword(String encryptedPassword) {
		this.encryptedPassword = encryptedPassword;
	}

	public void setEmailVerificationStatus(Boolean emailVerificationStatus) {
		this.emailVerificationStatus = emailVerificationStatus;
	}
}
