package com.sapientia.open.days.backend.ui.model;

@SuppressWarnings("unused")
public class User {
    private String email;
    private String publicId;
    private String roleName;
    private String username;
    private String lastName;
    private String firstName;
    private String imagePath;
    private String countyName;
    private String institutionName;

    public String getEmail() {
        return email;
    }

    public String getPublicId() {
        return publicId;
    }

    public String getUsername() {
        return username;
    }

    public String getLastName() {
        return lastName;
    }

    public String getRoleName() {
        return roleName;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getImagePath() {
        return imagePath;
    }

    public String getCountyName() {
        return countyName;
    }

    public String getInstitutionName() {
        return institutionName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPublicId(String publicId) {
        this.publicId = publicId;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public void setCountyName(String countyName) {
        this.countyName = countyName;
    }

    public void setInstitutionName(String institutionName) {
        this.institutionName = institutionName;
    }
}
