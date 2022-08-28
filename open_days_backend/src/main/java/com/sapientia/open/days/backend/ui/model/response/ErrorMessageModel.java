package com.sapientia.open.days.backend.ui.model.response;

import java.util.Date;

public class ErrorMessageModel {
    private Date timestamp;
    private String message;

    public ErrorMessageModel() {}

    public ErrorMessageModel(Date timestamp, String message) {
        this.timestamp = timestamp;
        this.message = message;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
