package com.sapientia.open.days.backend.ui.model.resource;

public enum ErrorMessage {
    MISSING_REQUIRED_FIELD("Missing required field. Please check documentation for required fields"),
    NO_RECORD_FOUND("Record with provided id is not found"),

    UNSPECIFIED_ERROR("Something went wrong"),

    EMAIL_ALREADY_REGISTERED("Email address already registered"),

    INSTITUTION_NOT_EXISTS("Institution does not exist"),
    MISSING_LAST_NAME("Missing last name"),
    MISSING_FIRST_NAME("Missing first name"),
    MISSING_EMAIL("Missing email"),
    MISSING_PASSWORD("Missing password"),
    MISSING_INSTITUTION("Missing institution"),
    MISSING_USERNAME("Missing username"),
    INVALID_PUBLIC_ID("Invalid public id"),
    USER_NOT_FOUND_WITH_USERNAME("No user found with given username"),
    USER_NOT_FOUND_WITH_ID("No user found with given id"),

    ACTIVITY_MISSING_NAME("Activity name is missing"),
    ACTIVITY_MISSING_LOCATION("Activity location is missing"),
    ACTIVITY_ALREADY_EXISTING_NAME("This activity name already exists"),

    // Email verification 1020-1039
    EMAIL_VERIFICATION_NO_USER("User not found"),
    EMAIL_VERIFICATION_TOKEN_EXPIRED("The email verification token has expired"),

    EVENT_INVALID_ACTIVITY("The given activity is invalid"),
    EVENT_MISSING_DATE_TIME("The datetime parameter is missing"),
    EVENT_MISSING_ORGANIZER_ID("The organizer id is missing"),
    EVENT_INVALID_DATE_TIME("The datetime parameter is invalid"),
    EVENT_MISSING_MEETING_LINK("The meeting link is missing"),
    EVENT_INVALID_ORGANIZER_ID("The organizer id is invalid"),
    EVENT_MISSING_ACTIVITY_NAME("The activity name is missing"),
    EVENT_MISSING_LOCATION("The location is missing");

    private String errorMessage;

    ErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
}
