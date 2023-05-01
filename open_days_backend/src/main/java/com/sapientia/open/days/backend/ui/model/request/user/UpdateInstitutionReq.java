package com.sapientia.open.days.backend.ui.model.request.user;

@SuppressWarnings("unused")
public class UpdateInstitutionReq {
	private String publicId;
	private String countyName;
	private String institutionName;

	public String getPublicId() {
		return publicId;
	}

	public String getCountyName() {
		return countyName;
	}

	public String getInstitutionName() {
		return institutionName;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public void setCountyName(String countyName) {
		this.countyName = countyName;
	}

	public void setInstitutionName(String institutionName) {
		this.institutionName = institutionName;
	}
}
