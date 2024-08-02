package com.sapientia.open.days.backend.exceptions;

/**
 * Contains basic information about an error. Throw this every time if no additional information is needed. It returns
 * a BaseError object to the client.
 */
@SuppressWarnings("unused")
public class BaseException extends RuntimeException {
	private final int errorCode;

	private final String errorMessage;

	public BaseException(int errorCode, String errorMessage) {
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
