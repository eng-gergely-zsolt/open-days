package com.sapientia.open.days.backend.shared.dto;

import java.io.Serial;

@SuppressWarnings("unused")
public class CreateEventDto {
	private boolean isOnline;
	private String location;
	private String dateTime;
	private String imageLink;
	private String meetingLink;
	private String organizerId;
	private String activityName;

	@Serial
	private static final long serialVersionUID = 3667708176484458123L;

	public boolean getIsOnline() {
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

	public String getMeetingLink() {
		return meetingLink;
	}

	public String getOrganizerId() {
		return organizerId;
	}

	public String getActivityName() {
		return activityName;
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

	public void setMeetingLink(String meetingLink) {
		this.meetingLink = meetingLink;
	}

	public void setOrganizerId(String organizerId) {
		this.organizerId = organizerId;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}
}
