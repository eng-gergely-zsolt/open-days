package com.sapientia.open.days.backend.ui.model.request;

public class UpdateEventRequestModel {
	private String location;
	private String dateTime;
	private boolean isOnline;
	private String meetingLink;
	private String activityName;

	public String getLocation() {
		return location;
	}

	public String getDateTime() {
		return dateTime;
	}

	public boolean getIsOnline() {
		return isOnline;
	}

	public String getMeetingLink() {
		return meetingLink;
	}

	public String getActivityName() {
		return activityName;
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

	public void setMeetingLink(String meetingLink) {
		this.meetingLink = meetingLink;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}
}
