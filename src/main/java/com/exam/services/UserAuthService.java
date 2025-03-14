package com.exam.services;

import com.exam.model.User;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletContext;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class UserAuthService {
    
    public boolean authenticateUser(String username, String password, String email, ServletContext context) {
        try {
            List<User> users = loadUsersFromJson(context);

            // Check if any user matches the provided credentials
            for (User user : users) {
                if (user.getUsername().equals(username) && user.getPassword().equals(password)) {
                    return true;
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
    
    public boolean registerUser(String username, String email, String password, ServletContext context) {
        try {
            List<User> users = loadUsersFromJson(context);
            
            // Check if username already exists
            for (User user : users) {
                if (user.getUsername().equals(username)) {
                    return false; // Username already exists
                }
            }
            
            // Add new user
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPassword(password);
            users.add(newUser);
            
            // Save updated user list back to JSON file
            saveUsersToJson(users, context);
            
            return true;
        } catch (IOException | JsonSyntaxException e) {
            System.err.println("Error registering user: " + e.getMessage());
            return false;
        }
    }

    private List<User> loadUsersFromJson(ServletContext context) throws IOException {
        String jsonFilePath = "/WEB-INF/data/users.json";
        InputStream is = context.getResourceAsStream(jsonFilePath);
        
        if (is == null) {
            System.err.println("Could not find users.json at " + jsonFilePath);
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
            return gson.fromJson(jsonContent.toString(), userListType);
        }
    }
    
    private void saveUsersToJson(List<User> users, ServletContext context) throws IOException {
        String jsonFilePath = "/WEB-INF/data/users.json";
        String realPath = context.getRealPath(jsonFilePath);
        
        if (realPath == null) {
            throw new IOException("Could not resolve real path for " + jsonFilePath);
        }
        
        Gson gson = new Gson();
        String jsonContent = gson.toJson(users);
        
        try (FileWriter writer = new FileWriter(realPath)) {
            writer.write(jsonContent);
        }
    }
}