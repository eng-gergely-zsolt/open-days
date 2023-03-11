package com.sapientia.open.days.backend.ui.model.response;

public class BaseResponse {
	private int errorCode;

	private String errorMessage;

	private boolean isOperationSuccessful = false;

	public BaseResponse() {}

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

	public boolean isOperationSuccessful() {
		return isOperationSuccessful;
	}

	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public void setOperationSuccessful(boolean operationSuccessful) {
		isOperationSuccessful = operationSuccessful;
	}
}
