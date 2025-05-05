package com.exam.servlets;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.*;
import java.nio.file.*;

@WebServlet("/ExamCreateServlet")
public class ExamCreateServlet extends HttpServlet {
    private static final String FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\exams.json";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Get action parameter
            String action = request.getParameter("action");
            
            if ("saveExam".equals(action)) {
                // Get exam data from parameter
                String examDataJson = request.getParameter("examData");
                
                if (examDataJson == null || examDataJson.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\": \"No exam data provided\"}");
                    return;
                }
                
                // Parse the exam data
                JsonObject examData = JsonParser.parseString(examDataJson).getAsJsonObject();
                
                // Read existing exams from file
                JsonArray exams = readExamsFromFile();
                
                // Add the new exam
                exams.add(examData);
                
                // Write back to file
                writeExamsToFile(exams);
                
                // Return success response
                out.print("{\"success\": true, \"message\": \"Exam saved successfully\", \"examId\": \"" + 
                          examData.get("examId").getAsString() + "\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Invalid action\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    // Read exams from JSON file
    private JsonArray readExamsFromFile() throws IOException {
        JsonArray exams = new JsonArray();
        Path filePath = Paths.get(FILE_PATH);
        File file = filePath.toFile();
        
        // Create parent directories if they don't exist
        File parentDir = file.getParentFile();
        if (!parentDir.exists()) {
            parentDir.mkdirs();
        }
        
        // If file exists, read it
        if (file.exists()) {
            try (Reader reader = new FileReader(file)) {
                JsonElement jsonElement = JsonParser.parseReader(reader);
                if (jsonElement.isJsonArray()) {
                    exams = jsonElement.getAsJsonArray();
                }
            } catch (Exception e) {
                e.printStackTrace();
                // If there's an error reading the file, return an empty array
            }
        }
        
        return exams;
    }
    
    // Write exams to JSON file
    private void writeExamsToFile(JsonArray exams) throws IOException {
        Path filePath = Paths.get(FILE_PATH);
        File file = filePath.toFile();
        
        // Create parent directories if they don't exist
        File parentDir = file.getParentFile();
        if (!parentDir.exists()) {
            parentDir.mkdirs();
        }
        
        // Write the JSON array with pretty printing
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        try (Writer writer = new FileWriter(file)) {
            gson.toJson(exams, writer);
        }
    }
}