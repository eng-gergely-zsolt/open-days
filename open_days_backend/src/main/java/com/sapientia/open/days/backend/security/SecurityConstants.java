package com.sapientia.open.days.backend.security;

import com.sapientia.open.days.backend.SpringApplicationContext;

public class SecurityConstants {

	public static final long EXPIRATION_TIME = 2592000000L; // 30 days

	public static final long PASSWORD_RESET_EXPIRATION_TIME = 3600000; // 1 hour

	public static final String SIGN_UP_URL = "/users";

	public static final String TOKEN_PREFIX = "Bearer ";

	public static final String HEADER_STRING = "Authorization";

	public static final String GET_ALL_EVENT_URL = "/event/all-event";

	public static final String PASSWORD_RESET_URL = "/users/password-reset";

	public static final String PASSWORD_RESET_REQUEST_URL = "/users/password-reset-request";

	public static final String EMAIL_VERIFICATION_BY_OTP_CODE_URL = "/users/email-verification-otp-code";

	// Institution controller
	public static final String INSTITUTION_ALL_NAME_WITH_COUNTY = "/institution//all-name-with-county";

	public static String getJwtSecretKey() {
		ApplicationProperties applicationProperties = (ApplicationProperties) SpringApplicationContext.getBean("ApplicationProperties");
		return applicationProperties.getJwtSecretKey();
	}
}
