package com.sapientia.open.days.backend.exceptions;

@SuppressWarnings("unused")
public class GeneralServiceException extends RuntimeException {
	private final Integer errorCode;
	private final String errorMessage;

	public GeneralServiceException(int errorCode, String errorMessage) {
		super(errorMessage);
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}

	public int getErrorCode() {
		return errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}
}
