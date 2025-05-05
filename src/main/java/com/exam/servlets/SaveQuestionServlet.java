package com.exam.servlets;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.*;

@WebServlet("/SaveQuestionServlet")
public class SaveQuestionServlet extends HttpServlet {
    private static final String FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\questions.json";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Retrieve question data from form
        String question = request.getParameter("question");
        String option1 = request.getParameter("option1");
        String option2 = request.getParameter("option2");
        String option3 = request.getParameter("option3");
        String option4 = request.getParameter("option4");
        int correctAnswer = Integer.parseInt(request.getParameter("correctAnswer"));

        // Create a JSON object for the new question using Gson
        JsonObject newQuestion = new JsonObject();
        newQuestion.addProperty("question", question);

        JsonArray options = new JsonArray();
        options.add(option1);
        options.add(option2);
        options.add(option3);
        options.add(option4);
        newQuestion.add("options", options);
        newQuestion.addProperty("correctAnswer", correctAnswer);

        // Read existing JSON file
        JsonArray questionArray = new JsonArray();
        File file = new File(FILE_PATH);
        if (file.exists()) {
            try (FileReader reader = new FileReader(file)) {
                questionArray = JsonParser.parseReader(reader).getAsJsonArray();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Add new question to array
        questionArray.add(newQuestion);

        // Write back to JSON file
        try (FileWriter writer = new FileWriter(FILE_PATH)) {
            writer.write(new GsonBuilder().setPrettyPrinting().create().toJson(questionArray));
            writer.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Redirect back to create.jsp with success message
        response.sendRedirect("Create.jsp?status=success");
    }
}
