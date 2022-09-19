package com.sapientia.open.days.backend.ui.model.response;

@SuppressWarnings("unused")
public class ErrorMessageModel {
	private int code;
	private String message;

	public ErrorMessageModel() {
	}

	public ErrorMessageModel(int code, String message) {
		this.code = code;
		this.message = message;
	}

	public int getCode() {
		return code;
	}

	public String getMessage() {
		return message;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
