package com.exam.servlets;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import com.exam.model.Question;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;

@WebServlet("/QuestionCreateServlet")
public class QuestionCreateServlet extends HttpServlet {
    private static final String FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\questions.json";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "create"; // Default action is to show create form
        }
        
        switch (action) {
            case "list":
                listQuestions(request, response);
                break;
            case "get":
                getQuestion(request, response);
                break;
            case "create":
            default:
                // Forward to create page
                request.getRequestDispatcher("questionCreate.jsp").forward(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "create"; // Default action is to create
        }
        
        switch (action) {
            case "create":
                createQuestion(request, response);
                break;
            case "update":
                updateQuestion(request, response);
                break;
            case "delete":
                deleteQuestion(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                break;
        }
    }
    
    /**
     * Create a new question
     */
    private void createQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Make sure the file path exists
            File file = new File(FILE_PATH);
            File parentDir = file.getParentFile();
            if (!parentDir.exists()) {
                parentDir.mkdirs();
            }
            
            // Create a new Question object
            Question question = new Question();
            
            // Populate from form data
            String questionId = request.getParameter("questionId");
            if (questionId == null || questionId.trim().isEmpty()) {
                questionId = UUID.randomUUID().toString();
            }
            question.setQuestionId(questionId);
            question.setQuestionText(request.getParameter("questionText"));
            question.setCourseId(request.getParameter("courseId"));
            
            // Get question type
            String questionType = request.getParameter("questionType");
            question.setQuestionType(questionType);
            
            try {
                question.setDifficultyLevel(Integer.parseInt(request.getParameter("difficultyLevel")));
                question.setPoints(Integer.parseInt(request.getParameter("points")));
            } catch (NumberFormatException e) {
                question.setDifficultyLevel(2); // Default: medium
                question.setPoints(1); // Default: 1 point
            }
            
            question.setCategory(request.getParameter("category"));
            question.setExplanation(request.getParameter("explanation"));
            
            // Process correct answer based on question type
            if ("multiple_choice".equals(questionType)) {
                // Process options for multiple choice
                List<String> options = new ArrayList<>();
                for (int i = 0; i < 6; i++) { // Support up to 6 options
                    String optionValue = request.getParameter("option" + i);
                    if (optionValue != null && !optionValue.isEmpty()) {
                        options.add(optionValue);
                    }
                }
                question.setOptions(options);
                
                // Get correct answer index and convert to letter (A, B, C, D)
                try {
                    int correctOptionIndex = Integer.parseInt(request.getParameter("correctOption"));
                    char letterChar = (char)('A' + correctOptionIndex);
                    String correctAnswer = Character.toString(letterChar);
                    question.setCorrectAnswer(correctAnswer);
                } catch (Exception e) {
                    question.setCorrectAnswer("A"); // Default to first option
                }
            } 
            else if ("true_false".equals(questionType)) {
                // For true/false questions
                List<String> options = new ArrayList<>();
                options.add("True");
                options.add("False");
                question.setOptions(options);
                
                // Get true/false answer
                String tfOption = request.getParameter("trueFalseOption");
                question.setCorrectAnswer("true".equals(tfOption) ? "True" : "False");
            }
            else if ("short_answer".equals(questionType) || "essay".equals(questionType)) {
                // For short answer or essay questions
                String correctAnswer = request.getParameter("correctAnswer");
                question.setCorrectAnswer(correctAnswer != null ? correctAnswer : "");
                
                // Clear options for short answer/essay
                question.setOptions(new ArrayList<>());
            }
            
            // Process tags
            String tagsParam = request.getParameter("tags");
            if (tagsParam != null && !tagsParam.isEmpty()) {
                String[] tags = tagsParam.split(",");
                for (int i = 0; i < tags.length; i++) {
                    tags[i] = tags[i].trim();
                }
                question.setTags(tags);
            }
            
            // Set metadata
            String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            question.setCreatedBy("IT24102083"); // Default user ID
            question.setCreatedAt(now);
            question.setModifiedAt(now);
            question.setActive(true);
            
            // Save the question
            saveQuestion(question);
            
            // Set success message and redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Question created successfully!");
            response.sendRedirect("questionCreate.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error creating question: " + e.getMessage());
            request.getRequestDispatcher("questionCreate.jsp").forward(request, response);
        }
    }
    
    /**
     * Update an existing question
     */
    private void updateQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Similar to createQuestion but updates an existing question
        // For simplicity, we'll reuse the createQuestion method
        createQuestion(request, response);
    }
    
    // Rest of the servlet code remains unchanged
    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String id = request.getParameter("id");
        
        try (PrintWriter out = response.getWriter()) {
            if (id != null && !id.trim().isEmpty()) {
                boolean deleted = deleteQuestionById(id);
                if (deleted) {
                    out.print("{\"success\": true, \"message\": \"Question deleted successfully\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\": \"Question not found\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Missing question ID\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void listQuestions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String courseFilter = request.getParameter("courseId");
            
            // Read questions from file
            List<Question> allQuestions = getAllQuestions();
            List<Question> filteredQuestions = new ArrayList<>();
            
            // Apply course filter if specified
            if (courseFilter != null && !courseFilter.trim().isEmpty()) {
                for (Question question : allQuestions) {
                    if (courseFilter.equals(question.getCourseId())) {
                        filteredQuestions.add(question);
                    }
                }
            } else {
                filteredQuestions = allQuestions;
            }
            
            // Set questions attribute and forward to view page
            request.setAttribute("questions", filteredQuestions);
            request.getRequestDispatcher("questionList.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error listing questions: " + e.getMessage());
        }
    }
    
    private void getQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String id = request.getParameter("id");
        
        try (PrintWriter out = response.getWriter()) {
            if (id != null && !id.trim().isEmpty()) {
                Question question = getQuestionById(id);
                if (question != null) {
                    // Convert to JSON
                    Gson gson = new Gson();
                    String json = gson.toJson(question);
                    out.print(json);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\": \"Question not found\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Missing question ID\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void saveQuestion(Question question) throws IOException {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        
        // Read existing questions
        List<Question> questions = getAllQuestions();
        
        // Check if updating or creating
        boolean updated = false;
        for (int i = 0; i < questions.size(); i++) {
            Question existing = questions.get(i);
            String existingId = existing.getQuestionId();
            String newId = question.getQuestionId();
            
            if (existingId != null && existingId.equals(newId)) {
                // Update existing question
                questions.set(i, question);
                updated = true;
                break;
            }
        }
        
        // If not updated, add as new
        if (!updated) {
            questions.add(question);
        }
        
        // Write back to file
        try (Writer writer = new FileWriter(FILE_PATH)) {
            gson.toJson(questions, writer);
        }
    }
    
    private List<Question> getAllQuestions() throws IOException {
        List<Question> questions = new ArrayList<>();
        
        File file = new File(FILE_PATH);
        if (!file.exists()) {
            // Return empty list if file doesn't exist
            return questions;
        }
        
        try (Reader reader = new FileReader(file)) {
            Gson gson = new Gson();
            Type questionListType = new TypeToken<List<Question>>() {}.getType();
            questions = gson.fromJson(reader, questionListType);
            
            // If null, initialize as empty list
            if (questions == null) {
                questions = new ArrayList<>();
            }
            
            // Ensure all questions have valid IDs
            for (int i = 0; i < questions.size(); i++) {
                Question q = questions.get(i);
                if (q.getQuestionId() == null || q.getQuestionId().trim().isEmpty()) {
                    q.setQuestionId(UUID.randomUUID().toString());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Return empty list on error
            return new ArrayList<>();
        }
        
        return questions;
    }
    
    private Question getQuestionById(String id) throws IOException {
        if (id == null || id.trim().isEmpty()) {
            return null;
        }
        
        List<Question> questions = getAllQuestions();
        
        for (Question question : questions) {
            if (id.equals(question.getQuestionId())) {
                return question;
            }
        }
        
        return null;
    }
    
    private boolean deleteQuestionById(String id) throws IOException {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }
        
        List<Question> questions = getAllQuestions();
        boolean removed = questions.removeIf(q -> id.equals(q.getQuestionId()));
        
        if (removed) {
            // Write updated list back to file
            try (Writer writer = new FileWriter(FILE_PATH)) {
                new GsonBuilder().setPrettyPrinting().create().toJson(questions, writer);
            }
        }
        
        return removed;
    }
}