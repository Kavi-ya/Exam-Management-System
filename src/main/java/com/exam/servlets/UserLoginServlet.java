package com.exam.servlets;

import com.exam.services.UserAuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
//import java.io.PrintWriter;

public class UserLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserAuthService authService = new UserAuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Simply forward to the login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        
        if (authService.authenticateUser(username, password, email, getServletContext())) {
            // Success - create session
            HttpSession session = request.getSession();
            session.setAttribute("username", username);       // Changed from userUsername
            session.setAttribute("authenticated", true);      // Changed from isUser
            
            response.sendRedirect("Dashboard.jsp");
        } else {
            // Failed login
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}