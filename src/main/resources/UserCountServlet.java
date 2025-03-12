package com.exam.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UserCountServlet")
public class UserCountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check admin authentication
        Boolean isAuthenticated = (Boolean) request.getSession().getAttribute("adminAuthenticated");
        if (isAuthenticated == null || !isAuthenticated) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // For this example, return a fixed count that matches the dashboard
        int userCount = 15;
        response.setContentType("text/plain");
        response.getWriter().write(String.valueOf(userCount));
    }
}