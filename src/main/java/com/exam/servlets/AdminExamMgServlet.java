package com.exam.servlets;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
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

/**
 * Admin Servlet for managing all exams and questions
 */
@WebServlet("/AdminExamMgServlet")
public class AdminExamMgServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // File paths - will be initialized in init()
    private String EXAMS_FILE_PATH;
    private String QUESTIONS_FILE_PATH;
    private String USERS_FILE_PATH;

    // Gson instance for JSON operations
    private final Gson gson = new GsonBuilder()
        .setPrettyPrinting()
        .create();

    @Override
    public void init() throws ServletException {
        super.init();

        // Initialize file paths relative to webapp root
        EXAMS_FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\exams.json";
        QUESTIONS_FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\questions.json";
        USERS_FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\users.json";

        System.out.println("AdminExamMgServlet initialized");
        System.out.println("Exams file path: " + EXAMS_FILE_PATH);
        System.out.println("Questions file path: " + QUESTIONS_FILE_PATH);
        System.out.println("Users file path: " + USERS_FILE_PATH);

        // Ensure data directories exist
        ensureDirectoriesExist();
    }

    /**
     * Make sure all required directories exist
     */
    private void ensureDirectoriesExist() {
        File examsFile = new File(EXAMS_FILE_PATH);
        File questionsFile = new File(QUESTIONS_FILE_PATH);
        File usersFile = new File(USERS_FILE_PATH);

        File examsDir = examsFile.getParentFile();
        if (examsDir != null && !examsDir.exists()) {
            examsDir.mkdirs();
        }

        File questionsDir = questionsFile.getParentFile();
        if (questionsDir != null && !questionsDir.exists()) {
            questionsDir.mkdirs();
        }

        File usersDir = usersFile.getParentFile();
        if (usersDir != null && !usersDir.exists()) {
            usersDir.mkdirs();
        }

        // If the files don't exist, create empty arrays
        initializeEmptyFileIfNotExists(EXAMS_FILE_PATH);
        initializeEmptyFileIfNotExists(QUESTIONS_FILE_PATH);
        initializeEmptyFileIfNotExists(USERS_FILE_PATH);
    }

    /**
     * Initialize an empty JSON array file if it doesn't exist
     */
    private void initializeEmptyFileIfNotExists(String filePath) {
        File file = new File(filePath);
        if (!file.exists()) {
            try (FileWriter writer = new FileWriter(file)) {
                writer.write("[]");
                System.out.println("Created empty JSON array file at: " + filePath);
            } catch (IOException e) {
                System.out.println("Error creating empty file: " + e.getMessage());
            }
        }
    }

    /**
     * Handles GET requests
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("AdminExamMgServlet: doGet called with action=" + request.getParameter("action"));

        // Update path variables based on current request context
        updatePathsForRequest(request);

        // Get current user ID
        HttpSession session = request.getSession();
        String currentUserId = (String) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");

        // For testing purposes - in production these would come from the session
        if (currentUserId == null) {
            currentUserId = request.getParameter("userId");
            if (currentUserId == null) {
                currentUserId = "IT24102083"; // Default for testing
            }
        }

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

                    System.out.println("Getting exam with ID: " + examId);
                    JsonObject exam = getExamById(examId);
                    if (exam == null) {
                        sendErrorResponse(response, "Exam not found with ID: " + examId);
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
                // Load all exams
                List<JsonObject> exams = loadExams();

                // Load questions for each exam
                Map<String, List<JsonObject>> questionsByExam = new HashMap<>();
                for (JsonObject exam : exams) {
                    if (exam.has("examId")) {
                        String examId = exam.get("examId").getAsString();
                        List<JsonObject> questions = getQuestionsForExam(examId);
                        questionsByExam.put(examId, questions);
                    }
                }

                // Get user information
                Map<String, JsonObject> userMap = loadUsers();

                // Get statistics
                Map<String, Integer> stats = calculateStats(exams);

                // Set attributes for the JSP
                request.setAttribute("exams", exams);
                request.setAttribute("questionsByExam", questionsByExam);
                request.setAttribute("userMap", userMap);
                request.setAttribute("stats", stats);
                request.setAttribute("currentUserId", currentUserId);

                // Forward to the JSP
                request.getRequestDispatcher("adminExamMg.jsp").forward(request, response);

            } catch (Exception e) {
                System.out.println("Error in doGet: " + e.getMessage());
                e.printStackTrace();

                request.setAttribute("error", "Failed to load exam data: " + e.getMessage());
                request.getRequestDispatcher("adminExamMg.jsp").forward(request, response);
            }
        }
    }

    /**
     * Update file paths based on current request context
     */
    private void updatePathsForRequest(HttpServletRequest request) {
        // Get real path relative to context path
    	EXAMS_FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\exams.json";
        QUESTIONS_FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\questions.json";
        USERS_FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\users.json";

    }

    /**
     * Calculate statistics
     */
    private Map<String, Integer> calculateStats(List<JsonObject> exams) {
        Map<String, Integer> stats = new HashMap<>();

        int totalExams = exams.size();
        int publishedExams = 0;
        int draftExams = 0;
        int pendingExams = 0;
        int closedExams = 0;

        Set<String> teachers = new HashSet<>();
        Set<String> courses = new HashSet<>();

        for (JsonObject exam : exams) {
            // Count by status
            if (exam.has("status")) {
                String status = exam.get("status").getAsString();
                if ("published".equals(status)) publishedExams++;
                else if ("draft".equals(status)) draftExams++;
                else if ("pending".equals(status)) pendingExams++;
                else if ("closed".equals(status)) closedExams++;
            }

            // Count unique teachers
            if (exam.has("createdBy")) {
                teachers.add(exam.get("createdBy").getAsString());
            }

            // Count unique courses
            if (exam.has("courseId")) {
                courses.add(exam.get("courseId").getAsString());
            }
        }

        stats.put("totalExams", totalExams);
        stats.put("publishedExams", publishedExams);
        stats.put("draftExams", draftExams);
        stats.put("pendingExams", pendingExams);
        stats.put("closedExams", closedExams);
        stats.put("instructorCount", teachers.size());
        stats.put("courseCount", courses.size());

        return stats;
    }

    /**
     * Load users from JSON file
     */
    private Map<String, JsonObject> loadUsers() {
        Map<String, JsonObject> userMap = new HashMap<>();
        File file = new File(USERS_FILE_PATH);

        if (file.exists() && file.canRead()) {
            try (FileReader reader = new FileReader(file)) {
                try {
                    JsonArray jsonArray = JsonParser.parseReader(reader).getAsJsonArray();

                    for (JsonElement element : jsonArray) {
                        JsonObject user = element.getAsJsonObject();
                        if (user.has("userId")) {
                            userMap.put(user.get("userId").getAsString(), user);
                        }
                    }
                } catch (Exception e) {
                    System.out.println("Error parsing users file: " + e.getMessage());
                }
            } catch (IOException e) {
                System.out.println("Error reading users file: " + e.getMessage());
            }
        }

        return userMap;
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
     * Gets questions for a specific exam
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

        return questions;
    }

    /**
     * Handles POST requests
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("AdminExamMgServlet: doPost called with action=" + request.getParameter("action"));

        // Update path variables based on current request context
        updatePathsForRequest(request);

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

                    System.out.println("Received exam data: " + examData);
                    JsonObject updatedExam = gson.fromJson(examData, JsonObject.class);

                    // Ensure the exam has an ID
                    if (!updatedExam.has("examId")) {
                        sendErrorResponse(response, "Exam data must include examId");
                        return;
                    }

                    // Update modifiedAt timestamp
                    updatedExam.addProperty("modifiedAt", java.time.LocalDateTime.now().toString());

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

                    // Now attempt to delete it
                    boolean deleteSuccess = deleteExam(examId);

                    if (deleteSuccess) {
                        JsonObject result = new JsonObject();
                        result.addProperty("success", true);
                        result.addProperty("message", "Exam deleted successfully");
                        sendJsonResponse(response, result);
                    } else {
                        sendErrorResponse(response, "Failed to delete exam. Please check server logs.");
                    }
                    break;

                case "updateQuestion":
                    // Update a question
                    String questionData = request.getParameter("questionData");
                    if (questionData == null || questionData.isEmpty()) {
                        sendErrorResponse(response, "Question data is required");
                        return;
                    }

                    JsonObject updatedQuestion = gson.fromJson(questionData, JsonObject.class);

                    // Update timestamp
                    updatedQuestion.addProperty("modifiedAt", java.time.LocalDateTime.now().toString());

                    boolean questionUpdateSuccess = updateQuestion(updatedQuestion);

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
                    String questionId = request.getParameter("questionId");
                    String associatedExamId = request.getParameter("examId");

                    if (questionId == null || questionId.isEmpty()) {
                        sendErrorResponse(response, "Question ID is required");
                        return;
                    }

                    // Now attempt to delete it
                    boolean questionDeleteSuccess = deleteQuestion(questionId, associatedExamId);

                    if (questionDeleteSuccess) {
                        JsonObject result = new JsonObject();
                        result.addProperty("success", true);
                        result.addProperty("message", "Question deleted successfully");
                        sendJsonResponse(response, result);
                    } else {
                        sendErrorResponse(response, "Failed to delete question. Please check server logs.");
                    }
                    break;

                case "addQuestion":
                    // Add a new question
                    String newQuestionData = request.getParameter("questionData");
                    String examIdForQuestion = request.getParameter("examId");

                    if (newQuestionData == null || newQuestionData.isEmpty() || examIdForQuestion == null || examIdForQuestion.isEmpty()) {
                        sendErrorResponse(response, "Question data and exam ID are required");
                        return;
                    }

                    JsonObject newQuestion = gson.fromJson(newQuestionData, JsonObject.class);

                    boolean addSuccess = addQuestionToExam(newQuestion, examIdForQuestion);

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
     * Adds a new question to an exam
     */
    private boolean addQuestionToExam(JsonObject newQuestion, String examId) {
        // First make sure we have an ID
        String questionId = null;
        if (newQuestion.has("questionId")) {
            questionId = newQuestion.get("questionId").getAsString();
        } else {
            questionId = "q" + System.currentTimeMillis();
            newQuestion.addProperty("questionId", questionId);
        }

        // First add the question to the questions.json file
        List<JsonObject> allQuestions = loadQuestions();

        // Add metadata if missing
        HttpSession session = getServletContext().getSessionManager().findSession(getServletContext().getSessionCookieConfig().getName());
        String currentUserId = "admin";
        if (session != null) {
            String userId = (String) session.getAttribute("userId");
            if (userId != null) {
                currentUserId = userId;
            }
        }

        if (!newQuestion.has("createdBy")) {
            newQuestion.addProperty("createdBy", currentUserId);
        }

        String currentTime = java.time.LocalDateTime.now().toString();
        if (!newQuestion.has("createdAt")) {
            newQuestion.addProperty("createdAt", currentTime);
        }
        if (!newQuestion.has("modifiedAt")) {
            newQuestion.addProperty("modifiedAt", currentTime);
        }

        // Add the new question to the list and save
        allQuestions.add(newQuestion);
        boolean questionAdded = saveQuestions(allQuestions);

        if (!questionAdded) {
            return false;
        }

        // Now update the exam's questions array
        JsonObject exam = getExamById(examId);
        if (exam == null) {
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
        return updateExam(exam);
    }

    /**
     * Updates a question
     */
    private boolean updateQuestion(JsonObject updatedQuestion) {
        if (!updatedQuestion.has("questionId")) {
            return false;
        }

        String questionId = updatedQuestion.get("questionId").getAsString();
        List<JsonObject> questionList = loadQuestions();
        boolean found = false;

        // Find and update the existing question
        for (int i = 0; i < questionList.size(); i++) {
            JsonObject question = questionList.get(i);
            if (question.has("questionId") && question.get("questionId").getAsString().equals(questionId)) {
                questionList.set(i, updatedQuestion);
                found = true;
                break;
            }
        }

        // If not found, add as new
        if (!found) {
            questionList.add(updatedQuestion);
        }

        // Save the updated list
        return saveQuestions(questionList);
    }

    /**
     * Load all exams from the JSON file
     */
    private List<JsonObject> loadExams() {
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
                } catch (Exception e) {
                    System.out.println("Error parsing exams file: " + e.getMessage());
                }
            } catch (IOException e) {
                System.out.println("Error reading exams file: " + e.getMessage());
            }
        }

        return examList;
    }

    /**
     * Load questions from JSON file
     */
    private List<JsonObject> loadQuestions() {
        List<JsonObject> questionList = new ArrayList<>();
        File file = new File(QUESTIONS_FILE_PATH);

        if (file.exists() && file.canRead()) {
            try (FileReader reader = new FileReader(file)) {
                try {
                    JsonArray jsonArray = JsonParser.parseReader(reader).getAsJsonArray();

                    for (JsonElement element : jsonArray) {
                        questionList.add(element.getAsJsonObject());
                    }

                    System.out.println("Successfully loaded " + questionList.size() + " questions from file");
                } catch (Exception e) {
                    System.out.println("Error parsing questions file: " + e.getMessage());
                }
            } catch (IOException e) {
                System.out.println("Error reading questions file: " + e.getMessage());
            }
        }

        return questionList;
    }

    /**
     * Gets an exam by its ID
     */
    private JsonObject getExamById(String examId) {
        List<JsonObject> examList = loadExams();

        for (JsonObject exam : examList) {
            if (exam.has("examId") && exam.get("examId").getAsString().equals(examId)) {
                return exam;
            }
        }

        return null;
    }

    /**
     * Updates an exam in the JSON file
     */
    private boolean updateExam(JsonObject updatedExam) {
        if (!updatedExam.has("examId")) {
            System.out.println("Error updating exam: examId is missing");
            return false;
        }

        String examId = updatedExam.get("examId").getAsString();
        System.out.println("Updating exam with ID: " + examId);

        List<JsonObject> examList = loadExams();
        boolean updated = false;

        // Find and update the existing exam
        for (int i = 0; i < examList.size(); i++) {
            JsonObject exam = examList.get(i);
            if (exam.has("examId") && exam.get("examId").getAsString().equals(examId)) {
                System.out.println("Found exam to update: " + examId);

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

                // Ensure modifiedAt is set to current time
                updatedExam.addProperty("modifiedAt", java.time.LocalDateTime.now().toString());

                // Replace the exam in the list
                examList.set(i, updatedExam);
                updated = true;
                break;
            }
        }

        // If exam doesn't exist, add it as a new one
        if (!updated) {
            System.out.println("Exam not found, adding new exam with ID: " + examId);

            // Make sure new exams have createdAt timestamps
            if (!updatedExam.has("createdAt")) {
                updatedExam.addProperty("createdAt", java.time.LocalDateTime.now().toString());
            }

            // Make sure modifiedAt is set
            updatedExam.addProperty("modifiedAt", java.time.LocalDateTime.now().toString());

            // Add to the list
            examList.add(updatedExam);
            updated = true;
        }

        // Save the updated list
        if (updated) {
            boolean saved = saveExams(examList);
            if (saved) {
                System.out.println("Successfully saved updated exam: " + examId);
            } else {
                System.out.println("Failed to save updated exam: " + examId);
            }
            return saved;
        }

        System.out.println("Failed to update exam: " + examId);
        return false;
    }

    /**
     * Deletes an exam from the JSON file
     */
    private boolean deleteExam(String examId) {
        System.out.println("Starting delete operation for exam: " + examId);
        List<JsonObject> examList = loadExams();
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
            System.out.println("Found exam to delete: " + examId);

            // If the exam has questions, also delete the questions
            if (examToDelete.has("questions")) {
                JsonArray questionIdsArray = examToDelete.getAsJsonArray("questions");
                for (JsonElement element : questionIdsArray) {
                    String questionId = element.getAsString();
                    System.out.println("Deleting associated question: " + questionId);
                    deleteQuestion(questionId, null); // null examId because we're already deleting the exam
                }
            }

            // Remove the exam from the list
            examList.remove(examToDelete);

            // Save the updated list
            if (examList.size() < initialSize) {
                boolean saved = saveExams(examList);
                if (saved) {
                    System.out.println("Successfully deleted exam: " + examId);
                    return true;
                } else {
                    System.out.println("Failed to save after deleting exam: " + examId);
                }
            }
        } else {
            System.out.println("Exam not found for deletion: " + examId);
        }

        return false;
    }

    /**
     * Deletes a question from the JSON file and optionally updates the exam
     */
    private boolean deleteQuestion(String questionId, String examId) {
        System.out.println("Deleting question: " + questionId + " from exam: " + examId);

        // First delete the question from the questions file
        List<JsonObject> questionList = loadQuestions();
        int initialSize = questionList.size();

        // Remove the question from the list
        questionList.removeIf(question -> 
            question != null && question.has("questionId") && 
            question.get("questionId").getAsString().equals(questionId)
        );

        boolean questionDeleted = questionList.size() < initialSize && saveQuestions(questionList);

        if (questionDeleted) {
            System.out.println("Successfully removed question from questions file: " + questionId);
        } else {
            System.out.println("Failed to remove question or question not found: " + questionId);
        }

        // If an examId is provided, we also need to update the exam
        if (examId != null && !examId.isEmpty()) {
            JsonObject exam = getExamById(examId);

            if (exam != null && exam.has("questions")) {
                System.out.println("Updating exam questions array for exam: " + examId);

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

                boolean examUpdated = updateExam(exam);
                if (examUpdated) {
                    System.out.println("Successfully updated exam questions array after deletion");
                } else {
                    System.out.println("Failed to update exam after question deletion");
                }

                return examUpdated;
            } else {
                System.out.println("Exam not found or doesn't have questions array: " + examId);
            }
        }

        return questionDeleted;
    }

    /**
     * Saves exams to the JSON file
     */
    private boolean saveExams(List<JsonObject> examList) {
        File file = new File(EXAMS_FILE_PATH);

        // Create directory if it doesn't exist
        File parentDir = file.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            boolean created = parentDir.mkdirs();
            if (!created) {
                System.out.println("Failed to create directory: " + parentDir.getAbsolutePath());
                return false;
            }
        }

        try (FileWriter writer = new FileWriter(file)) {
            gson.toJson(examList, writer);
            writer.flush(); // Ensure data is written to disk
            System.out.println("Successfully saved " + examList.size() + " exams to file: " + file.getAbsolutePath());
            return true;
        } catch (IOException e) {
            System.out.println("Error saving exams to " + file.getAbsolutePath() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Saves questions to the JSON file
     */
    private boolean saveQuestions(List<JsonObject> questionList) {
        File file = new File(QUESTIONS_FILE_PATH);

        // Create directory if it doesn't exist
        File parentDir = file.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            boolean created = parentDir.mkdirs();
            if (!created) {
                System.out.println("Failed to create directory: " + parentDir.getAbsolutePath());
                return false;
            }
        }

        try (FileWriter writer = new FileWriter(file)) {
            gson.toJson(questionList, writer);
            writer.flush(); // Ensure data is written to disk
            System.out.println("Successfully saved " + questionList.size() + " questions to file: " + file.getAbsolutePath());
            return true;
        } catch (IOException e) {
            System.out.println("Error saving questions to " + file.getAbsolutePath() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Sends a JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String jsonOutput = gson.toJson(data);
            out.print(jsonOutput);
            out.flush();
        }
    }

    /**
     * Sends an error response
     */
    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
        System.out.println("Error response: " + errorMessage);
        JsonObject error = new JsonObject();
        error.addProperty("success", false);
        error.addProperty("message", errorMessage);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(error));
            out.flush();
        }
    }
}