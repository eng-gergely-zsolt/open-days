package com.sapientia.open.days.backend.security;

import com.sapientia.open.days.backend.SpringApplicationContext;

public class SecurityConstants {

	public static final long EXPIRATION_TIME = 2592000000L; // 30 days

	public static final long PASSWORD_RESET_EXPIRATION_TIME = 3600000; // 1 hour

	public static final String TOKEN_PREFIX = "Bearer ";

	public static final String HEADER_STRING = "Authorization";

	public static final String CREATE_USER_URL = "/user/create-user";

	public static final String GET_FUTURE_EVENTS_URL = "/event/future-events";

	public static final String VERIFY_EMAIL_BY_OTP_CODE_URL = "/user/verify-email-by-otp-code";

	// Institution controller
	public static final String GET_INSTITUTIONS = "/institution/institutions";

	public static String getJwtSecretKey() {
		ApplicationProperties applicationProperties = (ApplicationProperties) SpringApplicationContext.getBean("ApplicationProperties");
		return applicationProperties.getJwtSecretKey();
	}
}
