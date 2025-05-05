package com.exam.servlets;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

/**
 * Servlet for managing exams and questions data
 * Handles CRUD operations for exams and their associated questions
 */
@WebServlet("/ViewExamsServlet")
public class ViewExamsServlet extends HttpServlet {
    // Hard-coded paths as specified
    private final String EXAMS_FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\exams.json";
    private final String QUESTIONS_FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\questions.json";
    
    // System defaults - will be overridden by session values when available
    private final String DEFAULT_DATETIME = "2025-04-10 20:15:13"; // Updated
    private final String DEFAULT_USER_ID = "IT24102083"; // Set to match login
    
    // Custom JsonSerializer to maintain field order in question objects
    private class OrderedQuestionSerializer implements JsonSerializer<JsonObject> {
        @Override
        public JsonElement serialize(JsonObject src, Type typeOfSrc, JsonSerializationContext context) {
            JsonObject ordered = new JsonObject();
            
            // Add fields in the exact order specified
            addIfExists(src, ordered, "questionId");
            addIfExists(src, ordered, "questionText");
            addIfExists(src, ordered, "courseId");
            addIfExists(src, ordered, "questionType");
            addIfExists(src, ordered, "difficultyLevel");
            addIfExists(src, ordered, "points");
            
            // Add options array if it exists
            addIfExists(src, ordered, "options");
            
            // Add correctAnswer
            addIfExists(src, ordered, "correctAnswer");
            
            // Add metadata fields
            addIfExists(src, ordered, "createdBy");
            addIfExists(src, ordered, "createdAt");
            addIfExists(src, ordered, "modifiedAt");
            addIfExists(src, ordered, "active");
            
            // Add any remaining fields that we didn't explicitly handle
            for (Map.Entry<String, JsonElement> entry : src.entrySet()) {
                String key = entry.getKey();
                if (!ordered.has(key)) {
                    ordered.add(key, entry.getValue());
                }
            }
            
            return ordered;
        }
        
        private void addIfExists(JsonObject src, JsonObject target, String field) {
            if (src.has(field)) {
                target.add(field, src.get(field));
            }
        }
    }
    
    // Gson instance for JSON operations with ordered fields for questions
    private final Gson gson = new GsonBuilder()
        .setPrettyPrinting()
        .registerTypeAdapter(JsonObject.class, new OrderedQuestionSerializer())
        .create();

    @Override
    public void init() throws ServletException {
        super.init();
        
        System.out.println("ViewExamsServlet initialized");
        System.out.println("Using exams file path: " + EXAMS_FILE_PATH);
        System.out.println("Using questions file path: " + QUESTIONS_FILE_PATH);
        
        // Ensure data directories exist
        ensureDirectoriesExist();
        
        // Initialize files if needed
        initializeFilesIfNeeded();
    }
    
    /**
     * Get current user ID from session, falling back to default if not available
     */
    private String getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            String userId = (String) session.getAttribute("userId");
            if (userId != null && !userId.isEmpty()) {
                return userId;
            }
        }
        return DEFAULT_USER_ID;
    }
    
    /**
     * Get current date/time, preferring session value if available
     */
    private String getCurrentDateTime(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            String dateTime = (String) session.getAttribute("currentDateTime");
            if (dateTime != null && !dateTime.isEmpty()) {
                return dateTime;
            }
        }
        return DEFAULT_DATETIME;
    }
    
    /**
     * Make sure all required directories exist
     */
    private void ensureDirectoriesExist() {
        File examsFile = new File(EXAMS_FILE_PATH);
        File questionsFile = new File(QUESTIONS_FILE_PATH);
        
        File examsDir = examsFile.getParentFile();
        if (examsDir != null && !examsDir.exists()) {
            boolean created = examsDir.mkdirs();
            System.out.println("Created exams directory: " + created);
        }
        
        File questionsDir = questionsFile.getParentFile();
        if (questionsDir != null && !questionsDir.exists()) {
            boolean created = questionsDir.mkdirs();
            System.out.println("Created questions directory: " + created);
        }
    }
    
    /**
     * Initialize JSON files with sample data if they don't exist
     */
    private void initializeFilesIfNeeded() {
        File examsFile = new File(EXAMS_FILE_PATH);
        File questionsFile = new File(QUESTIONS_FILE_PATH);
        
        try {
            // For exams.json
            if (!examsFile.exists() || examsFile.length() == 0) {
                System.out.println("Exams file does not exist or is empty. Creating sample data.");
                List<JsonObject> sampleExams = createSampleExams(DEFAULT_USER_ID);
                saveExams(sampleExams);
            }
            
            // For questions.json
            if (!questionsFile.exists() || questionsFile.length() == 0) {
                System.out.println("Questions file does not exist or is empty. Creating sample questions.");
                List<JsonObject> exams = loadExams(null);
                List<JsonObject> allQuestions = new ArrayList<>();
                
                // Create questions for each exam
                for (JsonObject exam : exams) {
                    if (exam.has("examId") && exam.has("questions")) {
                        String examId = exam.get("examId").getAsString();
                        JsonArray questionIds = exam.getAsJsonArray("questions");
                        
                        for (JsonElement element : questionIds) {
                            String questionId = element.getAsString();
                            JsonObject question = createSampleQuestion(questionId, examId, exam, null);
                            allQuestions.add(question);
                        }
                    }
                }
                
                saveQuestions(allQuestions);
            }
            
            // Debug - verify file contents
            System.out.println("Verifying file contents after initialization:");
            List<JsonObject> exams = loadExams(null);
            List<JsonObject> questions = loadQuestions();
            System.out.println("Loaded " + exams.size() + " exams and " + questions.size() + " questions");
            
        } catch (Exception e) {
            System.out.println("Error initializing files: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Create a single sample question with the proper format and order
     */
    private JsonObject createSampleQuestion(String questionId, String examId, JsonObject exam, HttpServletRequest request) {
        JsonObject question = new JsonObject();
        
        // Get current user ID and date/time (use request if available)
        String currentUserId = request != null ? getCurrentUserId(request) : DEFAULT_USER_ID;
        String currentDateTime = request != null ? getCurrentDateTime(request) : DEFAULT_DATETIME;
        
        // Add fields in the exact desired order
        // 1. questionId
        question.addProperty("questionId", questionId);
        
        // 2. questionText
        question.addProperty("questionText", "Sample question " + questionId.substring(1) + " for exam " + examId);
        
        // 3. courseId
        String courseId = "CSE101";
        if (exam.has("courseId")) {
            courseId = exam.get("courseId").getAsString();
        }
        question.addProperty("courseId", courseId);
        
        // 4. questionType
        String[] types = {"multiple_choice", "true_false", "short_answer"};
        String type = types[(int)(Math.random() * types.length)];
        question.addProperty("questionType", type);
        
        // 5. difficultyLevel
        question.addProperty("difficultyLevel", (int)(Math.random() * 3) + 1);
        
        // 6. points
        int points = 5;
        if (type.equals("true_false")) points = 2;
        else if (type.equals("short_answer")) points = 10;
        question.addProperty("points", points);
        
        // 7. options (if applicable)
        if (type.equals("multiple_choice")) {
            JsonArray options = new JsonArray();
            options.add("Option A");
            options.add("Option B");
            options.add("Option C");
            options.add("Option D");
            question.add("options", options);
        } else if (type.equals("true_false")) {
            JsonArray options = new JsonArray();
            options.add("True");
            options.add("False");
            question.add("options", options);
        }
        
        // 8. correctAnswer
        if (type.equals("multiple_choice")) {
            int correctIndex = (int)(Math.random() * 4);
            char letter = (char)('A' + correctIndex);
            question.addProperty("correctAnswer", String.valueOf(letter));
        } else if (type.equals("true_false")) {
            question.addProperty("correctAnswer", Math.random() > 0.5 ? "True" : "False");
        } else {
            question.addProperty("correctAnswer", "Sample answer for " + questionId);
        }
        
        // 9. createdBy
        question.addProperty("createdBy", currentUserId);
        
        // 10. createdAt
        question.addProperty("createdAt", currentDateTime);
        
        // 11. modifiedAt
        question.addProperty("modifiedAt", currentDateTime);
        
        // 12. active
        question.addProperty("active", true);
        
        return question;
    }

    /**
     * Handles GET requests to retrieve exam data
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("ViewExamsServlet: doGet called with action=" + request.getParameter("action"));
        
        // Get current user ID from session or parameter
        String currentUserId = getCurrentUserId(request);
        String currentDateTime = getCurrentDateTime(request);
        
        // Extract action parameter
        String action = request.getParameter("action");
        
        // If it's requesting specific data as JSON
        if ("getExam".equals(action) || "getQuestions".equals(action) || "getQuestionById".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            try {
                if ("getExam".equals(action)) {
                    String examId = request.getParameter("examId");
                    if (examId == null || examId.isEmpty()) {
                        sendErrorResponse(response, "Exam ID is required");
                        return;
                    }
                    
                    JsonObject exam = getExamById(examId);
                    if (exam == null) {
                        sendErrorResponse(response, "Exam not found");
                        return;
                    }
                    
                    // Send the exam as JSON
                    sendJsonResponse(response, exam);
                    
                } else if ("getQuestions".equals(action)) {
                    String examId = request.getParameter("examId");
                    if (examId == null || examId.isEmpty()) {
                        sendErrorResponse(response, "Exam ID is required");
                        return;
                    }
                    
                    List<JsonObject> questions = getQuestionsForExam(examId);
                    
                    // Send the questions as JSON
                    sendJsonResponse(response, questions);
                } else if ("getQuestionById".equals(action)) {
                    String questionId = request.getParameter("questionId");
                    if (questionId == null || questionId.isEmpty()) {
                        sendErrorResponse(response, "Question ID is required");
                        return;
                    }
                    
                    JsonObject question = getQuestionById(questionId);
                    if (question == null) {
                        sendErrorResponse(response, "Question not found");
                        return;
                    }
                    
                    // Send the question as JSON
                    sendJsonResponse(response, question);
                }
            } catch (Exception e) {
                e.printStackTrace();
                sendErrorResponse(response, "Error processing request: " + e.getMessage());
            }
        } else {
            // Default action: view all exams
            try {
                // Load all exams for this user
                List<JsonObject> exams = loadExams(currentUserId);
                System.out.println("Loaded " + exams.size() + " exams");
                
                // First ensure we have all questions needed for these exams
                ensureQuestionsExistForExams(exams, request);
                
                // Then load questions for each exam
                Map<String, List<JsonObject>> questionsByExam = new HashMap<>();
                for (JsonObject exam : exams) {
                    if (exam.has("examId")) {
                        String examId = exam.get("examId").getAsString();
                        List<JsonObject> questions = getQuestionsForExam(examId);
                        questionsByExam.put(examId, questions);
                        System.out.println("Loaded " + questions.size() + " questions for exam " + examId);
                    }
                }
                
                // Set attributes for the JSP
                request.setAttribute("exams", exams);
                request.setAttribute("questionsByExam", questionsByExam);
                request.setAttribute("currentDateTime", currentDateTime);
                request.setAttribute("currentUserId", currentUserId);
                
                // Forward to the JSP
                request.getRequestDispatcher("viewMyexam.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Error in doGet: " + e.getMessage());
                e.printStackTrace();
                
                request.setAttribute("error", "Failed to load exam data: " + e.getMessage());
                request.getRequestDispatcher("viewMyexam.jsp").forward(request, response);
            }
        }
    }
    
    /**
     * Make sure questions exist for all exams
     */
    private void ensureQuestionsExistForExams(List<JsonObject> exams, HttpServletRequest request) {
        List<JsonObject> allQuestions = loadQuestions();
        List<JsonObject> newQuestions = new ArrayList<>();
        boolean needsSaving = false;
        
        // Get all existing question IDs
        Set<String> existingQuestionIds = new HashSet<>();
        for (JsonObject question : allQuestions) {
            if (question.has("questionId")) {
                existingQuestionIds.add(question.get("questionId").getAsString());
            }
        }
        
        // For each exam, check all question IDs
        for (JsonObject exam : exams) {
            if (!exam.has("examId") || !exam.has("questions")) {
                continue;
            }
            
            String examId = exam.get("examId").getAsString();
            JsonArray questionIds = exam.getAsJsonArray("questions");
            
            for (JsonElement element : questionIds) {
                String questionId = element.getAsString();
                
                // If question doesn't exist, create it
                if (!existingQuestionIds.contains(questionId)) {
                    JsonObject newQuestion = createSampleQuestion(questionId, examId, exam, request);
                    newQuestions.add(newQuestion);
                    existingQuestionIds.add(questionId); // Add to set to avoid duplicates
                    needsSaving = true;
                }
            }
        }
        
        if (needsSaving && !newQuestions.isEmpty()) {
            allQuestions.addAll(newQuestions);
            saveQuestions(allQuestions);
            System.out.println("Added " + newQuestions.size() + " missing questions for exams");
        }
    }

    /**
     * Get a specific question by its ID
     */
    private JsonObject getQuestionById(String questionId) {
        List<JsonObject> allQuestions = loadQuestions();
        
        for (JsonObject question : allQuestions) {
            if (question != null && question.has("questionId") && 
                question.get("questionId").getAsString().equals(questionId)) {
                return question;
            }
        }
        
        return null;
    }

    /**
     * Gets questions for a specific exam from questions.json file
     */
    private List<JsonObject> getQuestionsForExam(String examId) {
        List<JsonObject> questions = new ArrayList<>();
        
        // Get the exam to find its question IDs
        JsonObject exam = getExamById(examId);
        if (exam == null || !exam.has("questions")) {
            return questions;
        }
        
        // Get the question IDs from the exam
        JsonArray questionIdsArray = exam.getAsJsonArray("questions");
        Set<String> questionIds = new HashSet<>();
        for (JsonElement element : questionIdsArray) {
            questionIds.add(element.getAsString());
        }
        
        // Get all questions
        List<JsonObject> allQuestions = loadQuestions();
        
        // Find questions that match the IDs from the exam
        for (JsonObject question : allQuestions) {
            if (question != null && question.has("questionId")) {
                String currentId = question.get("questionId").getAsString();
                
                if (questionIds.contains(currentId)) {
                    questions.add(question);
                }
            }
        }
        
        System.out.println("Found " + questions.size() + " questions out of " + questionIds.size() + 
                         " IDs for exam " + examId);
        return questions;
    }

    /**
     * Handles POST requests to update or delete exam and question data
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("ViewExamsServlet: doPost called with action=" + request.getParameter("action"));
        
        // Get current user ID and date/time
        String currentUserId = getCurrentUserId(request);
        String currentDateTime = getCurrentDateTime(request);
        
        // Set response content type
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Extract common parameters
        String action = request.getParameter("action");
        
        if (action == null) {
            sendErrorResponse(response, "Action parameter is required");
            return;
        }
        
        try {
            switch (action) {
                case "updateExam":
                    // Update an exam
                    String examData = request.getParameter("examData");
                    if (examData == null || examData.isEmpty()) {
                        sendErrorResponse(response, "Exam data is required");
                        return;
                    }
                    
                    System.out.println("Updating exam with data: " + examData);
                    JsonObject updatedExam = gson.fromJson(examData, JsonObject.class);
                    
                    // Ensure current user and date/time are set
                    if (!updatedExam.has("modifiedAt")) {
                        updatedExam.addProperty("modifiedAt", currentDateTime);
                    }
                    
                    boolean updateSuccess = updateExam(updatedExam);
                    
                    if (updateSuccess) {
                        JsonObject result = new JsonObject();
                        result.addProperty("success", true);
                        result.addProperty("message", "Exam updated successfully");
                        sendJsonResponse(response, result);
                    } else {
                        sendErrorResponse(response, "Failed to update exam");
                    }
                    break;
                    
                case "deleteExam":
                    // Delete an exam
                    String examId = request.getParameter("examId");
                    if (examId == null || examId.isEmpty()) {
                        sendErrorResponse(response, "Exam ID is required");
                        return;
                    }
                    
                    System.out.println("Deleting exam with ID: " + examId);
                    boolean deleteSuccess = deleteExam(examId);
                    
                    if (deleteSuccess) {
                        JsonObject result = new JsonObject();
                        result.addProperty("success", true);
                        result.addProperty("message", "Exam deleted successfully");
                        sendJsonResponse(response, result);
                    } else {
                        sendErrorResponse(response, "Failed to delete exam");
                    }
                    break;
                    
                case "updateQuestion":
                    // Update a question
                    String questionData = request.getParameter("questionData");
                    if (questionData == null || questionData.isEmpty()) {
                        sendErrorResponse(response, "Question data is required");
                        return;
                    }
                    
                    System.out.println("Updating question with data: " + questionData);
                    JsonObject partialQuestion = gson.fromJson(questionData, JsonObject.class);
                    
                    // We only want to update specific fields, not replace the entire question
                    String questionId = null;
                    
                    // Get the ID of the question to update
                    if (partialQuestion.has("questionId")) {
                        questionId = partialQuestion.get("questionId").getAsString();
                    } else if (partialQuestion.has("id")) {
                        questionId = partialQuestion.get("id").getAsString();
                        // Convert to the preferred format
                        partialQuestion.addProperty("questionId", questionId);
                        partialQuestion.remove("id");
                    }
                    
                    if (questionId == null) {
                        sendErrorResponse(response, "Question ID is required for update");
                        return;
                    }
                    
                    // Convert any other fields to preferred format
                    if (partialQuestion.has("text") && !partialQuestion.has("questionText")) {
                        partialQuestion.addProperty("questionText", partialQuestion.get("text").getAsString());
                        partialQuestion.remove("text");
                    }
                    
                    if (partialQuestion.has("type") && !partialQuestion.has("questionType")) {
                        partialQuestion.addProperty("questionType", partialQuestion.get("type").getAsString());
                        partialQuestion.remove("type");
                    }
                    
                    if (partialQuestion.has("marks") && !partialQuestion.has("points")) {
                        partialQuestion.addProperty("points", partialQuestion.get("marks").getAsInt());
                        partialQuestion.remove("marks");
                    }
                    
                    // Convert correctOptionIndex to correctAnswer if needed
                    if (partialQuestion.has("correctOptionIndex") && !partialQuestion.has("correctAnswer")) {
                        int index = partialQuestion.get("correctOptionIndex").getAsInt();
                        char letter = (char)('A' + index);
                        partialQuestion.addProperty("correctAnswer", String.valueOf(letter));
                        partialQuestion.remove("correctOptionIndex");
                    }
                    
                    // Add modification timestamp
                    partialQuestion.addProperty("modifiedAt", currentDateTime);
                    
                    boolean questionUpdateSuccess = updateQuestionPartially(partialQuestion);
                    
                    if (questionUpdateSuccess) {
                        JsonObject result = new JsonObject();
                        result.addProperty("success", true);
                        result.addProperty("message", "Question updated successfully");
                        sendJsonResponse(response, result);
                    } else {
                        sendErrorResponse(response, "Failed to update question");
                    }
                    break;
                    
                case "deleteQuestion":
                    // Delete a question
                    questionId = request.getParameter("questionId");
                    examId = request.getParameter("examId"); // Needed to update the exam's question references
                    
                    if (questionId == null || questionId.isEmpty()) {
                        sendErrorResponse(response, "Question ID is required");
                        return;
                    }
                    
                    System.out.println("Deleting question with ID: " + questionId + " from exam: " + examId);
                    boolean questionDeleteSuccess = deleteQuestion(questionId, examId);
                    
                    if (questionDeleteSuccess) {
                        JsonObject result = new JsonObject();
                        result.addProperty("success", true);
                        result.addProperty("message", "Question deleted successfully");
                        sendJsonResponse(response, result);
                    } else {
                        sendErrorResponse(response, "Failed to delete question");
                    }
                    break;
                    
                case "addQuestion":
                    // Add a new question
                    String newQuestionData = request.getParameter("questionData");
                    String associatedExamId = request.getParameter("examId");
                    
                    if (newQuestionData == null || newQuestionData.isEmpty() || associatedExamId == null || associatedExamId.isEmpty()) {
                        sendErrorResponse(response, "Question data and exam ID are required");
                        return;
                    }
                    
                    System.out.println("Adding new question with data: " + newQuestionData);
                    JsonObject newQuestion = gson.fromJson(newQuestionData, JsonObject.class);
                    
                    // Format the question properly (eliminate duplicate fields)
                    normalizeQuestionFormat(newQuestion, request);
                    
                    boolean addSuccess = addQuestionToExam(newQuestion, associatedExamId);
                    
                    if (addSuccess) {
                        JsonObject result = new JsonObject();
                        result.addProperty("success", true);
                        result.addProperty("message", "Question added successfully");
                        sendJsonResponse(response, result);
                    } else {
                        sendErrorResponse(response, "Failed to add question");
                    }
                    break;
                    
                default:
                    sendErrorResponse(response, "Unknown action: " + action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error processing request: " + e.getMessage());
        }
    }
    
    /**
     * Normalize question format to remove duplicate fields and ensure proper order
     * This creates a new JsonObject with fields in the desired order
     */
    private void normalizeQuestionFormat(JsonObject question, HttpServletRequest request) {
        // Get current data from request if available
        String currentUserId = request != null ? getCurrentUserId(request) : DEFAULT_USER_ID;
        String currentDateTime = request != null ? getCurrentDateTime(request) : DEFAULT_DATETIME;
        
        // Create a new JsonObject with fields in the desired order
        JsonObject normalizedQuestion = new JsonObject();
        
        // 1. questionId
        String questionId = extractValue(question, "questionId", "id", null);
        if (questionId != null) {
            normalizedQuestion.addProperty("questionId", questionId);
        }
        
        // 2. questionText
        String questionText = extractValue(question, "questionText", "text", null);
        if (questionText != null) {
            normalizedQuestion.addProperty("questionText", questionText);
        }
        
        // 3. courseId
        String courseId = extractValue(question, "courseId", null, null);
        if (courseId != null) {
            normalizedQuestion.addProperty("courseId", courseId);
        }
        
        // 4. questionType
        String questionType = extractValue(question, "questionType", "type", null);
        if (questionType != null) {
            normalizedQuestion.addProperty("questionType", questionType);
        }
        
        // 5. difficultyLevel
        Integer difficultyLevel = extractIntValue(question, "difficultyLevel", null, 2);
        normalizedQuestion.addProperty("difficultyLevel", difficultyLevel);
        
        // 6. points
        Integer points = extractIntValue(question, "points", "marks", 5);
        normalizedQuestion.addProperty("points", points);
        
        // 7. options array
        if (question.has("options")) {
            normalizedQuestion.add("options", question.get("options"));
        }
        
        // 8. correctAnswer (or convert from correctOptionIndex if needed)
        String correctAnswer = null;
        if (question.has("correctAnswer")) {
            correctAnswer = question.get("correctAnswer").getAsString();
        } else if (question.has("correctOptionIndex") && questionType != null && 
                  questionType.equals("multiple_choice")) {
            int index = question.get("correctOptionIndex").getAsInt();
            correctAnswer = String.valueOf((char)('A' + index));
        }
        
        if (correctAnswer != null) {
            normalizedQuestion.addProperty("correctAnswer", correctAnswer);
        }
        
        // 9. createdBy
        String createdBy = extractValue(question, "createdBy", null, currentUserId);
        normalizedQuestion.addProperty("createdBy", createdBy);
        
        // 10. createdAt
        String createdAt = extractValue(question, "createdAt", null, currentDateTime);
        normalizedQuestion.addProperty("createdAt", createdAt);
        
        // 11. modifiedAt
        normalizedQuestion.addProperty("modifiedAt", currentDateTime);
        
        // 12. active
        Boolean active = extractBooleanValue(question, "active", null, true);
        normalizedQuestion.addProperty("active", active);
        
        // Copy all properties from normalized question to the original question
        // First, clear all properties from the original question
        for (String key : new HashSet<>(question.keySet())) {
            question.remove(key);
        }
        
        // Then add all properties from the normalized question
        for (String key : normalizedQuestion.keySet()) {
            question.add(key, normalizedQuestion.get(key));
        }
    }
    
    /**
     * Helper method to extract a string value from a JsonObject with fallbacks
     */
    private String extractValue(JsonObject json, String primaryKey, String fallbackKey, String defaultValue) {
        if (json.has(primaryKey)) {
            return json.get(primaryKey).getAsString();
        } else if (fallbackKey != null && json.has(fallbackKey)) {
            return json.get(fallbackKey).getAsString();
        } else {
            return defaultValue;
        }
    }
    
    /**
     * Helper method to extract an integer value from a JsonObject with fallbacks
     */
    private Integer extractIntValue(JsonObject json, String primaryKey, String fallbackKey, Integer defaultValue) {
        if (json.has(primaryKey)) {
            return json.get(primaryKey).getAsInt();
        } else if (fallbackKey != null && json.has(fallbackKey)) {
            return json.get(fallbackKey).getAsInt();
        } else {
            return defaultValue;
        }
    }
    
    /**
     * Helper method to extract a boolean value from a JsonObject with fallbacks
     */
    private Boolean extractBooleanValue(JsonObject json, String primaryKey, String fallbackKey, Boolean defaultValue) {
        if (json.has(primaryKey)) {
            return json.get(primaryKey).getAsBoolean();
        } else if (fallbackKey != null && json.has(fallbackKey)) {
            return json.get(fallbackKey).getAsBoolean();
        } else {
            return defaultValue;
        }
    }
    
    /**
     * Adds a new question to both questions.json and updates the exam's question list
     * @param newQuestion The new question data
     * @param examId The ID of the exam to add the question to
     * @return true if successful, false otherwise
     */
    private boolean addQuestionToExam(JsonObject newQuestion, String examId) {
        // First make sure we have an ID
        String questionId = null;
        if (newQuestion.has("questionId")) {
            questionId = newQuestion.get("questionId").getAsString();
        } else if (newQuestion.has("id")) {
            questionId = newQuestion.get("id").getAsString();
            // Normalize to use questionId only
            newQuestion.addProperty("questionId", questionId);
            newQuestion.remove("id");
        } else {
            System.out.println("New question is missing questionId/id");
            return false;
        }
        
        // Convert correctOptionIndex to correctAnswer if needed
        if (newQuestion.has("correctOptionIndex") && !newQuestion.has("correctAnswer")) {
            if (newQuestion.has("questionType") && newQuestion.get("questionType").getAsString().equals("multiple_choice")) {
                int index = newQuestion.get("correctOptionIndex").getAsInt();
                char letter = (char)('A' + index);
                newQuestion.addProperty("correctAnswer", String.valueOf(letter));
                newQuestion.remove("correctOptionIndex");
            }
        }
        
        // First add the question to the questions.json file
        List<JsonObject> allQuestions = loadQuestions();
        
        // Add metadata if missing
        if (!newQuestion.has("createdBy")) {
            newQuestion.addProperty("createdBy", DEFAULT_USER_ID);
        }
        if (!newQuestion.has("createdAt")) {
            newQuestion.addProperty("createdAt", DEFAULT_DATETIME);
        }
        if (!newQuestion.has("modifiedAt")) {
            newQuestion.addProperty("modifiedAt", DEFAULT_DATETIME);
        }
        if (!newQuestion.has("active")) {
            newQuestion.addProperty("active", true);
        }
        
        // Add the new question to the list and save
        allQuestions.add(newQuestion);
        boolean questionAdded = saveQuestions(allQuestions);
        
        if (!questionAdded) {
            System.out.println("Failed to save new question to questions.json");
            return false;
        }
        
        // Now update the exam's questions array
        JsonObject exam = getExamById(examId);
        if (exam == null) {
            System.out.println("Could not find exam: " + examId);
            return false;
        }
        
        // Get the current questions array or create a new one
        JsonArray questions;
        if (exam.has("questions")) {
            questions = exam.getAsJsonArray("questions");
        } else {
            questions = new JsonArray();
        }
        
        // Add the new question ID
        questions.add(questionId);
        
        // Update the exam
        exam.add("questions", questions);
        
        // Save the updated exam
        boolean examUpdated = updateExam(exam);
        
        if (!examUpdated) {
            System.out.println("Failed to update exam with new question");
            return false;
        }
        
        System.out.println("Successfully added question " + questionId + " to exam " + examId);
        return true;
    }

    /**
     * Updates only specific fields of a question, preserving the rest
     * @param partialQuestion JSON object containing only the fields to update
     * @return true if successful, false otherwise
     */
    private boolean updateQuestionPartially(JsonObject partialQuestion) {
        // Get the ID of the question to update
        String questionId = null;
        if (partialQuestion.has("questionId")) {
            questionId = partialQuestion.get("questionId").getAsString();
        } else if (partialQuestion.has("id")) {
            questionId = partialQuestion.get("id").getAsString();
            // Normalize to use questionId
            partialQuestion.addProperty("questionId", questionId);
            partialQuestion.remove("id");
        }
        
        if (questionId == null) {
            return false;
        }
        
        List<JsonObject> questionList = loadQuestions();
        JsonObject existingQuestion = null;
        boolean found = false;
        
        // Find the existing question
        for (JsonObject question : questionList) {
            if (question != null) {
                String currentId = null;
                if (question.has("questionId")) {
                    currentId = question.get("questionId").getAsString();
                }
                
                if (currentId != null && currentId.equals(questionId)) {
                    existingQuestion = question;
                    found = true;
                    break;
                }
            }
        }
        
        // If found, update only the fields provided in partialQuestion
        if (found) {
            System.out.println("Found question to update: " + questionId);
            
            // Log original question for debugging
            System.out.println("Original question: " + gson.toJson(existingQuestion));
            
            // Format conversion if needed - normalize fields
            normalizeQuestionFormat(partialQuestion, null);
            
            // Update only the fields that are specified in the partial question
            for (Map.Entry<String, JsonElement> entry : partialQuestion.entrySet()) {
                String key = entry.getKey();
                JsonElement value = entry.getValue();
                
                // Don't update ID fields or examId
                if (!key.equals("questionId") && !key.equals("examId")) {
                    existingQuestion.add(key, value);
                    System.out.println("Updating field: " + key + " with value: " + value);
                }
            }
            
            // Always update modifiedAt
            existingQuestion.addProperty("modifiedAt", DEFAULT_DATETIME);
            
            // Ensure proper field order
            normalizeQuestionFormat(existingQuestion, null);
            
            // Log updated question
            System.out.println("Updated question: " + gson.toJson(existingQuestion));
            
            return saveQuestions(questionList);
        } else {
            // If question doesn't exist, create a new one with proper structure
            System.out.println("Creating new question with ID: " + questionId);
            
            // Normalize the question format
            normalizeQuestionFormat(partialQuestion, null);
            
            // Add metadata
            if (!partialQuestion.has("createdBy")) {
                partialQuestion.addProperty("createdBy", DEFAULT_USER_ID);
            }
            
            if (!partialQuestion.has("createdAt")) {
                partialQuestion.addProperty("createdAt", DEFAULT_DATETIME);
            }
            
            partialQuestion.addProperty("modifiedAt", DEFAULT_DATETIME);
            
            if (!partialQuestion.has("active")) {
                partialQuestion.addProperty("active", true);
            }
            
            // Add difficulty if not present
            if (!partialQuestion.has("difficultyLevel")) {
                partialQuestion.addProperty("difficultyLevel", 2);
            }
            
            questionList.add(partialQuestion);
            return saveQuestions(questionList);
        }
    }

    /**
     * Loads all exams from the JSON file
     * @param userId Optional user ID to filter exams
     * @return List of exams as JsonObjects
     */
    private List<JsonObject> loadExams(String userId) {
        List<JsonObject> examList = new ArrayList<>();
        File file = new File(EXAMS_FILE_PATH);
        
        if (file.exists() && file.canRead()) {
            try (FileReader reader = new FileReader(file)) {
                try {
                    JsonArray jsonArray = JsonParser.parseReader(reader).getAsJsonArray();
                    
                    for (JsonElement element : jsonArray) {
                        examList.add(element.getAsJsonObject());
                    }
                    
                    System.out.println("Successfully loaded " + examList.size() + " exams from file");
                    
                    // If userId is provided, filter exams by that user
                    if (userId != null && !userId.isEmpty()) {
                        List<JsonObject> filteredList = new ArrayList<>();
                        for (JsonObject exam : examList) {
                            if (exam.has("createdBy") && exam.get("createdBy").getAsString().equals(userId)) {
                                filteredList.add(exam);
                            }
                        }
                        System.out.println("Filtered to " + filteredList.size() + " exams for user " + userId);
                        return filteredList;
                    }
                } catch (Exception e) {
                    System.out.println("Error parsing exams file: " + e.getMessage());
                    e.printStackTrace();
                    
                    // In case of error or empty file, create a sample exam for testing
                    if (examList.isEmpty()) {
                        System.out.println("Creating sample exams due to error or empty file");
                        examList = createSampleExams(userId);
                        saveExams(examList);
                    }
                }
            } catch (IOException e) {
                System.out.println("Error reading exams file: " + e.getMessage());
                e.printStackTrace();
                
                // In case of error, create sample data
                examList = createSampleExams(userId);
                saveExams(examList);
            }
        } else {
            System.out.println("Exams file doesn't exist or can't be read. Creating sample data.");
            examList = createSampleExams(userId);
            saveExams(examList);
        }
        
        return examList;
    }
    
    /**
     * Creates sample exam data for testing
     * @param userId The user ID to associate with the exams
     * @return List of sample exams
     */
    private List<JsonObject> createSampleExams(String userId) {
        List<JsonObject> sampleExams = new ArrayList<>();
        
        // Create course data
        String[][] courses = {
            {"CSE303", "Database Management Systems"},
            {"CSE405", "Computer Networks"},
            {"ECE202", "Digital Electronics"},
            {"CSE201", "Object Oriented Programming"}
        };
        
        // Create sample exams
        for (int i = 0; i < 5; i++) {
            JsonObject exam = new JsonObject();
            
            // Choose a random course
            int courseIndex = (int)(Math.random() * courses.length);
            
            exam.addProperty("examId", "EX" + (100000 + i));
            exam.addProperty("examName", "Midterm Exam " + (i + 1));
            exam.addProperty("courseId", courses[courseIndex][0]);
            exam.addProperty("description", "This exam covers all topics from module 1 to module " + (3 + i) + 
                ". Students should be prepared to answer both theoretical and practical questions.");
            
            // Add exam metadata
            exam.addProperty("duration", (int)(Math.random() * 90) + 30);
            exam.addProperty("totalMarks", (i + 3) * 25);
            exam.addProperty("passingMarks", (i + 3) * 10);
            exam.addProperty("createdBy", userId);
            exam.addProperty("createdAt", DEFAULT_DATETIME);
            exam.addProperty("startDate", "2025-04-" + (10 + i) + "T10:00:00Z");
            
            // Add questions array
            JsonArray questionsArray = new JsonArray();
            int questionCount = (int)(Math.random() * 5) + 5; // 5-10 questions
            
            for (int j = 1; j <= questionCount; j++) {
                questionsArray.add("q" + (i * 100 + j));
            }
            
            exam.add("questions", questionsArray);
            
            // Add settings
            JsonObject settings = new JsonObject();
            settings.addProperty("shuffleQuestions", i % 2 == 0);
            settings.addProperty("shuffleOptions", i % 2 == 0);
            settings.addProperty("showResults", i % 3 == 0);
            settings.addProperty("allowReview", i % 3 == 1);
            settings.addProperty("preventBacktracking", i % 3 == 2);
            settings.addProperty("requireWebcam", i % 4 == 0);
            settings.addProperty("limitAttempts", i % 2 == 1);
            settings.addProperty("maxAttempts", i % 3 + 1);
            
            exam.add("settings", settings);
            
            // Add status randomly
            String[] statuses = {"published", "draft", "pending", "closed"};
            int statusIndex = (int)(Math.random() * statuses.length);
            exam.addProperty("status", statuses[statusIndex]);
            
            sampleExams.add(exam);
        }
        
        System.out.println("Created " + sampleExams.size() + " sample exams");
        return sampleExams;
    }

    /**
     * Gets an exam by its ID
     * @param examId Exam ID to find
     * @return Exam as JsonObject or null if not found
     */
    private JsonObject getExamById(String examId) {
        List<JsonObject> examList = loadExams(null);
        
        for (JsonObject exam : examList) {
            if (exam.has("examId") && exam.get("examId").getAsString().equals(examId)) {
                return exam;
            }
        }
        
        return null;
    }

    /**
     * Updates an exam in the JSON file
     * @param updatedExam Updated exam data
     * @return true if successful, false otherwise
     */
    private boolean updateExam(JsonObject updatedExam) {
        if (!updatedExam.has("examId")) {
            return false;
        }
        
        String examId = updatedExam.get("examId").getAsString();
        List<JsonObject> examList = loadExams(null);
        boolean updated = false;
        
        // Find and update the existing exam
        for (int i = 0; i < examList.size(); i++) {
            JsonObject exam = examList.get(i);
            if (exam.has("examId") && exam.get("examId").getAsString().equals(examId)) {
                // Preserve the questions array if it's not in the updated exam
                if (!updatedExam.has("questions") && exam.has("questions")) {
                    updatedExam.add("questions", exam.get("questions"));
                }
                
                // Make sure we preserve the createdBy and createdAt fields
                if (!updatedExam.has("createdBy") && exam.has("createdBy")) {
                    updatedExam.addProperty("createdBy", exam.get("createdBy").getAsString());
                }
                
                if (!updatedExam.has("createdAt") && exam.has("createdAt")) {
                    updatedExam.addProperty("createdAt", exam.get("createdAt").getAsString());
                }
                
                examList.set(i, updatedExam);
                updated = true;
                break;
            }
        }
        
        // If exam doesn't exist, add it
        if (!updated) {
            examList.add(updatedExam);
            updated = true;
        }
        
        if (updated) {
            return saveExams(examList);
        }
        
        return false;
    }

    /**
     * Deletes an exam from the JSON file
     * @param examId ID of the exam to delete
     * @return true if successful, false otherwise
     */
    private boolean deleteExam(String examId) {
        List<JsonObject> examList = loadExams(null);
        int initialSize = examList.size();
        
        // Find the exam to delete
        JsonObject examToDelete = null;
        for (JsonObject exam : examList) {
            if (exam.has("examId") && exam.get("examId").getAsString().equals(examId)) {
                examToDelete = exam;
                break;
            }
        }
        
        if (examToDelete != null) {
            // If the exam has questions, also delete the questions
            if (examToDelete.has("questions")) {
                JsonArray questionIdsArray = examToDelete.getAsJsonArray("questions");
                for (JsonElement element : questionIdsArray) {
                    String questionId = element.getAsString();
                    deleteQuestion(questionId, null); // null examId because we're already deleting the exam
                }
            }
            
            // Remove the exam from the list
            examList.remove(examToDelete);
            
            // Save the updated list
            if (examList.size() < initialSize) {
                return saveExams(examList);
            }
        }
        
        return false;
    }

    /**
     * Loads all questions from the JSON file
     * @return List of questions as JsonObjects
     */
    private List<JsonObject> loadQuestions() {
        List<JsonObject> questionList = new ArrayList<>();
        File file = new File(QUESTIONS_FILE_PATH);
        
        if (file.exists() && file.canRead() && file.length() > 0) {
            try (FileReader reader = new FileReader(file)) {
                try {
                    JsonElement jsonElement = JsonParser.parseReader(reader);
                    
                    // If it's an array, process it
                    if (jsonElement.isJsonArray()) {
                        JsonArray jsonArray = jsonElement.getAsJsonArray();
                        
                        for (JsonElement element : jsonArray) {
                            if (element.isJsonObject()) {
                                JsonObject question = element.getAsJsonObject();
                                
                                // Convert correctOptionIndex to correctAnswer if needed
                                if (question.has("correctOptionIndex") && !question.has("correctAnswer")) {
                                    if (question.has("questionType") && question.get("questionType").getAsString().equals("multiple_choice")) {
                                        int index = question.get("correctOptionIndex").getAsInt();
                                        char letter = (char)('A' + index);
                                        question.addProperty("correctAnswer", String.valueOf(letter));
                                        question.remove("correctOptionIndex");
                                    }
                                }
                                
                                // Ensure the fields are in the right order
                                normalizeQuestionFormat(question, null);
                                
                                questionList.add(question);
                            }
                        }
                        
                        System.out.println("Successfully loaded " + questionList.size() + " questions from file");
                    } else {
                        System.out.println("Warning: Questions file exists but is not a valid JSON array");
                    }
                } catch (Exception e) {
                    System.out.println("Error parsing questions file: " + e.getMessage());
                    e.printStackTrace();
                }
            } catch (IOException e) {
                System.out.println("Error reading questions file: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("Questions file doesn't exist, can't be read, or is empty.");
            
            // Create the directory if it doesn't exist
            File parentDir = file.getParentFile();
            if (parentDir != null && !parentDir.exists()) {
                parentDir.mkdirs();
            }
            
            // Create an empty array in the file if it doesn't exist
            if (!file.exists() || file.length() == 0) {
                try (FileWriter writer = new FileWriter(file)) {
                    writer.write("[]");
                    System.out.println("Created empty questions file");
                } catch (IOException e) {
                    System.out.println("Error creating questions file: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }
        
        return questionList;
    }

    /**
     * Deletes a question from the JSON file and optionally updates the exam
     * @param questionId ID of the question to delete
     * @param examId ID of the exam containing the question (can be null)
     * @return true if successful, false otherwise
     */
    private boolean deleteQuestion(String questionId, String examId) {
        // First delete the question from the questions file
        List<JsonObject> questionList = loadQuestions();
        int initialSize = questionList.size();
        
        questionList.removeIf(question -> 
            question != null && question.has("questionId") && 
            question.get("questionId").getAsString().equals(questionId)
        );
        
        boolean questionDeleted = questionList.size() < initialSize && saveQuestions(questionList);
        
        // If an examId is provided, we also need to update the exam
        if (examId != null && !examId.isEmpty()) {
            JsonObject exam = getExamById(examId);
            
            if (exam != null && exam.has("questions")) {
                // Get the current questions array
                JsonArray questionsArray = exam.getAsJsonArray("questions");
                
                // Create a new array without the deleted question
                JsonArray newQuestionsArray = new JsonArray();
                for (JsonElement element : questionsArray) {
                    if (!element.getAsString().equals(questionId)) {
                        newQuestionsArray.add(element);
                    }
                }
                
                // Update the exam with the new array
                exam.add("questions", newQuestionsArray);
                
                return updateExam(exam);
            }
        }
        
        return questionDeleted;
    }

    /**
     * Saves exams to the JSON file
     * @param examList List of exams to save
     * @return true if successful, false otherwise
     */
    private boolean saveExams(List<JsonObject> examList) {
        File file = new File(EXAMS_FILE_PATH);
        
        // Create directory if it doesn't exist
        File parentDir = file.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            parentDir.mkdirs();
        }
        
        try (FileWriter writer = new FileWriter(file)) {
            gson.toJson(examList, writer);
            System.out.println("Successfully saved " + examList.size() + " exams to file");
            return true;
        } catch (IOException e) {
            System.out.println("Error saving exams: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Saves questions to the JSON file
     * @param questionList List of questions to save
     * @return true if successful, false otherwise
     */
    private boolean saveQuestions(List<JsonObject> questionList) {
        File file = new File(QUESTIONS_FILE_PATH);
        
        // Create directory if it doesn't exist
        File parentDir = file.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            parentDir.mkdirs();
        }
        
        // Ensure all questions have the proper field order
        List<JsonObject> orderedQuestions = new ArrayList<>();
        for (JsonObject question : questionList) {
            // Create a copy of the question to normalize
            JsonObject normalizedQuestion = new JsonObject();
            for (Map.Entry<String, JsonElement> entry : question.entrySet()) {
                normalizedQuestion.add(entry.getKey(), entry.getValue());
            }
            
            // Ensure proper field order
            normalizeQuestionFormat(normalizedQuestion, null);
            orderedQuestions.add(normalizedQuestion);
        }
        
        try (FileWriter writer = new FileWriter(file)) {
            gson.toJson(orderedQuestions, writer);
            System.out.println("Successfully saved " + questionList.size() + " questions to file");
            return true;
        } catch (IOException e) {
            System.out.println("Error saving questions: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Sends a JSON response
     * @param response HttpServletResponse object
     * @param data Data to send
     * @throws IOException If there's an error writing to the response
     */
    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(data));
            out.flush();
        }
    }

    /**
     * Sends an error response
     * @param response HttpServletResponse object
     * @param errorMessage Error message to send
     * @throws IOException If there's an error writing to the response
     */
    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
        JsonObject error = new JsonObject();
        error.addProperty("success", false);
        error.addProperty("message", errorMessage);
        sendJsonResponse(response, error);
    }
}