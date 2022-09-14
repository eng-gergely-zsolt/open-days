package com.sapientia.open.days.backend.security;

import com.sapientia.open.days.backend.SpringApplicationContext;

public class SecurityConstants {

	public static final long EXPIRATION_TIME = 2592000000L; // 30 days

	public static final long PASSWORD_RESET_EXPIRATION_TIME = 3600000; // 1 hour

	public static final String SIGN_UP_URL = "/users";

	public static final String TOKEN_PREFIX = "Bearer ";

	public static final String HEADER_STRING = "Authorization";

	public static final String PASSWORD_RESET_URL = "/users/password-reset";

	public static final String EMAIL_VERIFICATION_URL = "/users/email-verification";

	public static final String PASSWORD_RESET_REQUEST_URL = "/users/password-reset-request";

	public static String getJwtSecretKey() {
		ApplicationProperties applicationProperties = (ApplicationProperties) SpringApplicationContext.getBean("ApplicationProperties");
		return applicationProperties.getJwtSecretKey();
	}
}
