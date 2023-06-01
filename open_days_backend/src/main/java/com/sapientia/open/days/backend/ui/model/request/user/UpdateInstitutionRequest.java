package com.sapientia.open.days.backend.ui.model.request.user;

@SuppressWarnings("unused")
public class UpdateInstitutionRequest {
	private String countyName;
	private String institutionName;

	public UpdateInstitutionRequest() {}

	public UpdateInstitutionRequest(String countyName, String institutionName) {
		this.countyName = countyName;
		this.institutionName = institutionName;
	}

	public String getCountyName() {
		return countyName;
	}

	public String getInstitutionName() {
		return institutionName;
	}

	public void setCountyName(String countyName) {
		this.countyName = countyName;
	}

	public void setInstitutionName(String institutionName) {
		this.institutionName = institutionName;
	}
}
