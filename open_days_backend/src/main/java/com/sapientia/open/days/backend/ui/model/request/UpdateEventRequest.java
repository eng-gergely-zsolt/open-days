package com.sapientia.open.days.backend.ui.model.request;

@SuppressWarnings("unused")
public class UpdateEventRequest {
	private String location;
	private String dateTime;
	private boolean isOnline;
	private String imagePath;
	private String description;
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

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}
}
