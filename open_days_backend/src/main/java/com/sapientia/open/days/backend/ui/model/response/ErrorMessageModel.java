package com.sapientia.open.days.backend.ui.model.response;

@SuppressWarnings("unused")
public class ErrorMessageModel {
	private int code;
	private String message;
	private String operationResult;

	public ErrorMessageModel() {
	}

	public ErrorMessageModel(int code, String message, String operationResult) {
		this.code = code;
		this.message = message;
		this.operationResult = operationResult;
	}

	public int getCode() {
		return code;
	}

	public String getMessage() {
		return message;
	}

	public String getOperationResult() {
		return operationResult;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public void setOperationResult(String operationResult) {
		this.operationResult = operationResult;
	}
}
