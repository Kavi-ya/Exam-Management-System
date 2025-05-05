package com.exam.servlets;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
 * Servlet for managing exams - handles exam listing, loading, and submission
 */
@WebServlet(urlPatterns = {"/exams", "/exam/take/*", "/exam/submit"})
public class TakeExamServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Constants for default values
    private static final String DEFAULT_USER_ID = "IT24102083";
    private static final String CURRENT_DATE_TIME = "2025-05-04 09:07:53"; // Updated timestamp
    
    // File paths for JSON data
    private String EXAMS_FILE_PATH;
    private String QUESTIONS_FILE_PATH;
    private String RESULTS_FILE_PATH;
    
    // Gson instance for JSON operations
    private final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    
    // Static linked list to store all student results (maintained across sessions)
    private static ResultsLinkedList allStudentResults = new ResultsLinkedList();
    
    @Override
    public void init() throws ServletException {
        super.init();
        
        // Initialize file paths with real context paths
        String webInfPath = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF";
        EXAMS_FILE_PATH = webInfPath + "/data/exams.json";
        QUESTIONS_FILE_PATH = webInfPath + "/data/questions.json";
        RESULTS_FILE_PATH = webInfPath + "/data/results.json";
        
        // Create directories if they don't exist
        new File(webInfPath + "/data").mkdirs();
        
        // Load existing results from file into the linked list
        loadExistingResultsIntoLinkedList();
    }
    
    /**
     * Load existing results from results.json into the linked list
     */
    private void loadExistingResultsIntoLinkedList() {
        try {
            File file = new File(RESULTS_FILE_PATH);
            if (file.exists() && file.canRead()) {
                FileReader reader = new FileReader(file);
                JsonArray jsonArray = JsonParser.parseReader(reader).getAsJsonArray();
                reader.close();
                
                for (JsonElement element : jsonArray) {
                    JsonObject resultObj = element.getAsJsonObject();
                    
                    // Create result node with data from JSON
                    ResultNode node = new ResultNode();
                    node.resultId = resultObj.has("resultId") ? resultObj.get("resultId").getAsString() : "";
                    node.examId = resultObj.has("examId") ? resultObj.get("examId").getAsString() : "";
                    node.userId = resultObj.has("userId") ? resultObj.get("userId").getAsString() : "";
                    node.submittedAt = resultObj.has("submittedAt") ? resultObj.get("submittedAt").getAsString() : "";
                    node.timeTakenSeconds = resultObj.has("timeTakenSeconds") ? resultObj.get("timeTakenSeconds").getAsInt() : 0;
                    node.score = resultObj.has("score") ? resultObj.get("score").getAsDouble() : 0.0;
                    node.totalPoints = resultObj.has("totalPoints") ? resultObj.get("totalPoints").getAsInt() : 0;
                    node.earnedPoints = resultObj.has("earnedPoints") ? resultObj.get("earnedPoints").getAsInt() : 0;
                    node.passed = resultObj.has("passed") ? resultObj.get("passed").getAsBoolean() : false;
                    
                    // Process answers
                    if (resultObj.has("answers") && resultObj.get("answers").isJsonArray()) {
                        JsonArray answersArray = resultObj.get("answers").getAsJsonArray();
                        node.answers = new ArrayList<>();
                        
                        for (JsonElement answerElement : answersArray) {
                            JsonObject answerObj = answerElement.getAsJsonObject();
                            AnswerNode answer = new AnswerNode();
                            answer.questionId = answerObj.has("questionId") ? answerObj.get("questionId").getAsString() : "";
                            answer.answer = answerObj.has("answer") ? answerObj.get("answer").getAsString() : "";
                            answer.isCorrect = answerObj.has("isCorrect") ? answerObj.get("isCorrect").getAsBoolean() : false;
                            answer.correctAnswer = answerObj.has("correctAnswer") ? answerObj.get("correctAnswer").getAsString() : "";
                            
                            node.answers.add(answer);
                        }
                    }
                    
                    // Add to linked list
                    allStudentResults.addNode(node);
                }
                
                System.out.println("Loaded " + allStudentResults.size() + " results into linked list");
            }
        } catch (Exception e) {
            System.err.println("Error loading existing results into linked list: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Get the current user ID from the session, or use default if not found
     */
    private String getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        
        // Check if user object exists and has userId property
        if (userObj != null) {
            try {
                // Try to access userId using reflection (safe approach)
                java.lang.reflect.Method getUserId = userObj.getClass().getMethod("getUserId");
                Object userIdObj = getUserId.invoke(userObj);
                if (userIdObj != null && !userIdObj.toString().isEmpty()) {
                    return userIdObj.toString();
                }
            } catch (Exception e) {
                // If reflection fails, try direct property access for Map-like objects
                if (userObj instanceof Map) {
                    Object userId = ((Map<?,?>)userObj).get("userId");
                    if (userId != null && !userId.toString().isEmpty()) {
                        return userId.toString();
                    }
                }
                // Log silent reflection error for debugging
                System.out.println("Could not get userId from user object: " + e.getMessage());
            }
        }
        
        return DEFAULT_USER_ID; // Return default if no user found
    }
    
    /**
     * Handles GET requests for listing or taking exams
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();
        
        System.out.println("TakeExamServlet: Path: " + servletPath + (pathInfo != null ? pathInfo : ""));
        
        try {
            // Get the current user ID from session
            String userId = getCurrentUserId(request);
            request.getSession().setAttribute("userId", userId);
            
            // Set current date and time
            request.setAttribute("currentDateTime", CURRENT_DATE_TIME);
            request.setAttribute("currentUserId", userId);
            
            if ("/exams".equals(servletPath)) {
                // Show list of published exams
                List<JsonObject> publishedExams = getPublishedExams();
                request.setAttribute("publishedExams", publishedExams);
                request.setAttribute("viewMode", "list"); // Set viewMode explicitly
                request.getRequestDispatcher("/take-exam.jsp").forward(request, response);
                
            } else if (servletPath.startsWith("/exam/take")) {
                // Get the exam ID from the URL
                String examId = (pathInfo != null && pathInfo.length() > 1) ? 
                    pathInfo.substring(1) : request.getParameter("examId");
                
                System.out.println("TakeExamServlet: Exam ID: " + examId);
                
                if (examId == null || examId.isEmpty()) {
                    // If no specific exam is requested, show all exams
                    List<JsonObject> publishedExams = getPublishedExams();
                    request.setAttribute("publishedExams", publishedExams);
                    request.setAttribute("viewMode", "list"); // Set viewMode explicitly
                    request.getRequestDispatcher("/take-exam.jsp").forward(request, response);
                    return;
                }
                
                // Get the exam data
                JsonObject exam = getExamById(examId);
                if (exam == null) {
                    System.out.println("TakeExamServlet: Exam not found: " + examId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Exam not found");
                    return;
                }
                
                if (!"published".equals(exam.get("status").getAsString())) {
                    System.out.println("TakeExamServlet: Exam not published: " + examId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Exam not published");
                    return;
                }
                
                System.out.println("TakeExamServlet: Found exam: " + exam.toString());
                
                // Get the questions for this exam
                List<JsonObject> questions = loadQuestionsForExam(exam);
                System.out.println("TakeExamServlet: Loaded " + questions.size() + " questions");
                
                // Calculate time remaining
                int durationMinutes = exam.has("duration") ? exam.get("duration").getAsInt() : 60;
                int timeRemainingSeconds = durationMinutes * 60;
                
                // Check if student has an ongoing session
                Long examStartTime = (Long) request.getSession().getAttribute("examStartTime_" + examId);
                if (examStartTime != null) {
                    long currentTime = System.currentTimeMillis();
                    long elapsedSeconds = (currentTime - examStartTime) / 1000;
                    timeRemainingSeconds = durationMinutes * 60 - (int) elapsedSeconds;
                    
                    if (timeRemainingSeconds <= 0) {
                        // Time is up, process submission
                        processForcedSubmission(request, response, examId, userId);
                        return;
                    }
                } else {
                    // Start a new session
                    request.getSession().setAttribute("examStartTime_" + examId, System.currentTimeMillis());
                    
                    // Initialize the student answer linked list for this exam session
                    request.getSession().setAttribute("examAnswers_LinkedList_" + examId, new LinkedList<StudentExamAnswer>());
                }
                
                // Set attributes for the JSP
                request.setAttribute("exam", exam);
                request.setAttribute("questions", questions);
                request.setAttribute("timeRemainingSeconds", timeRemainingSeconds);
                request.setAttribute("viewMode", "take"); // Set viewMode explicitly
                
                // Forward to JSP
                request.getRequestDispatcher("/take-exam.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }
    
    /**
     * Handles POST requests for exam submission
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        
        if ("/exam/submit".equals(servletPath)) {
            // Process exam submission
            String examId = request.getParameter("examId");
            String userId = getCurrentUserId(request); // Use the session-based user ID
            String savedAnswers = request.getParameter("savedAnswers");
            
            System.out.println("Processing exam submission for exam ID: " + examId);
            System.out.println("Saved answers: " + savedAnswers);
            
            try {
                // Process the exam submission
                processExamSubmission(request, response, examId, userId, savedAnswers);
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error submitting exam: " + e.getMessage());
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request");
        }
    }
    
    /**
     * Get all published exams
     */
    private List<JsonObject> getPublishedExams() {
        List<JsonObject> publishedExams = new ArrayList<>();
        
        try {
            List<JsonObject> allExams = loadExams();
            
            // Filter for published exams only
            for (JsonObject exam : allExams) {
                if (exam.has("status") && "published".equals(exam.get("status").getAsString())) {
                    publishedExams.add(exam);
                }
            }
            
            // If no exams found, create a sample exam for testing
            if (publishedExams.isEmpty()) {
                // Create and add a dummy exam for testing if none exist
                JsonObject dummyExam = new JsonObject();
                dummyExam.addProperty("examId", "DB101");
                dummyExam.addProperty("examName", "Database Management Systems Mid-Term");
                dummyExam.addProperty("courseId", "CSE-303");
                dummyExam.addProperty("createdBy", "Robert Smith");
                dummyExam.addProperty("duration", 120);
                dummyExam.addProperty("totalMarks", 100);
                dummyExam.addProperty("status", "published");
                
                // Add dummy questions
                JsonArray questions = new JsonArray();
                questions.add("Q1");
                questions.add("Q2");
                questions.add("Q3");
                questions.add("Q4");
                dummyExam.add("questions", questions);
                
                publishedExams.add(dummyExam);
                
                System.out.println("Created dummy exam for testing");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return publishedExams;
    }
    
    /**
     * Load all exams from the JSON file
     */
    private List<JsonObject> loadExams() {
        List<JsonObject> exams = new ArrayList<>();
        
        try {
            File file = new File(EXAMS_FILE_PATH);
            if (file.exists() && file.canRead()) {
                FileReader reader = new FileReader(file);
                JsonArray jsonArray = JsonParser.parseReader(reader).getAsJsonArray();
                reader.close();
                
                for (JsonElement element : jsonArray) {
                    exams.add(element.getAsJsonObject());
                }
                
                System.out.println("Loaded " + exams.size() + " exams from file");
            } else {
                System.out.println("Exams file does not exist or cannot be read: " + EXAMS_FILE_PATH);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error loading exams: " + e.getMessage());
        }
        
        return exams;
    }
    
    /**
     * Get an exam by its ID
     */
    private JsonObject getExamById(String examId) {
        List<JsonObject> exams = loadExams();
        
        for (JsonObject exam : exams) {
            if (exam.has("examId") && examId.equals(exam.get("examId").getAsString())) {
                return exam;
            }
        }
        
        // If no exam found with this ID, create a dummy one for testing
        JsonObject dummyExam = new JsonObject();
        dummyExam.addProperty("examId", examId);
        dummyExam.addProperty("examName", "Database Management Systems Mid-Term");
        dummyExam.addProperty("courseId", "CSE-303");
        dummyExam.addProperty("createdBy", "Robert Smith");
        dummyExam.addProperty("duration", 120);
        dummyExam.addProperty("totalMarks", 100);
        dummyExam.addProperty("status", "published");
        
        // Add dummy questions
        JsonArray questions = new JsonArray();
        questions.add("Q1");
        questions.add("Q2");
        questions.add("Q3");
        questions.add("Q4");
        dummyExam.add("questions", questions);
        
        System.out.println("Created dummy exam with ID: " + examId);
        
        return dummyExam;
    }
    
    /**
     * Load questions for a specific exam
     */
    private List<JsonObject> loadQuestionsForExam(JsonObject exam) {
        List<JsonObject> examQuestions = new ArrayList<>();
        
        if (exam.has("questions") && exam.get("questions").isJsonArray()) {
            JsonArray questionIds = exam.getAsJsonArray("questions");
            List<JsonObject> allQuestions = loadAllQuestions();
            
            // Create a map for efficient lookup
            Map<String, JsonObject> questionMap = new HashMap<>();
            for (JsonObject question : allQuestions) {
                if (question.has("questionId")) {
                    questionMap.put(question.get("questionId").getAsString(), question);
                }
            }
            
            // Get questions for this exam
            for (JsonElement element : questionIds) {
                String questionId = element.getAsString();
                JsonObject question = questionMap.get(questionId);
                if (question != null) {
                    examQuestions.add(question);
                } else {
                    // Create a dummy question if real question not found
                    JsonObject dummyQuestion = createDummyQuestion(questionId);
                    examQuestions.add(dummyQuestion);
                }
            }
        }
        
        // Ensure we have at least 4 questions
        if (examQuestions.size() < 4) {
            while (examQuestions.size() < 4) {
                String questionId = "Q" + (examQuestions.size() + 1);
                JsonObject dummyQuestion = createDummyQuestion(questionId);
                examQuestions.add(dummyQuestion);
            }
        }
        
        return examQuestions;
    }
    
    /**
     * Create a dummy question for testing
     */
    private JsonObject createDummyQuestion(String questionId) {
        JsonObject question = new JsonObject();
        question.addProperty("questionId", questionId);
        
        if (questionId.equals("Q1")) {
            question.addProperty("questionText", "What is a primary key in a relational database?");
            question.addProperty("questionType", "multiple_choice");
            question.addProperty("points", 5);
            question.addProperty("correctAnswer", "A");
            
            JsonArray options = new JsonArray();
            options.add("A field that uniquely identifies each record in a table");
            options.add("A field that contains text data");
            options.add("A field that can be deleted");
            options.add("A field that contains numeric values only");
            question.add("options", options);
        } else if (questionId.equals("Q2")) {
            question.addProperty("questionText", "A foreign key can reference a non-primary key attribute in another table.");
            question.addProperty("questionType", "true_false");
            question.addProperty("points", 2);
            question.addProperty("correctAnswer", "True");
        } else if (questionId.equals("Q3")) {
            question.addProperty("questionText", "Which normal form deals with transitive dependencies?");
            question.addProperty("questionType", "multiple_choice");
            question.addProperty("points", 5);
            question.addProperty("correctAnswer", "C");
            
            JsonArray options = new JsonArray();
            options.add("First Normal Form (1NF)");
            options.add("Second Normal Form (2NF)");
            options.add("Third Normal Form (3NF)");
            options.add("Boyce-Codd Normal Form (BCNF)");
            question.add("options", options);
        } else {
            question.addProperty("questionText", "Define ACID properties in database transactions.");
            question.addProperty("questionType", "essay");
            question.addProperty("points", 8);
        }
        
        return question;
    }
    
    /**
     * Load all questions from the JSON file
     */
    private List<JsonObject> loadAllQuestions() {
        List<JsonObject> questions = new ArrayList<>();
        
        try {
            File file = new File(QUESTIONS_FILE_PATH);
            if (file.exists() && file.canRead()) {
                FileReader reader = new FileReader(file);
                JsonArray jsonArray = JsonParser.parseReader(reader).getAsJsonArray();
                reader.close();
                
                for (JsonElement element : jsonArray) {
                    questions.add(element.getAsJsonObject());
                }
            } else {
                System.out.println("Questions file does not exist or cannot be read: " + QUESTIONS_FILE_PATH);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return questions;
    }
    
    /**
     * Process a forced submission (when time is up)
     */
    private void processForcedSubmission(HttpServletRequest request, HttpServletResponse response, 
                                        String examId, String userId) 
            throws ServletException, IOException {
        
        // Get any saved answers from the session
        HttpSession session = request.getSession();
        Map<String, String> answerMap = (Map<String, String>) session.getAttribute("examAnswers_" + examId);
        
        if (answerMap == null) {
            answerMap = new HashMap<>();
        }
        
        // Convert to JSON string
        String savedAnswers = gson.toJson(answerMap);
        
        // Process the submission
        processExamSubmission(request, response, examId, userId, savedAnswers);
    }
    
    /**
     * Process the exam submission and calculate results
     */
    private void processExamSubmission(HttpServletRequest request, HttpServletResponse response, 
                                      String examId, String userId, String savedAnswers) 
            throws ServletException, IOException {
        
        try {
            // Get the exam
            JsonObject exam = getExamById(examId);
            if (exam == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Exam not found");
                return;
            }
            
            // Get questions for the exam
            List<JsonObject> questions = loadQuestionsForExam(exam);
            
            // Parse saved answers
            Map<String, String> answerMap = new HashMap<>();
            if (savedAnswers != null && !savedAnswers.isEmpty()) {
                try {
                    // Parse saved answers
                    JsonObject answersJson = JsonParser.parseString(savedAnswers).getAsJsonObject();
                    for (String questionId : answersJson.keySet()) {
                        JsonElement answerElement = answersJson.get(questionId);
                        if (answerElement != null && !answerElement.isJsonNull()) {
                            answerMap.put(questionId, answerElement.getAsString());
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error parsing saved answers: " + e.getMessage());
                }
            }
            
            // Create and populate the linked list for student answers
            LinkedList<StudentExamAnswer> studentAnswersList = new LinkedList<>();
            
            // Create result object
            String resultId = generateResultId();
            JsonObject result = new JsonObject();
            result.addProperty("resultId", resultId);
            result.addProperty("examId", examId);
            result.addProperty("userId", userId);
            result.addProperty("submittedAt", CURRENT_DATE_TIME);
            
            // Get exam start time from session
            HttpSession session = request.getSession();
            Long examStartTime = (Long) session.getAttribute("examStartTime_" + examId);
            long timeTaken = 0;
            if (examStartTime != null) {
                timeTaken = (System.currentTimeMillis() - examStartTime) / 1000;
            }
            result.addProperty("timeTakenSeconds", timeTaken);
            
            // Calculate score
            int totalPoints = 0;
            int earnedPoints = 0;
            JsonArray answersArray = new JsonArray();
            
            // Head of linked list for answers - first answer node
            StudentExamAnswer head = null;
            StudentExamAnswer current = null;
            
            // Also create a node for the main results linked list
            ResultNode resultNode = new ResultNode();
            resultNode.resultId = resultId;
            resultNode.examId = examId;
            resultNode.userId = userId;
            resultNode.submittedAt = CURRENT_DATE_TIME;
            resultNode.timeTakenSeconds = (int) timeTaken;
            resultNode.answers = new ArrayList<>();
            
            for (JsonObject question : questions) {
                String questionId = question.get("questionId").getAsString();
                int points = question.has("points") ? question.get("points").getAsInt() : 0;
                totalPoints += points;
                
                // Create answer object
                JsonObject answerObj = new JsonObject();
                answerObj.addProperty("questionId", questionId);
                
                // Get student's answer
                String answer = answerMap.get(questionId);
                answerObj.addProperty("answer", answer != null ? answer : "");
                
                // Check if answer is correct
                String correctAnswer = question.has("correctAnswer") ? 
                    question.get("correctAnswer").getAsString() : "";
                boolean isCorrect = (answer != null && correctAnswer.equalsIgnoreCase(answer));
                
                if (isCorrect) {
                    earnedPoints += points;
                }
                
                answerObj.addProperty("isCorrect", isCorrect);
                answerObj.addProperty("correctAnswer", correctAnswer);
                
                // Add to answers array
                answersArray.add(answerObj);
                
                // Create a student exam answer node and add to session-based linked list
                StudentExamAnswer newNode = new StudentExamAnswer(
                    userId,
                    examId, 
                    questionId, 
                    answer != null ? answer : "", 
                    isCorrect,
                    points,
                    isCorrect ? points : 0,
                    CURRENT_DATE_TIME
                );
                
                // Add to linked list properly
                if (head == null) {
                    head = newNode;
                    current = head;
                } else {
                    current.next = newNode;
                    newNode.prev = current;
                    current = newNode;
                }
                
                // Also add to ArrayList for easier iteration later
                studentAnswersList.add(newNode);
                
                // Add answer to the main result node
                AnswerNode answerNode = new AnswerNode();
                answerNode.questionId = questionId;
                answerNode.answer = answer != null ? answer : "";
                answerNode.isCorrect = isCorrect;
                answerNode.correctAnswer = correctAnswer;
                resultNode.answers.add(answerNode);
            }
            
            // Calculate percentage score
            double scorePercent = totalPoints > 0 ? (earnedPoints * 100.0) / totalPoints : 0;
            
            // Add results to object
            result.addProperty("score", Math.round(scorePercent * 10) / 10.0); // Round to 1 decimal place
            result.addProperty("totalPoints", totalPoints);
            result.addProperty("earnedPoints", earnedPoints);
            result.add("answers", answersArray);
            
            // Complete the result node data
            resultNode.score = Math.round(scorePercent * 10) / 10.0;
            resultNode.totalPoints = totalPoints;
            resultNode.earnedPoints = earnedPoints;
            
            // Determine if passed
            int passingScore = exam.has("passingScore") ? exam.get("passingScore").getAsInt() : 50;
            boolean passed = scorePercent >= passingScore;
            result.addProperty("passed", passed);
            resultNode.passed = passed;
            
            // Add result to the global linked list
            allStudentResults.addNode(resultNode);
            System.out.println("Added result to linked list. Total results: " + allStudentResults.size());
            
            // Store student answers as linked list in the session
            session.setAttribute("examAnswers_LinkedList_" + examId, studentAnswersList);
            
            // Set the head of the linked list for this submission in session
            session.setAttribute("examAnswers_Head_" + examId, head);
            
            // Print linked list details for debugging
            System.out.println("Student answers stored as linked list for user: " + userId);
            System.out.println("Number of answers in linked list: " + studentAnswersList.size());
            
            // Print the structure of the first few nodes in the linked list for verification
            StudentExamAnswer temp = head;
            int count = 0;
            System.out.println("Answer Linked List Structure:");
            while (temp != null && count < 3) { // Print first 3 nodes
                System.out.println("[" + count + "] QuestionId: " + temp.getQuestionId() + 
                                  ", Answer: " + temp.getAnswer() + 
                                  ", IsCorrect: " + temp.isCorrect());
                temp = temp.next;
                count++;
            }
            
            // Save result to file
            saveExamResult(result);
            
            // Clear session data for this exam
            session.removeAttribute("examStartTime_" + examId);
            session.removeAttribute("examAnswers_" + examId);
            
            // Set attributes for results page
            request.setAttribute("result", result);
            request.setAttribute("exam", exam);
            request.setAttribute("questions", questions);
            request.setAttribute("currentDateTime", CURRENT_DATE_TIME);
            request.setAttribute("currentUserId", userId);
            
            // Forward to results page with correct path
            request.getRequestDispatcher("/exam-result.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error processing submission: " + e.getMessage());
        }
    }
    
    /**
     * Generate a unique result ID
     */
    private String generateResultId() {
        return "result_" + UUID.randomUUID().toString().substring(0, 8);
    }
    
    /**
     * Save the exam result to the JSON file
     */
    private void saveExamResult(JsonObject result) {
        try {
            // Load existing results
            List<JsonObject> results = new ArrayList<>();
            
            File file = new File(RESULTS_FILE_PATH);
            if (file.exists() && file.canRead()) {
                try (FileReader reader = new FileReader(file)) {
                    JsonElement element = JsonParser.parseReader(reader);
                    
                    if (element.isJsonArray()) {
                        JsonArray jsonArray = element.getAsJsonArray();
                        for (JsonElement resultElem : jsonArray) {
                            results.add(resultElem.getAsJsonObject());
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error reading existing results: " + e.getMessage());
                    // Continue with empty results list
                }
            }
            
            // Add new result
            results.add(result);
            
            // Create directory if necessary
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }
            
            // Write results back to file
            try (FileWriter writer = new FileWriter(file)) {
                gson.toJson(results, writer);
                System.out.println("Result saved successfully for user " + result.get("userId").getAsString());
            } catch (Exception e) {
                System.err.println("Error writing results to file: " + e.getMessage());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error saving exam result: " + e.getMessage());
        }
    }
    
    /**
     * Enhanced inner class to represent a student's exam answer in the linked list
     * with additional student information
     */
    private static class StudentExamAnswer {
        // Student information
        private String studentId;
        
        // Exam information
        private String examId;
        private String questionId;
        private String answer;
        private boolean correct;
        
        // Score information
        private int possiblePoints;
        private int earnedPoints;
        
        // Timestamp
        private String submittedAt;
        
        // Linked list pointers
        private StudentExamAnswer next;
        private StudentExamAnswer prev;
        
        public StudentExamAnswer(String studentId, String examId, String questionId, 
                             String answer, boolean correct, int possiblePoints, 
                             int earnedPoints, String submittedAt) {
            this.studentId = studentId;
            this.examId = examId;
            this.questionId = questionId;
            this.answer = answer;
            this.correct = correct;
            this.possiblePoints = possiblePoints;
            this.earnedPoints = earnedPoints;
            this.submittedAt = submittedAt;
            this.next = null;
            this.prev = null;
        }
        
        public String getStudentId() {
            return studentId;
        }
        
        public String getExamId() {
            return examId;
        }
        
        public String getQuestionId() {
            return questionId;
        }
        
        public String getAnswer() {
            return answer;
        }
        
        public boolean isCorrect() {
            return correct;
        }
        
        public int getPossiblePoints() {
            return possiblePoints;
        }
        
        public int getEarnedPoints() {
            return earnedPoints;
        }
        
        public String getSubmittedAt() {
            return submittedAt;
        }
        
        @Override
        public String toString() {
            return "{studentId: " + studentId + 
                   ", examId: " + examId +
                   ", questionId: " + questionId + 
                   ", answer: " + answer + 
                   ", correct: " + correct +
                   ", earnedPoints: " + earnedPoints + "/" + possiblePoints + "}";
        }
    }
    
    /**
     * Node class for answers within a result
     */
    private static class AnswerNode {
        String questionId;
        String answer;
        boolean isCorrect;
        String correctAnswer;
    }
    
    /**
     * Node class for results in the linked list
     */
    private static class ResultNode {
        // Result data
        String resultId;
        String examId;
        String userId;
        String submittedAt;
        int timeTakenSeconds;
        double score;
        int totalPoints;
        int earnedPoints;
        List<AnswerNode> answers;
        boolean passed;
        
        // Linked list pointers
        ResultNode next;
        ResultNode prev;
        
        public ResultNode() {
            this.next = null;
            this.prev = null;
        }
    }
    
    /**
     * Linked List implementation to store exam results
     */
    private static class ResultsLinkedList {
        private ResultNode head;
        private ResultNode tail;
        private int size;
        
        public ResultsLinkedList() {
            this.head = null;
            this.tail = null;
            this.size = 0;
        }
        
        /**
         * Add a new result node to the end of the list
         */
        public void addNode(ResultNode node) {
            if (node == null) return;
            
            node.next = null; // Ensure no existing references
            
            if (head == null) {
                // First node
                head = node;
                tail = node;
                node.prev = null;
            } else {
                // Add to end
                tail.next = node;
                node.prev = tail;
                tail = node;
            }
            
            size++;
        }
        
        /**
         * Find a result by ID
         */
        public ResultNode findById(String resultId) {
            if (resultId == null) return null;
            
            ResultNode current = head;
            while (current != null) {
                if (resultId.equals(current.resultId)) {
                    return current;
                }
                current = current.next;
            }
            
            return null; // Not found
        }
        
        /**
         * Find all results for a specific user
         */
        public List<ResultNode> findByUserId(String userId) {
            List<ResultNode> userResults = new ArrayList<>();
            if (userId == null) return userResults;
            
            ResultNode current = head;
            while (current != null) {
                if (userId.equals(current.userId)) {
                    userResults.add(current);
                }
                current = current.next;
            }
            
            return userResults;
        }
        
        /**
         * Find all results for a specific exam
         */
        public List<ResultNode> findByExamId(String examId) {
            List<ResultNode> examResults = new ArrayList<>();
            if (examId == null) return examResults;
            
            ResultNode current = head;
            while (current != null) {
                if (examId.equals(current.examId)) {
                    examResults.add(current);
                }
                current = current.next;
            }
            
            return examResults;
        }
        
        /**
         * Get the size of the list
         */
        public int size() {
            return size;
        }
        
        /**
         * Convert the linked list to a list of JsonObjects for storage
         */
        public List<JsonObject> toJsonList() {
            List<JsonObject> jsonList = new ArrayList<>();
            ResultNode current = head;
            
            while (current != null) {
                JsonObject resultObj = new JsonObject();
                resultObj.addProperty("resultId", current.resultId);
                resultObj.addProperty("examId", current.examId);
                resultObj.addProperty("userId", current.userId);
                resultObj.addProperty("submittedAt", current.submittedAt);
                resultObj.addProperty("timeTakenSeconds", current.timeTakenSeconds);
                resultObj.addProperty("score", current.score);
                resultObj.addProperty("totalPoints", current.totalPoints);
                resultObj.addProperty("earnedPoints", current.earnedPoints);
                resultObj.addProperty("passed", current.passed);
                
                // Add answers
                JsonArray answersArray = new JsonArray();
                if (current.answers != null) {
                    for (AnswerNode answer : current.answers) {
                        JsonObject answerObj = new JsonObject();
                        answerObj.addProperty("questionId", answer.questionId);
                        answerObj.addProperty("answer", answer.answer);
                        answerObj.addProperty("isCorrect", answer.isCorrect);
                        answerObj.addProperty("correctAnswer", answer.correctAnswer);
                        answersArray.add(answerObj);
                    }
                }
                resultObj.add("answers", answersArray);
                
                jsonList.add(resultObj);
                current = current.next;
            }
            
            return jsonList;
        }
        
        /**
         * Debug function to print the list
         */
        public void printList() {
            ResultNode current = head;
            int i = 0;
            
            while (current != null) {
                System.out.println("[" + i + "] ResultID: " + current.resultId +
                                  ", User: " + current.userId +
                                  ", Exam: " + current.examId +
                                  ", Score: " + current.score + "%");
                current = current.next;
                i++;
            }
        }
    }
}