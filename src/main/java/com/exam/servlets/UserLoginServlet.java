package com.exam.servlets;

import com.exam.model.User;
import com.exam.services.UserAuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class UserLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserAuthService authService = new UserAuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if there's a logout action
        String action = request.getParameter("action");
        if (action != null && action.equals("logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
                System.out.println("User logged out successfully");
            }
            response.sendRedirect("login.jsp?loggedout=true");
            return;
        }
        
        // Simply forward to the login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Processing login request...");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("Login attempt for username: " + username);

        // Get the authenticated user
        User authenticatedUser = authService.getAuthenticatedUser(username, password, getServletContext());

        if (authenticatedUser != null) {
            // Success - create session and store user details
            HttpSession session = request.getSession();
            session.setAttribute("user", authenticatedUser);
            session.setAttribute("username", authenticatedUser.getUsername());
            session.setAttribute("userId", authenticatedUser.getUserId());
            session.setAttribute("fullName", 
                authenticatedUser.getFirstName() + " " + authenticatedUser.getLastName());
            session.setAttribute("userRole", authenticatedUser.getRole());
            
            System.out.println("Login successful for: " + username + 
                ", Role: " + authenticatedUser.getRole());
            
            // Update last login time
            authService.updateLastLogin(authenticatedUser, getServletContext());

            // Redirect based on role - case insensitive comparison
            String role = authenticatedUser.getRole().toLowerCase();
            if (role.equals("student")) {
                System.out.println("Redirecting to student_dashboard.jsp");
                response.sendRedirect("student_dashboard.jsp");
            } else if (role.equals("teacher")) {
                System.out.println("Redirecting to teacher_dashboard.jsp");
                response.sendRedirect("teacher_dashboard.jsp");
            } else {
                // Default fallback
                System.out.println("Role not recognized, redirecting to Dashboard.jsp");
                response.sendRedirect("index.jsp");
            }
        } else {
            // Failed login
            System.out.println("Login failed for username: " + username);
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}