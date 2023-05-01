package com.sapientia.open.days.backend.ui.model.resource;

public enum ErrorMessage {
    UNSPECIFIED_ERROR("Something went wrong"),

    // User related
    USER_INVALID_EMAIL("Invalid email"),
    USER_INVALID_PUBLIC_ID("Invalid ID"),
    USER_INVALID_USERNAME("Invalid username"),
    USER_INVALID_LAST_NAME("Invalid last name"),
    USER_INVALID_FIRST_NAME("Invalid first name"),
    USER_NOT_FOUND_WITH_PUBLIC_ID("No user found with the given id"),
    USER_NOT_FOUND_WITH_USERNAME("No user found with the given username"),
    USER_USERNAME_ALREADY_TAKEN("A user already exists with the given username"),
    USER_INSTITUTION_NOT_FOUND("Institution not found"),

    // Event related
    EVENT_INVALID_ACTIVITY("The given activity is invalid"),
    EVENT_MISSING_DATE_TIME("The datetime parameter is missing"),
    EVENT_MISSING_ORGANIZER_ID("The organizer id is missing"),
    EVENT_INVALID_DATE_TIME("The datetime parameter is invalid"),
    EVENT_MISSING_MEETING_LINK("The meeting link is missing"),
    EVENT_INVALID_ORGANIZER_ID("The organizer id is invalid"),
    EVENT_MISSING_ACTIVITY_NAME("The activity name is missing"),
    EVENT_MISSING_LOCATION("The location is missing"),
    EVENT_NOT_FOUND_WITH_ID("No event found with the given id."),

    // Registration related
    EMAIL_ALREADY_REGISTERED("Email address already registered"),
    INSTITUTION_NOT_EXISTS("Institution does not exist"),
    MISSING_LAST_NAME("Missing last name"),
    MISSING_FIRST_NAME("Missing first name"),
    MISSING_EMAIL("Missing email"),
    MISSING_PASSWORD("Missing password"),
    MISSING_INSTITUTION("Missing institution"),
    MISSING_USERNAME("Missing username"),
    REGISTRATION_EMAIL_NOT_SENT("Sending the email with the OTP code has failed."),

    // Email verification related
    EMAIL_VERIFICATION_INVALID_EMAIL("There is no user with the given email address."),
    EMAIL_VERIFICATION_INVALID_OTP_CODE("The given OTP code is invalid."),
    EMAIL_VERIFICATION_EMAIL_ALREADY_VERIFIED("The given email address is already verified."),

    // Activity related
    ACTIVITY_MISSING_NAME("Activity name is missing"),
    ACTIVITY_MISSING_LOCATION("Activity location is missing"),
    ACTIVITY_ALREADY_EXISTING_NAME("This activity name already exists"),

    DB_USER_NOT_SAVED("Could not save the user");

    private final String errorMessage;

    ErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getErrorMessage() {
        return errorMessage;
    }
}
