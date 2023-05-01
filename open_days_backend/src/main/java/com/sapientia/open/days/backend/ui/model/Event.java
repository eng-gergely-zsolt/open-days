package com.sapientia.open.days.backend.ui.model;

@SuppressWarnings("unused")
public class Event {
	private long id;
	private boolean isOnline;
	private String location;
	private String dateTime;
	private String imageLink;
	private String description;
	private String meetingLink;
	private String organizerId;
	private String activityName;
	private String organizerLastName;
	private String organizerFirstName;

	public long getId() {
		return id;
	}

	public boolean isIsOnline() {
		return isOnline;
	}

	public String getLocation() {
		return location;
	}

	public String getDateTime() {
		return dateTime;
	}

	public String getImageLink() {
		return imageLink;
	}

	public String getDescription() {
		return description;
	}

	public String getMeetingLink() {
		return meetingLink;
	}

	public String getOrganizerId() {
		return organizerId;
	}

	public String getActivityName() {
		return activityName;
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

	public void setIsOnline(boolean isOnline) {
		this.isOnline = isOnline;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public void setDateTime(String dateTime) {
		this.dateTime = dateTime;
	}

	public void setImageLink(String imageLink) {
		this.imageLink = imageLink;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setMeetingLink(String meetingLink) {
		this.meetingLink = meetingLink;
	}

	public void setOrganizerId(String organizerId) {
		this.organizerId = organizerId;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

	public void setOrganizerLastName(String organizerLastName) {
		this.organizerLastName = organizerLastName;
	}

	public void setOrganizerFirstName(String organizerFirstName) {
		this.organizerFirstName = organizerFirstName;
	}
}
