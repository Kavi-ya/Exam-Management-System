<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Check if this is a logout action
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        // Invalidate the session
        session.invalidate();
        // Create a new session for the message
        session = request.getSession(true);
        session.setAttribute("message", "You have been successfully logged out.");
        session.setAttribute("messageType", "success");
     // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
%>