package com.sapientia.open.days.backend.ui.model.response;

/**
 * A basic model to return a response to the client. Do not use this type aa return type in the future. Throw instead
 * a BaseException in the future.
 */
@SuppressWarnings("unused")
public class BaseResponse {
	private int errorCode;

	private String errorMessage;

	private boolean isOperationSuccessful = false;

	public BaseResponse() {}

	public BaseResponse(boolean isOperationSuccessful) {
		this.isOperationSuccessful = isOperationSuccessful;
	}

	public BaseResponse(int errorCode, String errorMessage, boolean isOperationSuccessful) {
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
		this.isOperationSuccessful = isOperationSuccessful;
	}

	public int getErrorCode() {
		return errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public boolean getIsOperationSuccessful() {
		return isOperationSuccessful;
	}

	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public void setIsOperationSuccessful(boolean operationSuccessful) {
		isOperationSuccessful = operationSuccessful;
	}
}
