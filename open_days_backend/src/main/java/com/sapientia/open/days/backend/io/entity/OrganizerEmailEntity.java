package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serial;
import java.io.Serializable;

@Entity
@SuppressWarnings("unused")
@Table(name = "organizer_emails")
public class OrganizerEmailEntity implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(length = 100, unique = true, nullable = false)
	private String email;

	@Serial
	private static final long serialVersionUID = 1065801915520221340L;

	public OrganizerEmailEntity() {

	}

	public OrganizerEmailEntity(String email) {
		this.email = email;
	}

	public long getId() {
		return id;
	}

	public String getEmail() {
		return email;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setEmail(String email) {
		this.email = email;
	}
}
