package com.sapientia.open.days.backend.exceptions;

import java.io.Serial;

@SuppressWarnings("unused")
public class UserServiceException extends RuntimeException {

	private final Integer errorCode;

	@Serial
	private static final long serialVersionUID = 4460366926602512635L;

	public UserServiceException(int errorCode, String message) {
		super(message);
		this.errorCode = errorCode;
	}

	public int getErrorCode() {
		return errorCode;
	}
}
