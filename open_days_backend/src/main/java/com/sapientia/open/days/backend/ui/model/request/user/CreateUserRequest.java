package com.sapientia.open.days.backend.ui.model.request.user;

@SuppressWarnings("unused")
public class CreateUserRequest {

    private String email;
    private String password;
    private String username;
    private String lastName;
    private String firstName;
    private String institutionName;

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getUsername() {
        return username;
    }

    public String getLastName() {
        return lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getInstitutionName() {
        return institutionName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setInstitutionName(String institutionName) {
        this.institutionName = institutionName;
    }
}
