package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "events")
@SuppressWarnings("unused")
public class EventEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(nullable = false, length = 50)
	private String location;

	@Column(nullable = false)
	private String dateTime;

	@Column(nullable = false)
	private boolean isOnline;

	@Column
	private String imagePath;

	@Column(nullable = false)
	private String description;

	@Column
	private String meetingLink;

	// It's the user that organises/organised the event.
	@ManyToOne
	@JoinColumn(name = "organizer_id", nullable = false)
	private UserEntity organizer;

	// It's the activity the event belongs to.
	@ManyToOne
	@JoinColumn(name = "activity_id", nullable = false)
	private ActivityEntity activity;

	// Contains all the users that were enrolled in this event.
	@ManyToMany(cascade = {CascadeType.PERSIST}, fetch = FetchType.EAGER)
	@JoinTable(name = "enrolled_users", joinColumns = @JoinColumn(name = "event_id", referencedColumnName = "id"),
			inverseJoinColumns = @JoinColumn(name = "user_id", referencedColumnName = "id"))
	private Set<UserEntity> enrolledUsers;

	// Contains all the users that have participated in this event.
	@ManyToMany(cascade = {CascadeType.PERSIST}, fetch = FetchType.EAGER)
	@JoinTable(name = "participated_users", joinColumns = @JoinColumn(name = "event_id", referencedColumnName = "id"),
			inverseJoinColumns = @JoinColumn(name = "user_id", referencedColumnName = "id"))
	private Set<UserEntity> participatedUsers;

	public long getId() {
		return id;
	}

	public String getLocation() {
		return location;
	}

	public String getDateTime() {
		return dateTime;
	}

	public boolean getIsOnline() {
		return isOnline;
	}

	public String getImagePath() {
		return imagePath;
	}

	public String getDescription() {
		return description;
	}

	public String getMeetingLink() {
		return meetingLink;
	}

	public UserEntity getOrganizer() {
		return organizer;
	}

	public ActivityEntity getActivity() {
		return activity;
	}

	public Set<UserEntity> getEnrolledUsers() {
		return enrolledUsers;
	}

	public Set<UserEntity> getParticipatedUsers() {
		return participatedUsers;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public void setDateTime(String dateTime) {
		this.dateTime = dateTime;
	}

	public void setIsOnline(boolean isOnline) {
		this.isOnline = isOnline;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setMeetingLink(String meetingLink) {
		this.meetingLink = meetingLink;
	}

	public void setOrganizer(UserEntity organizer) {
		this.organizer = organizer;
	}

	public void setActivity(ActivityEntity activity) {
		this.activity = activity;
	}

	public void setEnrolledUsers(Set<UserEntity> enrolledUsers) {
		this.enrolledUsers = enrolledUsers;
	}

	public void setParticipatedUsers(Set<UserEntity> participatedUsers) {
		this.participatedUsers = participatedUsers;
	}
}
