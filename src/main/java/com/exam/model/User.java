package com.exam.model;

public class User {
    private String id;
    private String username;
    private String password;
    private String email;
    private String name;
    private String role;

    // Default constructor
    public User() {
    }

    // Parameterized constructor
    public User(String id, String username, String password, String email, String name, String role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.name = name;
        this.role = role;
    }

    // Constructor from text file line (format: id|username|password|email|name|role)
    public User(String line) {
        String[] parts = line.split("\\|");
        if (parts.length >= 6) {
            this.id = parts[0];
            this.username = parts[1];
            this.password = parts[2];
            this.email = parts[3];
            this.name = parts[4];
            this.role = parts[5];
        }
    }

    // Convert to string for text file storage
    public String toFileLine() {
        return id + "|" + username + "|" + password + "|" + email + "|" + name + "|" + role;
    }

    // Getters and setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}