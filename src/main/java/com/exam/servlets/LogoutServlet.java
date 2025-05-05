package com.exam.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for handling user logout
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if the session exists
        if (session != null) {
            System.out.println("User logged out: " + session.getAttribute("userId"));
            
            // Invalidate the session
            session.invalidate();
        }
        
        // Redirect to the login page
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}