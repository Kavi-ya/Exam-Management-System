package com.exam.services;

import com.exam.model.Admin;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletContext;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class AdminAuthService {
    // Remove hardcoded file path with backslashes which causes escape sequence errors
    
    public boolean authenticateAdmin(String username, String password, ServletContext context) {
        try {
            List<Admin> admins = loadAdminsFromJson(context);

            // Check if any admin matches the provided credentials
            for (Admin admin : admins) {
                if (admin.getUsername().equals(username) && admin.getPassword().equals(password)) {
                    return true;
                }
            }

            return false;
        } catch (IOException e) {
            System.err.println("Error reading admin data: " + e.getMessage());
            return false;
        } catch (JsonSyntaxException e) {
            System.err.println("Error parsing admin JSON data: " + e.getMessage());
            return false;
        }
    }

    private List<Admin> loadAdminsFromJson(ServletContext context) throws IOException {
        String jsonFilePath = "/WEB-INF/data/admin.json";
        InputStream is = context.getResourceAsStream(jsonFilePath);
        
        if (is == null) {
            System.err.println("Could not find admin.json at " + jsonFilePath);
            return new ArrayList<>();
        }
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            StringBuilder jsonContent = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonContent.append(line);
            }
            
            Gson gson = new Gson();
            Type adminListType = new TypeToken<List<Admin>>(){}.getType();
            return gson.fromJson(jsonContent.toString(), adminListType);
        }
    }
}