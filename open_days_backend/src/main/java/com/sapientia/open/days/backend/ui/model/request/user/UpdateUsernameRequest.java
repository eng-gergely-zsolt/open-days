package com.sapientia.open.days.backend.ui.model.request.user;

@SuppressWarnings("unused")
public class UpdateUsernameRequest {
	private String username;

	public UpdateUsernameRequest() {}

	public UpdateUsernameRequest(String username) {
		this.username = username;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
}
