package com.sapientia.open.days.backend.ui.model.response;

public class UserRest {
    private String email;
    private String objectId;
    private String username;
    private String lastName;
    private String firstName;

    public String getEmail() {return email;}

    public void setEmail(String email) {
        this.email = email;
    }

    public String getObjectId() {return objectId;}

    public void setObjectId(String objectId) {
        this.objectId = objectId;
    }

    public String getUsername() {return username;}

    public void setUsername(String username) {
        this.username = username;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
}
