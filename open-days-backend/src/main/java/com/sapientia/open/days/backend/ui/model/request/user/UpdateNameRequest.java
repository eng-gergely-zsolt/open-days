package com.sapientia.open.days.backend.ui.model.request.user;

@SuppressWarnings("unused")
public class UpdateNameRequest {
	private String lastName;
	private String firstName;

	public UpdateNameRequest() {}

	public UpdateNameRequest(String lastName, String firstName) {
		this.lastName = lastName;
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
}
