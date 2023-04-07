package com.sapientia.open.days.backend.ui.model.request;

@SuppressWarnings("unused")
public class VerifyEmailByOtpCodeReq {
	private String email;

	private int otpCode;

	public String getEmail() {
		return email;
	}

	public int getOtpCode() {
		return otpCode;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setOtpCode(int otpCode) {
		this.otpCode = otpCode;
	}
}
