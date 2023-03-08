package com.sapientia.open.days.backend.ui.model.resource;

public class InstitutionModel {
	private String settlement;
	private String institution;

	public InstitutionModel(String settlement, String institution) {
		this.settlement = settlement;
		this.institution = institution;
	}

	public String getSettlement() {
		return settlement;
	}

	public String getInstitution() {
		return institution;
	}

	public void setSettlement(String settlement) {
		this.settlement = settlement;
	}

	public void setInstitution(String institution) {
		this.institution = institution;
	}
}
