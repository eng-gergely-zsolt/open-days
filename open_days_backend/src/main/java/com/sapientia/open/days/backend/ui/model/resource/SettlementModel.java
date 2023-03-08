package com.sapientia.open.days.backend.ui.model.resource;

public class SettlementModel {
	private String county;
	private String settlement;

	public SettlementModel(String county, String settlement) {
		this.county = county;
		this.settlement = settlement;
	}

	public String getCounty() {
		return county;
	}

	public String getSettlement() {
		return settlement;
	}

	public void setCounty(String county) {
		this.county = county;
	}

	public void setSettlement(String settlement) {
		this.settlement = settlement;
	}
}
