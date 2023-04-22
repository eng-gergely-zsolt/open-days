package com.sapientia.open.days.backend.ui.model.request.user;

@SuppressWarnings("unused")
public class ChangeUsernameReq {
	private String publicId;
	private String username;

	public String getPublicId() {
		return publicId;
	}

	public String getUsername() {
		return username;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public void setUsername(String username) {
		this.username = username;
	}
}
