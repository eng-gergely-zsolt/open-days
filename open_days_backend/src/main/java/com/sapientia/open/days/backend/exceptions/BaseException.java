package com.sapientia.open.days.backend.exceptions;

import java.io.Serial;

@SuppressWarnings("unused")
public class BaseException extends RuntimeException {

	private final int errorCode;
	private final String errorMessage;

	@Serial
	private static final long serialVersionUID = 6499350249119037680L;

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
