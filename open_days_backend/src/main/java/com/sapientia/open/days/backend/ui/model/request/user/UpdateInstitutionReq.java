package com.sapientia.open.days.backend.ui.model.request.user;

@SuppressWarnings("unused")
public class UpdateInstitutionReq {
	private String county;
	private String publicId;
	private String institution;

	public String getCounty() {
		return county;
	}

	public String getPublicId() {
		return publicId;
	}

	public String getInstitution() {
		return institution;
	}

	public void setCounty(String county) {
		this.county = county;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public void setInstitution(String institution) {
		this.institution = institution;
	}
}
