package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serial;
import java.util.Set;

@Entity
@SuppressWarnings("unused")
@Table(name = "activities")
public class ActivityEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(nullable = false, length = 50)
	private String name;

	@OneToMany(mappedBy = "activity")
	private Set<EventEntity> events;

	public ActivityEntity() {}

	public ActivityEntity(String name) {
		this.name = name;
	}

	@Serial
	private static final long serialVersionUID = 6204558143681775472L;

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}
}
