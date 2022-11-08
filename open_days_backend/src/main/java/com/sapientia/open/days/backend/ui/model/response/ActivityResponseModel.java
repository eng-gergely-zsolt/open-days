package com.sapientia.open.days.backend.ui.model.response;

import java.io.Serial;

public class ActivityResponseModel {

	private int id;

	private String name;

	@Serial
	private static final long serialVersionUID = 6558070281872949903L;

	public int getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public void setId(int id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}
}
