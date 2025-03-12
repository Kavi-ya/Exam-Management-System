import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String ADMIN_JSON_PATH = "/WEB-INF/classes/data/admin.json";

    public AdminLoginServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            JSONObject admin = validateAdmin(username, password);

            if (admin != null) {
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                session = request.getSession(true);

                session.setAttribute("adminUsername", username);
                session.setAttribute("adminId", admin.get("id"));
                session.setAttribute("adminRole", admin.get("role"));
                session.setAttribute("adminAuthenticated", true);

                response.sendRedirect("adminDashboard.jsp");
            } else {
                request.setAttribute("errorMessage", "Invalid administrator credentials");
                request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "System error: " + e.getMessage());
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
        }
    }

    private JSONObject validateAdmin(String username, String password) {
        if (username == null || password == null) {
            return null;
        }

        try (InputStream inputStream = getServletContext().getResourceAsStream(ADMIN_JSON_PATH)) {
            if (inputStream == null) {
                throw new IOException("Cannot find admin.json file");
            }

            JSONParser parser = new JSONParser();
            JSONArray admins = (JSONArray) parser.parse(new InputStreamReader(inputStream, StandardCharsets.UTF_8));

            for (Object obj : admins) {
                JSONObject admin = (JSONObject) obj;
                String storedPassword = (String) admin.get("password");

                if (username.equals(admin.get("username")) && password.equals(storedPassword)) {
                    return admin;
                }
            }
        } catch (IOException | ParseException e) {
            e.printStackTrace();
        }

        return null;
    }
}