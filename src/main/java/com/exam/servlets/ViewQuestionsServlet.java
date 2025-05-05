package com.exam.servlets;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.*;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/ViewQuestionsServlet")
public class ViewQuestionsServlet extends HttpServlet {
    private static final String FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\questions.json";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        File file = new File(FILE_PATH);
        List<JsonObject> questionList = null;

        // Read the JSON file
        if (file.exists() && file.canRead()) {
            try (FileReader reader = new FileReader(file)) {
                Type listType = new TypeToken<List<JsonObject>>() {}.getType();
                questionList = new Gson().fromJson(reader, listType);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Set the question list attribute
        request.setAttribute("questions", questionList);
        request.getRequestDispatcher("viewquestions.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String questionIndex = request.getParameter("index");
            deleteQuestion(Integer.parseInt(questionIndex));
            response.sendRedirect("ViewQuestionsServlet");
        } else if ("update".equals(action)) {
            int index = Integer.parseInt(request.getParameter("index"));
            String updatedQuestion = request.getParameter("question");
            String updatedOption1 = request.getParameter("option1");
            String updatedOption2 = request.getParameter("option2");
            String updatedOption3 = request.getParameter("option3");
            String updatedOption4 = request.getParameter("option4");
            int updatedCorrectAnswer = Integer.parseInt(request.getParameter("correctAnswer"));

            updateQuestion(index, updatedQuestion, updatedOption1, updatedOption2, updatedOption3, updatedOption4, updatedCorrectAnswer);
            response.sendRedirect("ViewQuestionsServlet");
        }
    }

    private void updateQuestion(int index, String updatedQuestion, String updatedOption1, String updatedOption2, String updatedOption3, String updatedOption4, int updatedCorrectAnswer) {
        File file = new File(FILE_PATH);
        List<JsonObject> questionList = null;

        if (file.exists() && file.canRead()) {
            try (FileReader reader = new FileReader(file)) {
                Type listType = new TypeToken<List<JsonObject>>() {}.getType();
                questionList = new Gson().fromJson(reader, listType);

                // Update the question
                JsonObject question = questionList.get(index);
                question.addProperty("question", updatedQuestion);

                JsonArray options = new JsonArray();
                options.add(updatedOption1);
                options.add(updatedOption2);
                options.add(updatedOption3);
                options.add(updatedOption4);
                question.add("options", options);
                question.addProperty("correctAnswer", updatedCorrectAnswer);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Write updated list back to JSON file
            try (FileWriter writer = new FileWriter(file)) {
                new Gson().toJson(questionList, writer);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


    private void deleteQuestion(int index) {
        File file = new File(FILE_PATH);
        List<JsonObject> questionList = null;

        if (file.exists() && file.canRead()) {
            try (FileReader reader = new FileReader(file)) {
                Type listType = new TypeToken<List<JsonObject>>() {}.getType();
                questionList = new Gson().fromJson(reader, listType);
                // Remove question by index
                questionList.remove(index);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Write updated list back to the JSON file
            try (FileWriter writer = new FileWriter(file)) {
                new Gson().toJson(questionList, writer);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
