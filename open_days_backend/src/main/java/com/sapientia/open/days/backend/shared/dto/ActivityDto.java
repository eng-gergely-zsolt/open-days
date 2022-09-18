package com.sapientia.open.days.backend.shared.dto;

import java.io.Serial;
import java.io.Serializable;

@SuppressWarnings("unused")
public class ActivityDto implements Serializable {

	private String name;
	private String location;

	@Serial
	private static final long serialVersionUID = 2606074144175745196L;

	public String getName() {
		return name;
	}

	public String getLocation() {
		return location;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setLocation(String location) {
		this.location = location;
	}
}
