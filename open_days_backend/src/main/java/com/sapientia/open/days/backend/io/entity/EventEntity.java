package com.sapientia.open.days.backend.io.entity;

import org.joda.time.DateTime;

import javax.persistence.*;
import java.io.Serial;
import java.util.Set;

@Entity
@Table(name = "events")
@SuppressWarnings("unused")
public class EventEntity {

	@Id
	@GeneratedValue
	private long id;

	@Column(nullable = false)
	Boolean isOnline;

	@Column(nullable = false)
	DateTime dateTime;

	@ManyToOne
	@JoinColumn(name = "organizer_id", nullable = false)
	private UserEntity organizer;

	@ManyToOne
	@JoinColumn(name = "activity_id", nullable = false)
	private ActivityEntity activity;

	@ManyToMany(cascade = {CascadeType.PERSIST}, fetch = FetchType.EAGER)
	@JoinTable(name = "users_events",
			joinColumns = @JoinColumn(name = "event_id", referencedColumnName = "id"),
			inverseJoinColumns = @JoinColumn(name = "user_id", referencedColumnName = "id"))
	private Set<UserEntity> events;

	@Serial
	private static final long serialVersionUID = 4254624445277314819L;
}
