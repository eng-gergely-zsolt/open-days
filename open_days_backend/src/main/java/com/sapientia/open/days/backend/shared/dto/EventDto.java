package com.sapientia.open.days.backend.shared.dto;

import org.joda.time.DateTime;

import java.io.Serial;
import java.io.Serializable;

@SuppressWarnings("unused")
public class EventDto implements Serializable {

	private boolean isOnline;
	private String dateTime;
	private String meetingLink;
	private String organizerId;
	private String activityName;

	@Serial
	private static final long serialVersionUID = 3667708176484458123L;

	public Boolean getOnline() {
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

	public void setOnline(Boolean online) {
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
