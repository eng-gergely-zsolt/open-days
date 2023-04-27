package com.sapientia.open.days.backend.ui.model.response;

@SuppressWarnings("unused")
public class UserResponse {
    private String email;
    private String county;
    private String publicId;
    private String username;
    private String lastName;
    private String roleName;
    private String firstName;
    private String imagePath;
    private String institution;

    public String getEmail() {
        return email;
    }

    public String getCounty() {
        return county;
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

    public String getInstitution() {
        return institution;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setCounty(String county) {
        this.county = county;
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

    public void setInstitution(String institution) {
        this.institution = institution;
    }
}
