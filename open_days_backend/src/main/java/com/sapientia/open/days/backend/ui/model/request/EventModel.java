package com.sapientia.open.days.backend.ui.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;

@SuppressWarnings("unused")
public class EventModel {

	private boolean isOnline;

	private String dateTime;
	private String meetingLink;
	private String organizerId;
	private String activityName;

	@JsonProperty("isOnline")
	public boolean getOnline() {
		return isOnline;
	}

	public String getDateTime() {
		return dateTime;
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

	public void setOnline(boolean online) {
		isOnline = online;
	}

	public void setDateTime(String dateTime) {
		this.dateTime = dateTime;
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
