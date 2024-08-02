package com.sapientia.open.days.backend.ui.model;

@SuppressWarnings("unused")
public class ErrorMessage {
	private int errorCode;
	private String errorMessage;

	public ErrorMessage() {
	}

	public ErrorMessage(int errorCode, String errorMessage) {
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}

	public int getErrorCode() {
		return errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
}
