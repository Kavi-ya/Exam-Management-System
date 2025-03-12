package com.example.auth;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletContext;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 * Repository class for admin operations with JSON files
 */
public class AdminRepository {
    private static final String ADMIN_JSON_PATH = "/data/admin.json";
    private ServletContext servletContext;

    public AdminRepository(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    /**
     * Find an admin by username and password
     *
     * @param username The username to find
     * @param password The password to verify
     * @return The admin object if found and password matches, null otherwise
     * @throws IOException    If there is an error reading the file
     * @throws ParseException If there is an error parsing the JSON
     */
    public JSONObject findAdminByCredentials(String username, String password) throws IOException, ParseException {
        JSONArray admins = readAdminsArray();

        for (Object obj : admins) {
            JSONObject admin = (JSONObject) obj;
            String storedUsername = (String) admin.get("username");
            String storedPassword = (String) admin.get("password");
            if (username != null && username.equals(storedUsername) &&
                    password != null && password.equals(storedPassword)) {
                return admin;
            }
        }

        return null;
    }

    /**
     * Check if an admin exists with the given username
     *
     * @param username The username to check
     * @return true if an admin with the username exists, false otherwise
     * @throws IOException    If there is an error reading the file
     * @throws ParseException If there is an error parsing the JSON
     */
    public boolean adminExists(String username) throws IOException, ParseException {
        JSONArray admins = readAdminsArray();

        for (Object obj : admins) {
            JSONObject admin = (JSONObject) obj;
            String storedUsername = (String) admin.get("username");
            if (username != null && username.equals(storedUsername)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Read admins from JSON file
     *
     * @return JSONArray containing all admins
     * @throws IOException    If there is an error reading the file
     * @throws ParseException If there is an error parsing the JSON
     */
    private JSONArray readAdminsArray() throws IOException, ParseException {
        try (InputStream inputStream = servletContext.getResourceAsStream(ADMIN_JSON_PATH);
             InputStreamReader reader = new InputStreamReader(inputStream, StandardCharsets.UTF_8)) {

            if (inputStream == null) {
                throw new IOException("Cannot find admin.json file");
            }

            JSONParser parser = new JSONParser();
            return (JSONArray) parser.parse(reader);
        }
    }
}