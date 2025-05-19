package com.MonitorHub.model;

import java.sql.Timestamp;
import java.io.Serializable;

public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    private int userid;
    private String firstname;
    private String lastname;
    private String email;
    private String phone;
    private String passwordHash;
    private Timestamp createdAt;
    private String roleName;
    private String imageUrl;

    public User() {
    }

    public User(int userid, String firstname, String lastname, String email, String phone, Timestamp createdAt, String roleName, String imageUrl) {
        this.userid = userid;
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.phone = phone;
        this.createdAt = createdAt;
        this.roleName = roleName;
        this.imageUrl = imageUrl;
    }


    // Getters and Setters
    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

     public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

     public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "User{" +
                "userid=" + userid +
                ", firstname='" + firstname + '\'' +
                ", lastname='" + lastname + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", createdAt=" + createdAt +
                ", roleName='" + roleName + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                '}';
    }
}