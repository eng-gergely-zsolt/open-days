package com.sapientia.open.days.backend.ui.model.response;

import java.util.Date;

@SuppressWarnings("unused")
public class ErrorMessageModel {
    private Date timestamp;
    private String message;

    public ErrorMessageModel() {}

    public ErrorMessageModel(Date timestamp, String message) {
        this.message = message;
        this.timestamp = timestamp;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public String getMessage() {
        return message;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
