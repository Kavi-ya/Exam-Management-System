package com.exam.servlets;

import java.io.IOException;
import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.exam.model.Result;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;

@WebServlet("/leaderboard")
public class LeaderboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // File paths as requested
    private static final String RESULTS_FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\results.json";
    private static final String EXAMS_FILE_PATH = "E:\\Exam-Result Management System\\Exam management system\\src\\main\\webapp\\WEB-INF\\data\\exams.json";
    
    // Current user (fixed as requested)
    private static final String CURRENT_USER = "IT24102083";
    
    // Define passing threshold (60% is common)
    private static final double PASSING_THRESHOLD = 60.0;

    // Helper class to match the results JSON structure
    private static class ResultData {
        public String resultId;
        public String examId;
        public String userId;
        public String submittedAt;
        public int timeTakenSeconds;
        public double score;
        public int totalPoints;
        public int earnedPoints;
        public List<AnswerData> answers;
        public boolean passed;

        // Inner class for answer data
        private static class AnswerData {
            public String questionId;
            public String answer;
            public boolean isCorrect;
            public String correctAnswer;
        }
    }
    
    // Helper class to match the exams JSON structure
    private static class ExamData {
        public String examId;
        public String title;
        public String description;
        public int timeLimit;
        public String createdBy;
        public String createdAt;
        // Add other fields as needed based on actual exam.json structure
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Debug information map
        Map<String, Object> debugInfo = new HashMap<>();
        
        // Fixed date and time as requested
        String currentDateTime = "2025-05-05 00:00:00";
        
        // Current user as requested
        String currentUser = CURRENT_USER;
        
        // Load exams from JSON with debug info
        List<ExamData> exams = new ArrayList<>();
        try {
            exams = loadExamsFromJson();
            debugInfo.put("examsLoaded", exams.size());
            debugInfo.put("examsFilePath", EXAMS_FILE_PATH);
            debugInfo.put("examsFileExists", Files.exists(Paths.get(EXAMS_FILE_PATH)));
        } catch (Exception e) {
            String errorMsg = "Error loading exams: " + e.getMessage();
            debugInfo.put("examsError", errorMsg);
            e.printStackTrace();
        }
        
        // Create map of exam IDs to titles for display purposes
        Map<String, String> examTitles = new HashMap<>();
        for (ExamData exam : exams) {
            examTitles.put(exam.examId, exam.title != null ? exam.title : exam.examId);
        }
        
        // Read and parse results JSON data using GSON with debug info
        List<Result> allResults = new ArrayList<>();
        try {
            allResults = loadResultsFromJson();
            debugInfo.put("resultsLoaded", allResults.size());
            debugInfo.put("resultsFilePath", RESULTS_FILE_PATH);
            debugInfo.put("resultsFileExists", Files.exists(Paths.get(RESULTS_FILE_PATH)));
        } catch (Exception e) {
            String errorMsg = "Error loading results: " + e.getMessage();
            debugInfo.put("resultsError", errorMsg);
            request.setAttribute("errorMessage", errorMsg);
            e.printStackTrace();
        }
        
        // Get unique exams from results
        Set<String> uniqueExamIds = getUniqueExams(allResults);
        debugInfo.put("uniqueExamsFound", uniqueExamIds.size());
        debugInfo.put("uniqueExamIdsList", uniqueExamIds);
        
        // Get selected exam from request parameter or use the first exam
        String selectedExamId = request.getParameter("examId");
        if (selectedExamId == null && !uniqueExamIds.isEmpty()) {
            selectedExamId = uniqueExamIds.iterator().next();
        }
        debugInfo.put("selectedExamId", selectedExamId);
        
        // Filter results by selected exam
        List<Result> filteredResults = allResults.stream()
            .filter(r -> r.getExamId().equals(selectedExamId))
            .collect(Collectors.toList());
        debugInfo.put("filteredResultsCount", filteredResults.size());
        
        // Apply Selection Sort
        selectionSort(filteredResults);
        debugInfo.put("sortingAlgorithm", "Selection Sort");
        
        // Set attributes for JSP
        request.setAttribute("allResults", allResults);
        request.setAttribute("filteredResults", filteredResults);
        request.setAttribute("uniqueExamIds", uniqueExamIds);
        request.setAttribute("examTitles", examTitles);
        request.setAttribute("selectedExamId", selectedExamId);
        request.setAttribute("currentDateTime", currentDateTime);
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("debugInfo", debugInfo);
        request.setAttribute("showDebug", request.getParameter("debug") != null);
        
        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/views/leaderboard.jsp").forward(request, response);
    }
    
    // Load exams from exams.json file
    private List<ExamData> loadExamsFromJson() throws IOException, JsonSyntaxException {
        try (Reader reader = Files.newBufferedReader(Paths.get(EXAMS_FILE_PATH))) {
            Gson gson = new Gson();
            return gson.fromJson(reader, new TypeToken<List<ExamData>>(){}.getType());
        }
    }
    
    // Load results from results.json file
    private List<Result> loadResultsFromJson() throws IOException, JsonSyntaxException {
        List<Result> results = new ArrayList<>();
        try (Reader reader = Files.newBufferedReader(Paths.get(RESULTS_FILE_PATH))) {
            Gson gson = new Gson();
            List<ResultData> resultDataList = gson.fromJson(reader, 
                new TypeToken<List<ResultData>>(){}.getType());
            
            // Convert to Result model
            for (ResultData data : resultDataList) {
                results.add(convertToResultModel(data));
            }
        }
        return results;
    }

    private Result convertToResultModel(ResultData data) {
        Result result = new Result();
        result.setResultId(data.resultId);
        result.setStudentId(data.userId);
        result.setExamId(data.examId);
        result.setScore(data.earnedPoints);
        result.setMaxScore(data.totalPoints);
        
        // Determine passed state based on percentage score and threshold
        double percentage = 0;
        if (data.totalPoints > 0) {
            percentage = ((double) data.earnedPoints / data.totalPoints) * 100;
        }
        
        // CHANGED: Prioritize the percentage calculation over the JSON data
        // If the score is above the threshold, consider it passed regardless of JSON value
        boolean hasPassed = percentage >= PASSING_THRESHOLD;
        result.setPassed(hasPassed);
        
        result.setSubmissionTime(data.submittedAt);
        
        // Convert answers from List to Map
        Map<String, String> answersMap = new HashMap<>();
        if (data.answers != null) {
            for (ResultData.AnswerData answer : data.answers) {
                answersMap.put(answer.questionId, answer.answer);
            }
        }
        result.setAnswers(answersMap);
        
        return result;
    }

    // Selection Sort implementation for Result objects
    private void selectionSort(List<Result> results) {
        int n = results.size();
        
        for (int i = 0; i < n - 1; i++) {
            // Find the index of max element in unsorted part
            int maxIndex = i;
            for (int j = i + 1; j < n; j++) {
                // Compare by percentage (higher is better)
                if (results.get(j).getPercentage() > results.get(maxIndex).getPercentage()) {
                    maxIndex = j;
                }
            }
            
            // Swap the max element with the current position
            Result temp = results.get(maxIndex);
            results.set(maxIndex, results.get(i));
            results.set(i, temp);
        }
    }

    // Get unique exams
    private Set<String> getUniqueExams(List<Result> results) {
        Set<String> uniqueExams = new HashSet<>();
        for (Result result : results) {
            uniqueExams.add(result.getExamId());
        }
        return uniqueExams;
    }
}