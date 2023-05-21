package com.sapientia.open.days.backend.ui.model.resource;

public enum ErrorMessage {
    UNSPECIFIED_ERROR("Something went wrong."),

    // User related
    USER_NOT_SAVED("Could not save the user."),

    USER_INVALID_EMAIL("Invalid email."),
    USER_INVALID_USERNAME("Invalid username."),
    USER_INVALID_OTP_CODE("Invalid OTP code."),
    USER_INVALID_LAST_NAME("Invalid last name."),
    USER_INVALID_PUBLIC_ID("Invalid user id."),
    USER_INVALID_FIRST_NAME("Invalid first name"),
    USER_INVALID_IMAGE_PATH("Invalid image path"),
    USER_INVALID_FIRST_PASSWORD("Invalid password"),

    USER_EMAIL_ALREADY_TAKEN("A user already exists with the given email."),
    USER_USERNAME_ALREADY_TAKEN("A user already exists with the given username."),

    USER_NOT_FOUND_WITH_USERNAME("No user found with the given username."),
    USER_NOT_FOUND_WITH_PUBLIC_ID("No user found with the given id."),

    // Activity related
    ACTIVITY_INVALID_NAME("Invalid activity name"),

    ACTIVITY_NOT_FOUND_WITH_NAME("No activity found with given name."),

    // Event related
    EVENT_NOT_SAVED("Could not save the event."),
    EVENT_NOT_UPDATED("Could not update the event."),
    EVENT_NOT_DELETED("Could not delete the event."),

    EVENT_INVALID_ID("Invalid event id."),
    EVENT_INVALID_LOCATION("Invalid location."),
    EVENT_INVALID_DATE_TIME("Invalid date time."),
    EVENT_INVALID_MEETING_LINK("Invalid meeting link."),
    EVENT_INVALID_ACTIVITY_NAME("Invalid activity name."),

    EVENT_NOT_FOUND_WITH_ID("No event found with the given id."),

    EVENT_COULD_NOT_SAVE_ENROLLED_USER("Could not save enrolled user."),
    EVENT_COULD_NOT_DELETED_ENROLLED_USER("Could not delete the enrolled user."),
    EVENT_COULD_NOT_SAVE_PARTICIPATED_USER("Could not save participated user."),

    EVENT_STATISTIC_NOT_ENOUGH_ACTIVITY("There is not activity given."),

    // County related
    COUNTY_INVALID_NAME("Invalid county name."),

    // Institution related
    INSTITUTION_INVALID_NAME("Invalid institution name."),

    INSTITUTION_NOT_FOUND_WITH_NAME("No institution found with given name"),

    // Registration related
    REGISTRATION_EMAIL_NOT_SENT("Sending the email with the OTP code has failed."),

    // Email verification related
    EMAIL_VERIFICATION_EMAIL_ALREADY_VERIFIED("The given email address is already verified.");

    private final String errorMessage;

    ErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getErrorMessage() {
        return errorMessage;
    }
}
