package com.exam.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Basic input validation
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
            return;
        }

        // Path to admin.json
        String adminJsonPath = "/data/admin.json";
        JSONParser parser = new JSONParser();

        try {
            JSONArray admins = (JSONArray) parser.parse(
                    new InputStreamReader(
                            getServletContext().getResourceAsStream("/WEB-INF/classes" + adminJsonPath),
                            StandardCharsets.UTF_8
                    )
            );

            boolean authenticated = false;
            for (Object obj : admins) {
                JSONObject admin = (JSONObject) obj;

                if (username.equals(admin.get("username")) && password.equals(admin.get("password"))) {
                    // Authentication successful
                    HttpSession session = request.getSession(true);
                    session.setAttribute("adminAuthenticated", true);
                    session.setAttribute("adminUsername", username);
                    session.setAttribute("adminId", admin.get("id"));
                    session.setAttribute("adminRole", admin.get("role"));

                    authenticated = true;
                    response.sendRedirect("adminDashboard.jsp");
                    return;
                }
            }

            if (!authenticated) {
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System error. Please try again later.");
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("adminLogin.jsp");
    }
}