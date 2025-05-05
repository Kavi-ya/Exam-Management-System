package com.exam.servlets;

import com.exam.model.User;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.lang.reflect.Type;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation for User Settings operations.
 * Allows users to update personal information and change passwords.
 */
@WebServlet(urlPatterns = {"/AdminUserSettingsServlet"})
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024, // 1 MB
	    maxFileSize = 1024 * 1024 * 5,   // 5 MB
	    maxRequestSize = 1024 * 1024 * 10 // 10 MB
	)
public class AdminUserSettingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // File system paths (where files are stored on disk)
    private static final String FILE_SYSTEM_BASE = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp";
    private static final String USER_DATA_PATH = FILE_SYSTEM_BASE + "\\WEB-INF\\data\\admin.json";
    private static final String FILE_SYSTEM_IMAGE_PATH = FILE_SYSTEM_BASE + "\\assets\\images\\";
    
    // Web-accessible paths (for HTML/JSP)
    private static final String WEB_IMAGE_PATH = "./assets/images/";
    private static final String DEFAULT_IMAGE = WEB_IMAGE_PATH + "admin-avatar.jpg";
    
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("UserSettingsServlet initialized at " + LocalDateTime.now().format(DATE_FORMATTER));
        System.out.println("USER_DATA_PATH: " + USER_DATA_PATH);
        System.out.println("FILE_SYSTEM_IMAGE_PATH: " + FILE_SYSTEM_IMAGE_PATH);
        System.out.println("WEB_IMAGE_PATH: " + WEB_IMAGE_PATH);
        System.out.println("DEFAULT_IMAGE: " + DEFAULT_IMAGE);
        
        // Create directories if they don't exist
        String[] roleDirs = {"student", "teacher", "admin"};
        for (String roleDir : roleDirs) {
            File dir = new File(FILE_SYSTEM_IMAGE_PATH + roleDir);
            if (!dir.exists()) {
                boolean created = dir.mkdirs();
                System.out.println("Created " + roleDir + " image directory: " + created);
            }
        }
        
        // Uncomment this if you need to fix existing users' image paths
        // fixExistingProfileImagePaths();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("fixImagePaths".equals(action)) {
            HttpSession session = request.getSession();
            // Fix all user image paths
            try {
                fixExistingProfileImagePaths();
                setMessage(session, "Profile image paths fixed successfully", "success");
            } catch (Exception e) {
                setMessage(session, "Error fixing image paths: " + e.getMessage(), "danger");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/user_settings.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("UserSettingsServlet.doPost called at " + LocalDateTime.now().format(DATE_FORMATTER));
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                setMessage(session, "Please login first", "danger");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            System.out.println("Processing request for user: " + currentUser.getUserId() + " (" + currentUser.getUsername() + ")");
            System.out.println("Action: " + action);
            
            if ("updatePersonalInfo".equals(action)) {
                updatePersonalInfo(request, session, currentUser);
            } else if ("updatePassword".equals(action)) {
                updatePassword(request, session, currentUser);
            } else {
                setMessage(session, "Invalid action specified", "danger");
            }
        } catch (Exception e) {
            System.out.println("ERROR in doPost: " + e.getMessage());
            e.printStackTrace();
            setMessage(session, "Error processing request: " + e.getMessage(), "danger");
        }
        
        response.sendRedirect(request.getContextPath() + "/user_settings.jsp");
    }

    /**
     * Update personal information and profile image
     */
    private void updatePersonalInfo(HttpServletRequest request, HttpSession session, User currentUser) throws IOException, ServletException {
        System.out.println("Updating personal info for user: " + currentUser.getUserId());
        
        // Get form fields
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        
        System.out.println("Form data: firstName=" + firstName + ", lastName=" + lastName + ", email=" + email);
        
        // Validate required fields
        if (firstName == null || firstName.isEmpty() || 
            lastName == null || lastName.isEmpty() || 
            email == null || email.isEmpty()) {
            setMessage(session, "All required fields must be completed", "danger");
            return;
        }
        
        // Get all users from file
        List<User> users = getAllUsers();
        boolean updated = false;
        User updatedUser = null;
        
        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            if (user.getUserId() != null && user.getUserId().equals(currentUser.getUserId())) {
                // Update user fields
                user.setFirstName(firstName);
                user.setLastName(lastName);
                user.setEmail(email);
                user.setLastLogin(LocalDateTime.now().format(DATE_FORMATTER));
                
                // Process profile image if provided
                try {
                    Part filePart = request.getPart("profileImage");
                    if (filePart != null && filePart.getSize() > 0) {
                        System.out.println("Processing profile image upload: " + filePart.getSize() + " bytes");
                        String imagePath = saveProfileImage(filePart, user);
                        if (imagePath != null) {
                            user.setProfileImage(imagePath);
                            System.out.println("Updated profile image path: " + imagePath);
                        }
                    } else {
                        System.out.println("No profile image uploaded");
                    }
                } catch (Exception e) {
                    System.out.println("Error processing profile image: " + e.getMessage());
                    e.printStackTrace();
                }
                
                // Update user in list
                users.set(i, user);
                updatedUser = user;
                updated = true;
                break;
            }
        }
        
        if (updated) {
            // Save users to file
            saveUsers(users);
            
            // Update user in session
            session.setAttribute("user", updatedUser);
            
            setMessage(session, "Personal information updated successfully", "success");
        } else {
            setMessage(session, "User not found in database", "danger");
        }
    }

    /**
     * Update user password
     */
    private void updatePassword(HttpServletRequest request, HttpSession session, User currentUser) throws IOException {
        System.out.println("Updating password for user: " + currentUser.getUserId());
        
        // Get form fields
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate required fields
        if (currentPassword == null || currentPassword.isEmpty() || 
            newPassword == null || newPassword.isEmpty() || 
            confirmPassword == null || confirmPassword.isEmpty()) {
            setMessage(session, "All password fields are required", "danger");
            return;
        }
        
        // Validate password confirmation
        if (!newPassword.equals(confirmPassword)) {
            setMessage(session, "New passwords do not match", "danger");
            return;
        }
        
        // Get all users from file
        List<User> users = getAllUsers();
        boolean updated = false;
        User updatedUser = null;
        
        String hashedCurrentPassword = hashPassword(currentPassword);
        
        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            if (user.getUserId() != null && user.getUserId().equals(currentUser.getUserId())) {
                // Verify current password
                if (!user.getPassword().equals(hashedCurrentPassword)) {
                    setMessage(session, "Current password is incorrect", "danger");
                    return;
                }
                
                // Update password
                user.setPassword(hashPassword(newPassword));
                user.setLastLogin(LocalDateTime.now().format(DATE_FORMATTER));
                
                // Update user in list
                users.set(i, user);
                updatedUser = user;
                updated = true;
                break;
            }
        }
        
        if (updated) {
            // Save users to file
            saveUsers(users);
            
            // Update user in session
            session.setAttribute("user", updatedUser);
            
            setMessage(session, "Password updated successfully", "success");
        } else {
            setMessage(session, "User not found in database", "danger");
        }
    }

    /**
     * Save profile image based on user role and ID
     * Returns web-accessible path
     */
    private String saveProfileImage(Part filePart, User user) throws IOException {
        try {
            // Determine directory based on user role
            String roleDir = "admin"; // Default role directory
            if (user.getRole() != null) {
                roleDir = user.getRole().toLowerCase();
            }
            
            // Create full directory path
            File targetDir = new File(FILE_SYSTEM_IMAGE_PATH + roleDir);
            if (!targetDir.exists()) {
                boolean created = targetDir.mkdirs();
                System.out.println("Created directory: " + targetDir.getAbsolutePath() + " - " + created);
            }
            
            // Get file extension from submitted file
            String fileName = getSubmittedFileName(filePart);
            String extension = "";
            if (fileName != null && fileName.contains(".")) {
                extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            } else {
                // Get content type to determine extension if filename doesn't have one
                String contentType = filePart.getContentType();
                if (contentType != null) {
                    if (contentType.contains("jpeg") || contentType.contains("jpg")) {
                        extension = ".jpg";
                    } else if (contentType.contains("png")) {
                        extension = ".png";
                    } else if (contentType.contains("gif")) {
                        extension = ".gif";
                    } else {
                        extension = "." + contentType.split("/")[1];
                    }
                }
            }
            
            // Create filename using user ID
            String newFileName = user.getUserId() + extension;
            
            // File system path (for saving)
            String filePath = FILE_SYSTEM_IMAGE_PATH + roleDir + File.separator + newFileName;
            
            // Web path (for HTML/JSP)
            String webPath = WEB_IMAGE_PATH + roleDir + "/" + newFileName;
            
            System.out.println("Saving image to file system path: " + filePath);
            System.out.println("Web path for HTML/JSP access: " + webPath);
            
            // Save the file
            try (InputStream input = filePart.getInputStream();
                 FileOutputStream output = new FileOutputStream(filePath)) {
                
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
                
                output.flush();
            }
            
            // Verify file was saved
            File savedFile = new File(filePath);
            if (savedFile.exists()) {
                System.out.println("File saved successfully: " + savedFile.length() + " bytes");
            } else {
                System.out.println("ERROR: File not saved properly");
                return null;
            }
            
            // Return web-accessible path
            return webPath;
            
        } catch (Exception e) {
            System.out.println("ERROR saving profile image: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Extract filename from Part
     */
    private String getSubmittedFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
    
    /**
     * Set message in session for JSP display
     */
    private void setMessage(HttpSession session, String message, String messageType) {
        session.setAttribute("message", message);
        session.setAttribute("messageType", messageType);
        System.out.println("Set message: " + message + " (" + messageType + ")");
    }
    
    /**
     * Get all users from users.json file
     */
    private List<User> getAllUsers() throws IOException {
        System.out.println("Reading user data from: " + USER_DATA_PATH);
        
        File file = new File(USER_DATA_PATH);
        if (file.exists()) {
            String jsonContent = new String(Files.readAllBytes(file.toPath()));
            Type userListType = new TypeToken<ArrayList<User>>(){}.getType();
            List<User> users = gson.fromJson(jsonContent, userListType);
            System.out.println("Read " + users.size() + " users from file");
            return users;
        } else {
            System.out.println("User data file not found: " + USER_DATA_PATH);
        }
        
        return new ArrayList<>();
    }
    
    /**
     * Save users to users.json file
     */
    private void saveUsers(List<User> users) throws IOException {
        System.out.println("Saving " + users.size() + " users to file: " + USER_DATA_PATH + " at " + LocalDateTime.now().format(DATE_FORMATTER));
        
        // Ensure parent directory exists
        File file = new File(USER_DATA_PATH);
        File parent = file.getParentFile();
        if (!parent.exists()) {
            boolean created = parent.mkdirs();
            System.out.println("Created parent directory: " + created);
        }
        
        // Convert to JSON
        String jsonContent = gson.toJson(users);
        
        // Write content to file - using multiple approaches for reliability
        try {
            // First try with Files.write
            Files.write(file.toPath(), jsonContent.getBytes());
            System.out.println("Wrote file using Files.write");
        } catch (Exception e) {
            System.out.println("Failed with Files.write: " + e.getMessage());
            
            // Second try with FileOutputStream
            try (FileOutputStream fos = new FileOutputStream(file)) {
                byte[] bytes = jsonContent.getBytes();
                fos.write(bytes);
                fos.flush();
                System.out.println("Wrote file using FileOutputStream");
            } catch (Exception e2) {
                System.out.println("Failed with FileOutputStream: " + e2.getMessage());
                throw e2; // If both methods fail, throw the exception
            }
        }
        
        // Verify file was saved
        if (file.exists()) {
            System.out.println("Verified file exists, size: " + file.length() + " bytes");
        } else {
            throw new IOException("Failed to verify file after save");
        }
    }
    
    /**
     * Hash password using MD5 (same as UserManagementServlet)
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
            return password; // Fallback
        }
    }
    
    /**
     * Fix existing profile image paths that might be using full file system paths
     * rather than web-accessible paths
     */
    private void fixExistingProfileImagePaths() {
        try {
            List<User> users = getAllUsers();
            boolean anyUpdated = false;
            
            for (User user : users) {
                // If profile image is null, set it to default based on role
                if (user.getProfileImage() == null) {
                    String roleDir = user.getRole() != null ? user.getRole().toLowerCase() : "admin";
                    user.setProfileImage(WEB_IMAGE_PATH + roleDir + "/default.jpg");
                    System.out.println("Set default image for user " + user.getUserId());
                    anyUpdated = true;
                    continue;
                }
                
                String currentPath = user.getProfileImage();
                
                // Check if it's a file system path
                if (currentPath.startsWith("E:") || currentPath.startsWith("E/")) {
                    String roleDir = "admin";
                    
                    // Determine role from path
                    if (currentPath.contains("student")) {
                        roleDir = "student";
                    } else if (currentPath.contains("teacher")) {
                        roleDir = "teacher";
                    } else if (currentPath.contains("admin")) {
                        roleDir = "admin";
                    }
                    
                    // Get the filename - works with both / and \ separators
                    String fileName = currentPath.substring(Math.max(
                        currentPath.lastIndexOf('\\') + 1,
                        currentPath.lastIndexOf('/') + 1
                    ));
                    
                    // Create and set new web path
                    String webPath = WEB_IMAGE_PATH + roleDir + "/" + fileName;
                    user.setProfileImage(webPath);
                    
                    System.out.println("Fixed path for user " + user.getUserId() + 
                                      "\nFrom: " + currentPath + 
                                      "\nTo: " + webPath);
                    anyUpdated = true;
                }
            }
            
            if (anyUpdated) {
                saveUsers(users);
                System.out.println("Updated user image paths saved");
            } else {
                System.out.println("No image paths needed to be updated");
            }
            
        } catch (Exception e) {
            System.out.println("ERROR fixing image paths: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Helper method to get a default image path for a user based on role
     */
    private String getDefaultImageForUser(User user) {
        if (user == null || user.getRole() == null) {
            return DEFAULT_IMAGE;
        }
        
        String roleDir = user.getRole().toLowerCase();
        return WEB_IMAGE_PATH + roleDir + "/default.jpg";
    }
}