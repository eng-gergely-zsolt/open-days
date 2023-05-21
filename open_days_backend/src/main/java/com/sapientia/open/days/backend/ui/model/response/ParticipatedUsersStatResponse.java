package com.sapientia.open.days.backend.ui.model.response;

@SuppressWarnings("unused")
public class ParticipatedUsersStatResponse {
	String activityName;
	int participatedUsersNr;

	public String getActivityName() {
		return activityName;
	}

	public int getParticipatedUsersNr() {
		return participatedUsersNr;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

	public void setParticipatedUsersNr(int participatedUsersNr) {
		this.participatedUsersNr = participatedUsersNr;
	}
}
