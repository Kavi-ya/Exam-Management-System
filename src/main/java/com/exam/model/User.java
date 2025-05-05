package com.exam.model;

import java.util.Map;

/**
 * User model representing a user in the exam system.
 *
 * @author IT24102083
 * @version 1.0
 * @since 2025-03-19 19:20:23
 */
public class User {
    private String userId;
    private String username;
    private String password;
    private String email;
    private String firstName;
    private String lastName;
    private String role;
    private String status;
    private String dateRegistered;
    private String lastLogin;
    private String profileImage;
    private Map<String, Object> studentDetails;
    private Map<String, Object> teacherDetails;
    
    // Default constructor
    public User() {
    }
    
    // Constructor with main fields
    public User(String username, String password, String email, String firstName, String lastName, String role) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
    }
    
    // Getters and Setters
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getDateRegistered() {
        return dateRegistered;
    }
    
    public void setDateRegistered(String dateRegistered) {
        this.dateRegistered = dateRegistered;
    }
    
    public String getLastLogin() {
        return lastLogin;
    }
    
    public void setLastLogin(String lastLogin) {
        this.lastLogin = lastLogin;
    }
    
    public String getProfileImage() {
        return profileImage;
    }
    
    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }
    
    public Map<String, Object> getStudentDetails() {
        return studentDetails;
    }
    
    public void setStudentDetails(Map<String, Object> studentDetails) {
        this.studentDetails = studentDetails;
    }
    
    public Map<String, Object> getTeacherDetails() {
        return teacherDetails;
    }
    
    public void setTeacherDetails(Map<String, Object> teacherDetails) {
        this.teacherDetails = teacherDetails;
    }
    
    public String getFullName() {
        return firstName + " " + lastName;
    }
}