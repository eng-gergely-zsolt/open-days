package com.sapientia.open.days.backend.exceptions;

import com.sapientia.open.days.backend.ui.model.resource.OperationStatus;

import java.io.Serial;

@SuppressWarnings("unused")
public class GeneralServiceException extends RuntimeException {

	private final Integer code;
	private final String operationResult = OperationStatus.ERROR.name();

	@Serial
	private static final long serialVersionUID = 4460366926602512635L;

	public GeneralServiceException(int code, String message) {
		super(message);
		this.code = code;
	}

	public int getCode() {
		return code;
	}

	public String getOperationResult() {
		return operationResult;
	}
}
