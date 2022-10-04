package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serial;
import java.util.Set;

@Entity
@SuppressWarnings("unused")
@Table(name = "activities")
public class ActivityEntity {

	@Id
	@GeneratedValue
	private long id;

	@Column(nullable = false, length = 50)
	private String name;

	@Column(nullable = false, length = 50)
	private String location;

	@OneToMany(mappedBy = "activity")
	private Set<EventEntity> events;

	@Serial
	private static final long serialVersionUID = 6204558143681775472L;

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public String getLocation() {
		return location;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setLocation(String location) {
		this.location = location;
	}
}
