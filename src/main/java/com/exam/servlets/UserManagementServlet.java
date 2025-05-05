package com.exam.servlets;

import com.exam.model.User;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.*;
import java.lang.reflect.Type;

/**
 * Servlet implementation for User Management operations.
 * Handles CRUD operations for users stored in users.json file.
 * Also handles AJAX requests for user data.
 */
@WebServlet(urlPatterns = {"/userManagement", "/userManagement/*"})
public class UserManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String USER_DATA_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\users.json";
    private final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    
    /**
     * Handles GET requests for user management.
     * - If path contains user ID, processes specific user data.
     * - Otherwise, loads all users and forwards to userManagement.jsp.
     */
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Set the file path in response header for debugging
        response.setHeader("X-Data-Source", USER_DATA_PATH);
        
        // Also print it as HTML comment if requested
        if (request.getParameter("debug") != null) {
            response.getWriter().println("<!-- Reading user data from: " + USER_DATA_PATH + " -->");
        }
        
        getServletContext().log("Reading user data from: " + USER_DATA_PATH);
        
        try {
            String pathInfo = request.getPathInfo();
            
            // Handle GET request for a specific user
            if (pathInfo != null && !pathInfo.equals("/")) {
                // Extract userId from path
                String userId = pathInfo.substring(1); // Remove leading slash
                
                try {
                    User user = getUserById(userId);
                    
                    if (user != null) {
                        // Convert user to JSON and send response
                        String userJson = gson.toJson(user);
                        response.getWriter().write(userJson);
                    } else {
                        // User not found
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        JsonObject error = new JsonObject();
                        error.addProperty("error", "User not found");
                        response.getWriter().write(gson.toJson(error));
                    }
                } catch (NumberFormatException e) {
                    // Invalid user ID format
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    JsonObject error = new JsonObject();
                    error.addProperty("error", "Invalid user ID format");
                    response.getWriter().write(gson.toJson(error));
                }
            } else {
                // Return all users
                List<User> users = getAllUsers();
                response.getWriter().write(gson.toJson(users));
            }
        } catch (Exception e) {
            getServletContext().log("Error in UserServlet doGet: " + e.getMessage(), e);
            // Send JSON error response instead of letting container handle it
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Server error: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }

    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        // Store the file path in session for debugging
        session.setAttribute("dataFilePath", USER_DATA_PATH);
        
        getServletContext().log("UserServlet doPost action: " + action + ". Data file: " + USER_DATA_PATH);
        
        try {
            // Verify CSRF token for security
            //String sessionToken = (String) session.getAttribute("csrfToken");
            //String requestToken = request.getParameter("csrfToken");
            
                       
            // Process based on action parameter
            if ("add".equals(action)) {
                // Add new user
                getServletContext().log("Adding new user. Will write to: " + USER_DATA_PATH);
                addUser(request, session);
                response.sendRedirect(request.getContextPath() + "/user_management.jsp");
            } else if ("edit".equals(action)) {
                // Edit existing user
                getServletContext().log("Editing user. Will update data at: " + USER_DATA_PATH);
                updateUser(request, session);
                response.sendRedirect(request.getContextPath() + "/user_management.jsp");
            } else if ("delete".equals(action)) {
                // Delete user
                getServletContext().log("Deleting user. Will update data at: " + USER_DATA_PATH);
                deleteUser(request, session);
                response.sendRedirect(request.getContextPath() + "/user_management.jsp");
            } else {
                // Invalid action
                getServletContext().log("Invalid action: " + action);
                setMessage(session, "Invalid action specified", "danger");
                response.sendRedirect(request.getContextPath() + "/user_management.jsp");
            }
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error in UserServlet doPost: " + e.getMessage(), e);
            
            // Set error message in session
            setMessage(session, "Error processing request: " + e.getMessage(), "danger");
            response.sendRedirect(request.getContextPath() + "/user_management.jsp");
        }
    }
    
    
    /**
     * Handles DELETE requests for user management.
     * Deletes a user with the specified ID.
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Handle direct parameter-based delete
            String userId = request.getParameter("userId");
            if (userId != null) {
                deleteUserById(userId, response);
                return;
            }
            
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"User ID is required\"}");
            return;
        }
        
        // Handle REST-style path-based delete
        String userId = pathInfo.substring(1); // Remove leading slash
        deleteUserById(userId, response);
    }
    
    /**
     * Handles PUT requests for user management.
     * Updates a user with the specified ID.
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"User ID is required\"}");
            return;
        }
        
        updateUserFromPath(request, response);
    }
    
    /**
     * Helper method to set message in session
     */
    private void setMessage(HttpSession session, String message, String messageType) {
        session.setAttribute("message", message);
        session.setAttribute("messageType", messageType);
    }
    
    /**
     * Delete user based on form submission
     */
    private void deleteUser(HttpServletRequest request, HttpSession session) throws IOException {
        String userId = request.getParameter("userId");
        if (userId == null || userId.isEmpty()) {
            setMessage(session, "User ID is required", "danger");
            return;
        }
        
        List<User> users = getAllUsers();
        boolean removed = false;
        
        for (Iterator<User> it = users.iterator(); it.hasNext();) {
            User user = it.next();
            if (user.getUserId() != null && user.getUserId().equals(userId)) {
                it.remove();
                removed = true;
                break;
            }
        }
        
        if (removed) {
            saveUsers(users);
            setMessage(session, "User deleted successfully", "success");
        } else {
            setMessage(session, "User not found", "warning");
        }
    }
    
    /**
     * Update user based on form submission
     * Fixed to handle role-specific details for students and teachers
     */
    private void updateUser(HttpServletRequest request, HttpSession session) throws IOException {
        String userId = request.getParameter("userId");
        if (userId == null || userId.isEmpty()) {
            setMessage(session, "User ID is required", "danger");
            return;
        }
        
        String role = request.getParameter("role");
        if (role == null || role.isEmpty()) {
            setMessage(session, "Role is required", "danger");
            return;
        }
        
        List<User> users = getAllUsers();
        boolean updated = false;
        
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUserId() != null && users.get(i).getUserId().equals(userId)) {
                User user = users.get(i);
                
                user.setUsername(request.getParameter("username"));
                
                // Only update password if a new one is provided
                String newPassword = request.getParameter("password");
                if (newPassword != null && !newPassword.isEmpty()) {
                    user.setPassword(hashPassword(newPassword));
                }
                
                user.setEmail(request.getParameter("email"));
                user.setFirstName(request.getParameter("firstName"));
                user.setLastName(request.getParameter("lastName"));
                
                // Store old role to check if it changed
                String oldRole = user.getRole();
                user.setRole(role);
                user.setStatus(request.getParameter("status"));
                
                // Handle role-specific details - FIXED MAP TYPE to Object
                if ("student".equals(role)) {
                    Map<String, Object> studentDetails = new HashMap<>();
                    studentDetails.put("course", request.getParameter("course"));
                    studentDetails.put("semester", request.getParameter("semester"));
                    studentDetails.put("enrollmentNumber", request.getParameter("enrollmentNumber"));
                    studentDetails.put("graduationYear", request.getParameter("graduationYear"));
                    user.setStudentDetails(studentDetails);
                    
                    // Clear teacher details if role changed
                    if (!"student".equals(oldRole)) {
                        user.setTeacherDetails(null);
                    }
                } else if ("teacher".equals(role)) {
                    Map<String, Object> teacherDetails = new HashMap<>();
                    teacherDetails.put("employeeId", request.getParameter("employeeId"));
                    teacherDetails.put("department", request.getParameter("department"));
                    teacherDetails.put("designation", request.getParameter("designation"));
                    user.setTeacherDetails(teacherDetails);
                    
                    // Clear student details if role changed
                    if (!"teacher".equals(oldRole)) {
                        user.setStudentDetails(null);
                    }
                } else {
                    // For admin role, clear both student and teacher details
                    user.setStudentDetails(null);
                    user.setTeacherDetails(null);
                }
                
                // If role changed and requires a different ID prefix, generate a new ID
                if (!oldRole.equals(role)) {
                    // Check if ID prefix matches role
                    boolean shouldUpdateId = false;
                    
                    if ("admin".equals(role) && !userId.startsWith("AD")) {
                        shouldUpdateId = true;
                    } else if ("teacher".equals(role) && !userId.startsWith("TE")) {
                        shouldUpdateId = true;
                    } else if ("student".equals(role) && !userId.startsWith("ST")) {
                        shouldUpdateId = true;
                    }
                    
                    if (shouldUpdateId) {
                        user.setUserId(generateUserId(role));
                    }
                }
                
                users.set(i, user);
                saveUsers(users);
                updated = true;
                break;
            }
        }
        
        if (updated) {
            setMessage(session, "User updated successfully", "success");
        } else {
            setMessage(session, "User not found", "warning");
        }
    }
    
    /**
     * Add user based on form submission
     */
    private void addUser(HttpServletRequest request, HttpSession session) throws IOException {
        String role = request.getParameter("role");
        
        User newUser = new User();
        newUser.setUserId(generateUserId(role));
        newUser.setUsername(request.getParameter("username"));
        newUser.setPassword(hashPassword(request.getParameter("password")));
        newUser.setEmail(request.getParameter("email"));
        newUser.setFirstName(request.getParameter("firstName"));
        newUser.setLastName(request.getParameter("lastName"));
        newUser.setRole(role);
        newUser.setStatus("active");
        
        // Handle role-specific details - FIXED MAP TYPE to Object
        if ("student".equals(role)) {
            Map<String, Object> studentDetails = new HashMap<>();
            studentDetails.put("course", request.getParameter("course"));
            studentDetails.put("semester", request.getParameter("semester"));
            studentDetails.put("enrollmentNumber", request.getParameter("enrollmentNumber"));
            studentDetails.put("graduationYear", request.getParameter("graduationYear"));
            newUser.setStudentDetails(studentDetails);
        } else if ("teacher".equals(role)) {
            Map<String, Object> teacherDetails = new HashMap<>();
            teacherDetails.put("employeeId", request.getParameter("employeeId"));
            teacherDetails.put("department", request.getParameter("department"));
            teacherDetails.put("designation", request.getParameter("designation"));
            newUser.setTeacherDetails(teacherDetails);
        }
        
        LocalDateTime now = LocalDateTime.now();
        newUser.setDateRegistered(now.toString());
        newUser.setLastLogin(now.toString());
        
        List<User> users = getAllUsers();
        users.add(newUser);
        saveUsers(users);
        
        setMessage(session, "User added successfully", "success");
    }
    
    /**
     * Helper method to delete a user by ID.
     */
    private void deleteUserById(String userId, HttpServletResponse response) throws IOException {
        List<User> users = getAllUsers();
        boolean userFound = false;
        
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUserId() != null && users.get(i).getUserId().equals(userId)) {
                users.remove(i);
                saveUsers(users);
                userFound = true;
                break;
            }
        }
        
        response.setContentType("application/json");
        
        if (userFound) {
            JsonObject success = new JsonObject();
            success.addProperty("success", true);
            success.addProperty("message", "User deleted successfully");
            response.getWriter().write(gson.toJson(success));
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            JsonObject error = new JsonObject();
            error.addProperty("error", "User not found");
            response.getWriter().write(gson.toJson(error));
        }
    }
    
    /**
     * Helper method to update a user from a REST-style path request.
     */
    private void updateUserFromPath(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String userId = request.getPathInfo().substring(1); // Remove leading slash
        User updatedUser;
        
        // Parse JSON from request body
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(request.getInputStream()))) {
            updatedUser = gson.fromJson(reader, User.class);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Invalid user data format");
            response.getWriter().write(gson.toJson(error));
            return;
        }
        
        if (userId == null || updatedUser.getUserId() == null || !userId.equals(updatedUser.getUserId())) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject error = new JsonObject();
            error.addProperty("error", "User ID mismatch or missing");
            response.getWriter().write(gson.toJson(error));
            return;
        }
        
        List<User> users = getAllUsers();
        boolean userUpdated = false;
        
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUserId() != null && users.get(i).getUserId().equals(userId)) {
                // Preserve sensitive fields that shouldn't be updated via this method
                if (updatedUser.getPassword() == null || updatedUser.getPassword().isEmpty()) {
                    updatedUser.setPassword(users.get(i).getPassword());
                }
                
                users.set(i, updatedUser);
                saveUsers(users);
                userUpdated = true;
                break;
            }
        }
        
        response.setContentType("application/json");
        
        if (userUpdated) {
            JsonObject success = new JsonObject();
            success.addProperty("success", true);
            success.addProperty("message", "User updated successfully");
            response.getWriter().write(gson.toJson(success));
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            JsonObject error = new JsonObject();
            error.addProperty("error", "User not found");
            response.getWriter().write(gson.toJson(error));
        }
    }
    
    /**
     * Convert User object to JSON string
     */
    private String userToJson(User user) {
        return gson.toJson(user);
    }
    
    /**
     * Gets a user by their ID.
     */
    private User getUserById(String userId) throws IOException {
        List<User> users = getAllUsers();
        
        for (User user : users) {
            if (user.getUserId() != null && user.getUserId().equals(userId)) {
                return user;
            }
        }
        
        return null;
    }
    
    /**
     * Gets all users from the users.json file.
     */
    private List<User> getAllUsers() throws IOException {
        Path path = Paths.get(USER_DATA_PATH);
        
        if (Files.exists(path)) {
            String jsonContent = new String(Files.readAllBytes(path));
            Type userListType = new TypeToken<ArrayList<User>>(){}.getType();
            return gson.fromJson(jsonContent, userListType);
        }
        
        return new ArrayList<>();
    }
    
    /**
     * Saves all users to the users.json file.
     */
    private void saveUsers(List<User> users) throws IOException {
        String jsonContent = gson.toJson(users);
        Files.write(Paths.get(USER_DATA_PATH), jsonContent.getBytes());
    }
    
    /**
     * Generates a unique user ID based on role.
     */
    private String generateUserId(String role) {
        String prefix;
        switch (role.toLowerCase()) {
            case "admin":
                prefix = "AD";
                break;
            case "teacher":
                prefix = "TE";
                break;
            case "student":
            default:
                prefix = "ST";
                break;
        }
        return prefix + (10000000 + new Random().nextInt(90000000));
    }
    
    /**
     * Simple password hashing function.
     * In a real application, use a secure hashing algorithm with salt.
     */
    private String hashPassword(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] array = md.digest(password.getBytes());
            StringBuffer sb = new StringBuffer();
            for (byte b : array) {
                sb.append(Integer.toHexString((b & 0xFF) | 0x100).substring(1, 3));
            }
            return sb.toString();
        } catch (java.security.NoSuchAlgorithmException e) {
            return password; // Fallback to plain text (not recommended for production)
        }
    }
}