package com.sapientia.open.days.backend.ui.model.request;

// The request to login has to match this model. The user has to provide the correct email and password.
public class UserLoginRequestModel {
    private String email;
    private String password;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
