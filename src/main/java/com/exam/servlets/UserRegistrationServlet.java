package com.exam.servlets;

import com.exam.services.UserAuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

public class UserRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserAuthService authService = new UserAuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        //response.setContentType("text/plain");
        //PrintWriter out = response.getWriter();
        
        if (username == null || email == null || password == null ||
                username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
        	request.setAttribute("error", "Invalid username or password");
            return;
        }
        
        boolean success = authService.registerUser(username, email, password, getServletContext());
        
        if (success) {
        	HttpSession session = request.getSession();
            session.setAttribute("userUsername", username);
            session.setAttribute("isUser", true);

            response.sendRedirect("Dashboard.jsp");
            
        } else {
        	request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("signup-login.jsp").forward(request, response);
        }
    }
}