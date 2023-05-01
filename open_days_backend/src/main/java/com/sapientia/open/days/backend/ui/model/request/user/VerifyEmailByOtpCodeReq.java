package com.sapientia.open.days.backend.ui.model.request.user;

@SuppressWarnings("unused")
public class VerifyEmailByOtpCodeReq {
	private int otpCode;
	private String email;

	public int getOtpCode() {
		return otpCode;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setOtpCode(int otpCode) {
		this.otpCode = otpCode;
	}
}
