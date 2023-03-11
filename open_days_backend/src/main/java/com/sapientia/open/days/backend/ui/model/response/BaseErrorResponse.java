package com.sapientia.open.days.backend.ui.model.response;

@SuppressWarnings("unused")
public class BaseErrorResponse {

	private int errorCode;
	private String errorMessage;

	public BaseErrorResponse() {
	}

	public BaseErrorResponse(int errorCode, String errorMessage) {
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}

	public int getErrorCode() {
		return errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public boolean getIsOperationSuccessful() {
		return false;
	}

	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
}
