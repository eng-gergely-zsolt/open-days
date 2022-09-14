package com.sapientia.open.days.backend.ui.model.request;

@SuppressWarnings("unused")
public class PasswordResetModel {

    private String token;
    private String password;

    public String getToken() {
        return token;
    }

    public String getPassword() {
        return password;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}