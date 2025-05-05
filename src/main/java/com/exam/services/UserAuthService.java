package com.exam.services;

import com.exam.model.User;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletContext;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserAuthService {
    
    private static final String USER_JSON_PATH = "/WEB-INF/data/users.json";
    private static final String FILE_SYSTEM_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\users.json";
    
    /**
     * Authenticates user by username and password
     * @param username Username to authenticate
     * @param password Raw password to verify
     * @param context ServletContext
     * @return true if authentication succeeded, false otherwise
     */
    public boolean authenticateUser(String username, String password, ServletContext context) {
        try {
            List<User> users = loadUsersFromJson(context);

            // Check if any user matches the provided credentials
            for (User user : users) {
                if (user.getUsername().equals(username)) {
                    // Hash the input password for comparison with stored hash
                    String hashedPassword = hashPassword(password);
                    if (user.getPassword().equals(hashedPassword)) {
                        return true;
                    }
                }
            }

            return false;
        } catch (IOException e) {
            System.err.println("Error reading user data: " + e.getMessage());
            return false;
        } catch (JsonSyntaxException e) {
            System.err.println("Error parsing user JSON data: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Retrieves user object if authentication succeeds
     * @param username Username to authenticate
     * @param password Password to verify
     * @param context ServletContext
     * @return User object if authentication succeeds, null otherwise
     */
    public User getAuthenticatedUser(String username, String password, ServletContext context) {
        try {
            List<User> users = loadUsersFromJson(context);

            // Look for a matching user
            for (User user : users) {
                if (user.getUsername().equals(username)) {
                    // Hash the provided password and compare with stored hash
                    String hashedPassword = hashPassword(password);
                    if (user.getPassword().equals(hashedPassword)) {
                        System.out.println("User authenticated: " + username + " with role: " + user.getRole());
                        return user;
                    } else {
                        // Password doesn't match
                        System.out.println("Password mismatch for user: " + username);
                        return null;
                    }
                }
            }
            // No match found
            System.out.println("Username not found: " + username);
            return null;
        } catch (IOException e) {
            System.err.println("Error reading user data: " + e.getMessage());
            return null;
        } catch (JsonSyntaxException e) {
            System.err.println("Error parsing user JSON data: " + e.getMessage());
            return null;
        }
    }

    private List<User> loadUsersFromJson(ServletContext context) throws IOException {
        // First try loading from file system path
        File jsonFile = new File(FILE_SYSTEM_PATH);
        if (jsonFile.exists() && jsonFile.isFile()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(jsonFile))) {
                StringBuilder jsonContent = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonContent.append(line);
                }
                
                Gson gson = new Gson();
                Type userListType = new TypeToken<List<User>>(){}.getType();
                List<User> users = gson.fromJson(jsonContent.toString(), userListType);
                System.out.println("Loaded " + users.size() + " users from file: " + FILE_SYSTEM_PATH);
                return users;
            } catch (IOException e) {
                System.err.println("Error reading from file system, falling back to resource: " + e.getMessage());
                // Fall back to resource stream if file read fails
            }
        }
        
        // If file system path failed, try webapp resource
        InputStream is = context.getResourceAsStream(USER_JSON_PATH);
        
        if (is == null) {
            System.err.println("Could not find users.json at " + USER_JSON_PATH);
            return new ArrayList<>();
        }
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            StringBuilder jsonContent = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonContent.append(line);
            }
            
            Gson gson = new Gson();
            Type userListType = new TypeToken<List<User>>(){}.getType();
            List<User> users = gson.fromJson(jsonContent.toString(), userListType);
            System.out.println("Loaded " + users.size() + " users from resource: " + USER_JSON_PATH);
            return users;
        }
    }
    
    public boolean registerUser(User newUser, ServletContext context) {
        try {
            // Load existing users from JSON
            List<User> users = loadUsersFromJson(context);
            
            // Check if username or email already exists
            for (User existingUser : users) {
                if (existingUser.getUsername().equals(newUser.getUsername())) {
                    System.out.println("Username already taken: " + newUser.getUsername());
                    return false; // Username already taken
                }
                if (existingUser.getEmail() != null && existingUser.getEmail().equals(newUser.getEmail())) {
                    System.out.println("Email already in use: " + newUser.getEmail());
                    return false; // Email already in use
                }
            }
            
            // Generate user ID based on role
            String rolePrefix = newUser.getRole().equalsIgnoreCase("student") ? "ST" : 
                                newUser.getRole().equalsIgnoreCase("teacher") ? "TE" : "US";
            String userIdSuffix = String.format("%02d%06d", LocalDate.now().getYear() % 100, 
                                               (int)(Math.random() * 1000000));
            newUser.setUserId(rolePrefix + userIdSuffix);
            
            // Set registration timestamp
            newUser.setDateRegistered(LocalDateTime.now().toString());
            newUser.setLastLogin(LocalDateTime.now().toString());
            
            // Set default status
            newUser.setStatus("active");
            
            // Hash password (simplified version - in production use stronger algorithm with salt)
            newUser.setPassword(hashPassword(newUser.getPassword()));
            
            // Add user to list
            users.add(newUser);
            
            // Save updated user list
            if (saveUsersToJson(users, context)) {
                System.out.println("Successfully registered user: " + newUser.getUsername() + 
                                  " with ID: " + newUser.getUserId() + 
                                  " and role: " + newUser.getRole());
                return true;
            } else {
                System.err.println("Failed to save user data to JSON file");
                return false;
            }
        } catch (IOException e) {
            System.err.println("Error registering user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Updates the last login time for a user
     * @param user The user who just logged in
     * @param context ServletContext for accessing files
     */
    public void updateLastLogin(User user, ServletContext context) {
        try {
            if (user == null || user.getUsername() == null) {
                System.err.println("Cannot update last login: user or username is null");
                return;
            }
            
            List<User> users = loadUsersFromJson(context);
            boolean updated = false;
            
            for (User existingUser : users) {
                // Use username for comparison as it's guaranteed to be non-null
                if (existingUser.getUsername() != null && 
                    existingUser.getUsername().equals(user.getUsername())) {
                    
                    existingUser.setLastLogin(LocalDateTime.now().toString());
                    updated = true;
                    break;
                }
            }
            
            if (updated) {
                saveUsersToJson(users, context);
                System.out.println("Last login updated for user: " + user.getUsername());
            } else {
                System.err.println("Could not find user to update last login: " + user.getUsername());
            }
        } catch (IOException e) {
            System.err.println("Error updating last login: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error updating last login: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Simple password hashing (MD5). 
     * Note: For production, use a more secure algorithm like bcrypt or PBKDF2.
     */
    private String hashPassword(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] array = md.digest(password.getBytes());
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < array.length; ++i) {
                sb.append(Integer.toHexString((array[i] & 0xFF) | 0x100).substring(1, 3));
            }
            return sb.toString();
        } catch (java.security.NoSuchAlgorithmException e) {
            // Fallback to plain text if hashing fails
            return password;
        }
    }

    /**
     * Saves the user list back to JSON file using the specific file path
     */
    private boolean saveUsersToJson(List<User> users, ServletContext context) throws IOException {
        File jsonFile = new File(FILE_SYSTEM_PATH);
        
        // Create parent directories if they don't exist
        File parentDir = jsonFile.getParentFile();
        if (!parentDir.exists()) {
            if (!parentDir.mkdirs()) {
                System.err.println("Failed to create directory: " + parentDir.getAbsolutePath());
                return false;
            }
        }
        
        // Write users to the file
        try (FileWriter writer = new FileWriter(jsonFile)) {
            Gson gson = new GsonBuilder().setPrettyPrinting().create();
            gson.toJson(users, writer);
            System.out.println("Users saved to: " + jsonFile.getAbsolutePath() + " at " + 
                              LocalDateTime.now().toString());
            return true;
        } catch (IOException e) {
            System.err.println("Error writing to users.json: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}