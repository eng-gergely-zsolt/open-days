package com.sapientia.open.days.backend.ui.model.response;

@SuppressWarnings("unused")
public class InstitutionNameResponse {
	private String countyName;
	private String institutionName;

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
