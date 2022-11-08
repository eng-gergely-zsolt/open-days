package com.sapientia.open.days.backend.ui.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;

@SuppressWarnings("unused")
public class CreateEventModel {

	private boolean isOnline;
	private String dateTime;
	private String location;
	private String meetingLink;
	private String organizerId;
	private String activityName;

	@JsonProperty("isOnline")
	public boolean getIsOnline() {
		return isOnline;
	}

	public String getDateTime() {
		return dateTime;
	}

	public String getLocation() {
		return location;
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

	public void setDateTime(String dateTime) {
		this.dateTime = dateTime;
	}

	public void setLocation(String location) {
		this.location = location;
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
