package com.sapientia.open.days.backend.ui.model.request;

// The request to login has to match this model. The user has to provide the correct email and password.
public class UserLoginRequestModel {
    private String username;
    private String password;

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
