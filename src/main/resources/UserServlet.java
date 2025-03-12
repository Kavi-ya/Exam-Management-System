// UserServlet.java
package com.exam.controller;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    private UserService userService = new UserService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = new User(
                UUID.randomUUID().toString(),
                request.getParameter("username"),
                request.getParameter("password"),
                "STUDENT"
        );

        if (userService.registerUser(user)) {
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("error", "Username exists!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("users", userService.getAllUsers());
        request.getRequestDispatcher("users.jsp").forward(request, response);
    }
}