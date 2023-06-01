package com.sapientia.open.days.backend.ui.model;

@SuppressWarnings("unused")
public class Event {
	private long id;
	private boolean isOnline;
	private String location;
	private String dateTime;
	private String imagePath;
	private String description;
	private String meetingLink;
	private String activityName;
	private String organizerPublicId;
	private String organizerLastName;
	private String organizerFirstName;

	public Event () {}

	public Event(boolean isOnline, String location, String dateTime, String imagePath, String description,
	             String meetingLink, String activityName, String organizerPublicId, String organizerLastName,
	             String organizerFirstName) {
		this.isOnline = isOnline;
		this.location = location;
		this.dateTime = dateTime;
		this.imagePath = imagePath;
		this.description = description;
		this.meetingLink = meetingLink;
		this.activityName = activityName;
		this.organizerPublicId = organizerPublicId;
		this.organizerLastName = organizerLastName;
		this.organizerFirstName = organizerFirstName;
	}

	public long getId() {
		return id;
	}

	public boolean isOnline() {
		return isOnline;
	}

	public String getLocation() {
		return location;
	}

	public String getDateTime() {
		return dateTime;
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

	public String getActivityName() {
		return activityName;
	}

	public String getOrganizerPublicId() {
		return organizerPublicId;
	}

	public String getOrganizerLastName() {
		return organizerLastName;
	}

	public String getOrganizerFirstName() {
		return organizerFirstName;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setOnline(boolean isOnline) {
		this.isOnline = isOnline;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public void setDateTime(String dateTime) {
		this.dateTime = dateTime;
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

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

	public void setOrganizerPublicId(String organizerPublicId) {
		this.organizerPublicId = organizerPublicId;
	}

	public void setOrganizerLastName(String organizerLastName) {
		this.organizerLastName = organizerLastName;
	}

	public void setOrganizerFirstName(String organizerFirstName) {
		this.organizerFirstName = organizerFirstName;
	}
}
