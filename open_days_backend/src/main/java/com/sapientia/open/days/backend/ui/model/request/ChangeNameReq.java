package com.sapientia.open.days.backend.ui.model.request;

@SuppressWarnings("unused")
public class ChangeNameReq {
	private String publicId;
	private String lastName;
	private String firstName;

	public String getPublicId() {
		return publicId;
	}

	public String getLastName() {
		return lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
}
