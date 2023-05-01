package com.sapientia.open.days.backend.ui.model.resource;


public enum ErrorCode {
	UNSPECIFIED_ERROR(1000),

	// User related 1001 - 1100
	USER_INVALID_EMAIL(1001),
	USER_INVALID_PUBLIC_ID(1002),
	USER_INVALID_USERNAME(1003),
	USER_INVALID_LAST_NAME(1004),
	USER_INVALID_FIRST_NAME(1005),
	USER_NOT_FOUND_WITH_PUBLIC_ID(1006),
	USER_NOT_FOUND_WITH_USERNAME(1007),
	USER_USERNAME_ALREADY_TAKEN(1008),
	USER_INSTITUTION_NOT_FOUND(1009),

	// Event related 1101 - 1200
	EVENT_INVALID_ACTIVITY(1101),
	EVENT_MISSING_DATE_TIME(1102),
	EVENT_MISSING_ORGANIZER_ID(1103),
	EVENT_INVALID_DATE_TIME(1104),
	EVENT_MISSING_MEETING_LINK(1105),
	EVENT_INVALID_ORGANIZER_ID(1106),
	EVENT_MISSING_ACTIVITY_NAME(1107),
	EVENT_MISSING_LOCATION(1108),
	EVENT_NOT_FOUND_WITH_ID(1009),

	// Registration related 1201 - 1250
	EMAIL_ALREADY_REGISTERED(1201),
	INSTITUTION_NOT_EXISTS(1202),
	MISSING_LAST_NAME(1203),
	MISSING_FIRST_NAME(1204),
	MISSING_EMAIL(1205),
	MISSING_PASSWORD(1206),
	MISSING_INSTITUTION(1207),
	MISSING_USERNAME(1208),
	REGISTRATION_EMAIL_NOT_SENT(1209),

	// Email verification related 1251 - 1300
	EMAIL_VERIFICATION_INVALID_EMAIL(1251),
	EMAIL_VERIFICATION_INVALID_OTP_CODE(1252),
	EMAIL_VERIFICATION_EMAIL_ALREADY_VERIFIED(1253),

	// Activity related 1301 - 1350
	ACTIVITY_MISSING_NAME(1301),
	ACTIVITY_MISSING_LOCATION(1302),
	ACTIVITY_ALREADY_EXISTING_NAME(1303),

	// Database related 1351-1400
	DB_USER_NOT_SAVED(1351);

	private final int errorCode;

	ErrorCode(int errorMessage) {
		this.errorCode = errorMessage;
	}

	public int getErrorCode() {
		return errorCode;
	}
}
