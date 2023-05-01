package com.sapientia.open.days.backend.ui.model;

/**
 * A basic model to return an error to the client. The BaseException uses this as return type.
 */
@SuppressWarnings("unused")
public class BaseError {

	private int errorCode;
	private String errorMessage;

	public BaseError() {
	}

	public BaseError(int errorCode, String errorMessage) {
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
