package com.sapientia.open.days.backend.ui.model.resource;


public enum ErrorCode {

	UNSPECIFIED_ERROR(1000),

	EMAIL_ALREADY_REGISTERED(1001),

	INSTITUTION_NOT_EXISTS(1002),
	MISSING_LAST_NAME(1003),
	MISSING_FIRST_NAME(1004),
	MISSING_EMAIL(1006),
	MISSING_PASSWORD(1007),
	MISSING_INSTITUTION(1008),
	MISSING_USERNAME(1005),
	INVALID_PUBLIC_ID(1006);

	private int errorCode;

	ErrorCode(int errorMessage) {
		this.errorCode = errorMessage;
	}

	public int getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}
}
