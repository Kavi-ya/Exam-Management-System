package com.exam.servlets;

import com.exam.model.User;
import com.exam.services.UserAuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet for student registration.
 * 
 * @author IT24102083
 * @version 1.0
 * @since 2025-03-19 19:59:43
 */
//@WebServlet("/register-student")
public class StudentRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserAuthService authService;
    
    @Override
    public void init() {
        authService = new UserAuthService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to registration page with student role pre-selected
        request.setAttribute("preselectedRole", "student");
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Student-specific parameters
        String enrollmentNumber = request.getParameter("enrollmentNumber");
        String course = request.getParameter("course");
        String semester = request.getParameter("semester");
        
        // Validate common fields
        Map<String, String> errors = validateCommonFields(firstName, lastName, email, username, password, confirmPassword);
        
        // Validate student-specific fields
        if (enrollmentNumber == null || enrollmentNumber.trim().isEmpty()) {
            errors.put("enrollmentNumber", "Enrollment number is required.");
        }
        
        if (course == null || course.trim().isEmpty()) {
            errors.put("course", "Course is required.");
        }
        
        if (semester == null || semester.trim().isEmpty()) {
            errors.put("semester", "Semester is required.");
        } else {
            try {
                int semesterNum = Integer.parseInt(semester);
                if (semesterNum < 1 || semesterNum > 8) {
                    errors.put("semester", "Semester must be between 1 and 8.");
                }
            } catch (NumberFormatException e) {
                errors.put("semester", "Semester must be a number.");
            }
        }
        
        // If there are validation errors, return to the registration page
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("preselectedRole", "student");
            
            // Preserve input values
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.setAttribute("enrollmentNumber", enrollmentNumber);
            request.setAttribute("course", course);
            request.setAttribute("semester", semester);
            
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Create user object
        User newUser = new User();
        newUser.setFirstName(firstName);
        newUser.setLastName(lastName);
        newUser.setEmail(email);
        newUser.setUsername(username);
        newUser.setPassword(password); // Will be hashed in service
        newUser.setRole("student");
        
        // Set default profile image
        newUser.setProfileImage("./assets/images/student/default.jpg");
        
        // Create student details object
        Map<String, Object> studentDetails = new HashMap<>();
        studentDetails.put("enrollmentNumber", enrollmentNumber);
        studentDetails.put("course", course);
        studentDetails.put("semester", Integer.parseInt(semester));
        
        // Use current date for admission date
        LocalDate currentDate = LocalDate.now();
        studentDetails.put("admissionDate", currentDate.toString());
        
        // Calculate graduation year based on current year + typical program length (4 years)
        int graduationYear = currentDate.getYear() + 4;
        studentDetails.put("graduationYear", graduationYear);
        
        // Create a batch ID from course name and year
        studentDetails.put("batchId", course.replaceAll("\\s+", "") + currentDate.getYear()); 
        
        // Set student details to user
        newUser.setStudentDetails(studentDetails);
        
        // Register user
        boolean registered = authService.registerUser(newUser, getServletContext());
        
        if (registered) {
            // Registration successful - create session for auto-login
            HttpSession session = request.getSession(true);
            session.setAttribute("user", newUser);
            session.setAttribute("userRole", newUser.getRole());
            session.setAttribute("userId", newUser.getUserId());
            session.setAttribute("username", newUser.getUsername());
            session.setAttribute("fullName", newUser.getFullName());
            
            // Set session timeout (30 minutes)
            session.setMaxInactiveInterval(30 * 60);
            
            // Log registration activity
            System.out.println("Student registered: " + newUser.getUsername() + " at " + 
                    LocalDateTime.now().toString());
            
            // Redirect directly to student dashboard
            response.sendRedirect(request.getContextPath() + "/student_dashboard.jsp");
        } else {
            // Registration failed
            request.setAttribute("errorMessage", "Registration failed. Username or email may already be in use.");
            request.setAttribute("preselectedRole", "student");
            
            // Preserve input values
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("enrollmentNumber", enrollmentNumber);
            request.setAttribute("course", course);
            request.setAttribute("semester", semester);
            
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    /**
     * Validates common user registration fields.
     * 
     * @return Map of error messages, empty if validation passes
     */
    private Map<String, String> validateCommonFields(String firstName, String lastName, String email, 
                                                    String username, String password, String confirmPassword) {
        Map<String, String> errors = new HashMap<>();
        
        if (firstName == null || firstName.trim().isEmpty()) {
            errors.put("firstName", "First name is required.");
        }
        
        if (lastName == null || lastName.trim().isEmpty()) {
            errors.put("lastName", "Last name is required.");
        }
        
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Email is required.");
        } else if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            errors.put("email", "Please enter a valid email address.");
        }
        
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Username is required.");
        } else if (username.length() < 5) {
            errors.put("username", "Username must be at least 5 characters long.");
        }
        
        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Password is required.");
        } else if (password.length() < 8) {
            errors.put("password", "Password must be at least 8 characters long.");
        }
        
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.put("confirmPassword", "Please confirm your password.");
        } else if (!password.equals(confirmPassword)) {
            errors.put("confirmPassword", "Passwords do not match.");
        }
        
        return errors;
    }
}