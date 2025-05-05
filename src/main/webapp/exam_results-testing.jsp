<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.google.gson.JsonObject, com.google.gson.JsonArray" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
    // Get attributes
    JsonObject exam = (JsonObject) request.getAttribute("exam");
    List<JsonObject> questions = (List<JsonObject>) request.getAttribute("questions");
    JsonObject result = (JsonObject) request.getAttribute("result");
    String currentDateTime = (String) request.getAttribute("currentDateTime");
    String currentUserId = (String) request.getAttribute("currentUserId");
    
    // Default values if attributes are null
    if (exam == null) exam = new JsonObject();
    if (questions == null) questions = java.util.Collections.emptyList();
    if (result == null) result = new JsonObject();
    if (currentDateTime == null) currentDateTime = "2025-03-26 20:47:14"; // Updated current date/time
    if (currentUserId == null) currentUserId = "IT24102083"; // Default user ID
    
    // Extract result data
    double score = result.has("score") ? result.get("score").getAsDouble() : 0.0;
    int earnedPoints = result.has("earnedPoints") ? result.get("earnedPoints").getAsInt() : 0;
    int totalPoints = result.has("totalPoints") ? result.get("totalPoints").getAsInt() : 0;
    boolean passed = result.has("passed") ? result.get("passed").getAsBoolean() : false;
    String submittedAt = result.has("submittedAt") ? result.get("submittedAt").getAsString() : currentDateTime;
    long timeTakenSeconds = result.has("timeTakenSeconds") ? result.get("timeTakenSeconds").getAsLong() : 0;
    JsonArray answers = result.has("answers") ? result.getAsJsonArray("answers") : new JsonArray();
    
    // Get exam details
    String examName = exam.has("examName") ? exam.get("examName").getAsString() : "Exam";
    String courseId = exam.has("courseId") ? exam.get("courseId").getAsString() : "";
    
    // Calculate performance metrics
    int totalQuestions = questions.size();
    int correctAnswers = 0;
    int incorrectAnswers = 0;
    int unansweredQuestions = 0;
    
    // Create a map for efficient answer lookup
    Map<String, JsonObject> answerMap = new java.util.HashMap<>();
    for (int j = 0; j < answers.size(); j++) {
        JsonObject answer = answers.get(j).getAsJsonObject();
        if (answer.has("questionId")) {
            answerMap.put(answer.get("questionId").getAsString(), answer);
            
            // Count correct and incorrect answers
            if (answer.has("isCorrect") && answer.get("isCorrect").getAsBoolean()) {
                correctAnswers++;
            } else {
                incorrectAnswers++;
            }
            
            // Check if answer was actually provided
            if (!answer.has("answer") || answer.get("answer").getAsString().isEmpty()) {
                unansweredQuestions++;
                incorrectAnswers--; // Adjust the count
            }
        }
    }
    
    // Calculate additional metrics
    double accuracyRate = totalQuestions > 0 ? (double)correctAnswers / totalQuestions * 100 : 0;
    double completionRate = totalQuestions > 0 ? (double)(totalQuestions - unansweredQuestions) / totalQuestions * 100 : 0;
    String timeEfficiency = "Average"; // Default
    
    // Determine time efficiency
    if (timeTakenSeconds > 0 && totalQuestions > 0) {
        double avgTimePerQuestion = (double)timeTakenSeconds / totalQuestions;
        if (avgTimePerQuestion < 30) { // Less than 30 seconds per question
            timeEfficiency = "Excellent";
        } else if (avgTimePerQuestion < 60) { // Less than 1 minute per question
            timeEfficiency = "Good";
        } else if (avgTimePerQuestion < 120) { // Less than 2 minutes per question
            timeEfficiency = "Average";
        } else {
            timeEfficiency = "Needs Improvement";
        }
    }
    
    // Determine strengths and areas for improvement
    String strength = "None identified";
    String improvement = "None identified";
    
    // This would ideally be based on categorized questions, but we'll use a simple heuristic
    if (accuracyRate >= 70) {
        strength = "Strong overall understanding";
    } else if (completionRate < 80) {
        improvement = "Work on time management";
    } else {
        improvement = "Review core concepts";
    }
    %>
    <title>Exam Results - <%= examName %></title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Chart.js for Performance Visualization -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <style>
        :root {
            --primary-color: #667eea;
            --primary-dark: #5a6ecd;
            --secondary-color: #764ba2;
            --secondary-dark: #6a439a;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
        }
        
        body {
            font-family: 'Nunito', sans-serif;
            background-color: #f5f7fa;
            min-height: 100vh;
        }
        
        /* Header */
        .result-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            animation: fadeIn 1s;
        }
        
        .result-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(rgba(255,255,255,0.1), transparent);
            transform: rotate(-30deg);
            z-index: 0;
        }
        
        .result-title {
            font-weight: 800;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
            animation: fadeInDown 1s;
        }
        
        .result-subtitle {
            font-weight: 600;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }
        
        /* Score Section */
        .score-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
            animation: fadeInUp 1s;
        }
        
        .score-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }
        
        .score-circle {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            font-size: 3rem;
            font-weight: 800;
            position: relative;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .score-circle.passing {
            background: linear-gradient(135deg, var(--success-color), #1e7e34);
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.4);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(40, 167, 69, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(40, 167, 69, 0);
            }
        }
        
        .score-circle.failing {
            background: linear-gradient(135deg, var(--danger-color), #bd2130);
        }
        
        .score-percent {
            font-size: 3rem;
            font-weight: 800;
            animation: countUp 2s ease-out forwards;
        }
        
        .score-label {
            position: absolute;
            bottom: -10px;
            left: 0;
            right: 0;
            background-color: white;
            padding: 5px 10px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 700;
            width: 80px;
            margin: 0 auto;
            color: var(--dark-color);
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }
        
        .score-details {
            margin-top: 20px;
        }
        
        .score-detail-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        .score-detail-item:last-child {
            border-bottom: none;
        }
        
        .score-status {
            font-size: 1.5rem;
            font-weight: 700;
            margin-top: 15px;
            padding: 10px 20px;
            border-radius: 50px;
            animation: fadeInUp 1.5s;
        }
        
        .score-status.pass {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .score-status.fail {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }
        
        /* Performance Summary */
        .performance-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            font-weight: 700;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
            color: var(--dark-color);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            height: 3px;
            width: 60px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
            border-radius: 3px;
        }
        
        .performance-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
            animation: fadeInUp 1.2s;
        }
        
        .performance-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }
        
        .performance-chart-container {
            position: relative;
            height: 230px;
            margin-bottom: 20px;
        }
        
        .key-metric {
            text-align: center;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        
        .key-metric:hover {
            transform: translateY(-3px);
        }
        
        .key-metric-value {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 5px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .key-metric-label {
            font-size: 0.9rem;
            font-weight: 700;
            color: var(--dark-color);
            opacity: 0.7;
        }
        
        .performance-metric {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px;
            border-radius: 10px;
            transition: all 0.3s;
        }
        
        .performance-metric:hover {
            background-color: rgba(0,0,0,0.02);
        }
        
        .metric-icon {
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            margin-right: 15px;
            font-size: 1.2rem;
            color: white;
        }
        
        .accuracy-icon {
            background: linear-gradient(135deg, #20bf55, #01baef);
        }
        
        .completion-icon {
            background: linear-gradient(135deg, #f857a6, #ff5858);
        }
        
        .time-icon {
            background: linear-gradient(135deg, #ffb347, #ffcc33);
        }
        
        .metric-details {
            flex-grow: 1;
        }
        
        .metric-title {
            font-weight: 700;
            margin-bottom: 2px;
        }
        
        .metric-value {
            font-size: 0.9rem;
            color: var(--dark-color);
            opacity: 0.7;
        }
        
        .insight-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
            height: 100%;
            animation: fadeInUp 1.3s;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .insight-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }
        
        .insight-title {
            font-weight: 700;
            margin-bottom: 15px;
            color: var(--primary-color);
        }
        
        .insight-list {
            padding-left: 0;
            list-style-type: none;
        }
        
        .insight-item {
            position: relative;
            padding-left: 30px;
            margin-bottom: 15px;
            line-height: 1.6;
        }
        
        .insight-item:before {
            content: '';
            position: absolute;
            left: 0;
            top: 8px;
            width: 12px;
            height: 12px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
        }
        
        .insight-item.strength:before {
            background: linear-gradient(135deg, var(--success-color), #1e7e34);
        }
        
        .insight-item.improvement:before {
            background: linear-gradient(135deg, var(--warning-color), #d39e00);
        }
        
        /* Questions Review */
        .review-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            overflow: hidden;
            animation: fadeInUp 1.4s;
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .review-question {
            font-weight: 700;
        }
        
        .review-marks {
            font-weight: 600;
            color: var(--primary-color);
        }
        
        .review-content {
            margin-bottom: 15px;
        }
        
        .review-answer-label {
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .review-answer {
            background-color: #f8f9fa;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            transition: all 0.2s;
        }
        
        .review-answer:hover {
            transform: translateX(5px);
        }
        
        .review-answer.correct {
            background-color: rgba(40, 167, 69, 0.1);
            border-left: 4px solid var(--success-color);
        }
        
        .review-answer.incorrect {
            background-color: rgba(220, 53, 69, 0.1);
            border-left: 4px solid var(--danger-color);
        }
        
        .review-answer.correct-answer {
            background-color: rgba(23, 162, 184, 0.1);
            border-left: 4px solid var(--info-color);
        }
        
        .review-status-icon {
            display: inline-block;
            width: 25px;
            height: 25px;
            line-height: 25px;
            text-align: center;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .icon-correct {
            background-color: var(--success-color);
            color: white;
        }
        
        .icon-incorrect {
            background-color: var(--danger-color);
            color: white;
        }
        
        /* Accordion styling */
        .accordion-item {
            border: none;
            margin-bottom: 15px;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
        }
        
        .accordion-item:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .accordion-button {
            padding: 15px 20px;
            font-weight: 600;
            background-color: white;
        }
        
        .accordion-button:not(.collapsed) {
            color: var(--primary-color);
            background-color: rgba(102, 126, 234, 0.05);
        }
        
        .accordion-button:focus {
            box-shadow: none;
            border-color: rgba(0, 0, 0, 0.125);
        }
        
        .accordion-body {
            padding: 20px;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
            margin-bottom: 60px;
        }
        
        .btn-home, .btn-view-answers {
            padding: 14px 28px;
            border-radius: 50px;
            font-weight: 700;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
            z-index: 1;
            animation: fadeInUp 1.8s;
        }
        
        .btn-home:before, .btn-view-answers:before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 0%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.1);
            transition: all 0.3s;
            z-index: -1;
        }
        
        .btn-home:hover:before, .btn-view-answers:hover:before {
            width: 100%;
        }
        
        .btn-home {
            background-color: var(--dark-color);
            border-color: var(--dark-color);
            color: white;
        }
        
        .btn-home:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }
        
        .btn-view-answers {
            background-color: white;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
        }
        
        .btn-view-answers:hover {
            background-color: var(--primary-color);
            color: white;
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(102, 126, 234, 0.3);
        }
        
        /* Current Date Display */
        .current-date {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: rgba(255, 255, 255, 0.95);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 10px 15px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            z-index: 1000;
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
            animation: slideInRight 0.5s;
        }
        
        .current-date i {
            margin-right: 5px;
            color: var(--primary-color);
        }
        
        /* User Info Display */
        .user-info {
            position: fixed;
            top: 70px;
            right: 20px;
            background-color: rgba(255, 255, 255, 0.95);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 10px 15px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            z-index: 1000;
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
            animation: slideInRight 0.7s;
        }
        
        .user-info i {
            margin-right: 5px;
            color: var(--primary-color);
        }
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes countUp {
            from { content: "0%"; }
            to { content: "<%= score %>%"; }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .score-circle {
                width: 150px;
                height: 150px;
                font-size: 2.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-home, .btn-view-answers {
                width: 100%;
            }
            
            .key-metric-value {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
    <!-- Current Date Display -->
    <div class="current-date">
        <i class="fas fa-calendar-alt"></i>
        <span><%= currentDateTime %></span>
    </div>
    
    <!-- User Info Display -->
    <div class="user-info">
        <i class="fas fa-user"></i>
        <span><%= currentUserId %></span>
    </div>
    
    <!-- Result Header -->
    <header class="result-header">
        <div class="container">
            <h1 class="result-title">Exam Results</h1>
            <div class="result-subtitle"><%= examName %> • <%= courseId %></div>
        </div>
    </header>
    
    <div class="container">
        <div class="row mb-4">
            <!-- Score Card -->
            <div class="col-lg-4 mb-4">
                <div class="score-card">
                    <div class="score-circle <%= passed ? "passing" : "failing" %>">
                        <span class="score-percent" id="scoreDisplay">0%</span>
                        <div class="score-label">Score</div>
                    </div>
                    
                    <div class="score-status <%= passed ? "pass" : "fail" %>">
                        <i class="fas <%= passed ? "fa-check-circle" : "fa-times-circle" %> me-2"></i>
                        <%= passed ? "PASSED" : "FAILED" %>
                    </div>
                    
                    <div class="score-details mt-4">
                        <div class="score-detail-item">
                            <div>Total Questions</div>
                            <div><strong><%= questions.size() %></strong></div>
                        </div>
                        
                        <div class="score-detail-item">
                            <div>Total Marks</div>
                            <div><strong><%= totalPoints %></strong></div>
                        </div>
                        
                        <div class="score-detail-item">
                            <div>Marks Obtained</div>
                            <div><strong><%= earnedPoints %></strong></div>
                        </div>
                        
                        <div class="score-detail-item">
                            <div>Time Taken</div>
                            <div><strong><%= Math.floor(timeTakenSeconds / 60) %>m <%= timeTakenSeconds % 60 %>s</strong></div>
                        </div>
                        
                        <div class="score-detail-item">
                            <div>Date</div>
                            <div><strong><%= submittedAt %></strong></div>
                        </div>
                        
                        <div class="score-detail-item">
                            <div>Student ID</div>
                            <div><strong><%= currentUserId %></strong></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Performance Summary -->
            <div class="col-lg-8">
                <h3 class="section-title">Performance Summary</h3>
                <div class="row">
                    <!-- Performance Metrics -->
                    <div class="col-md-6 mb-4">
                        <div class="performance-card">
                            <h4 class="mb-3">Answer Distribution</h4>
                            <div class="performance-chart-container">
                                <canvas id="answerDistributionChart"></canvas>
                            </div>
                            <div class="row">
                                <div class="col-4">
                                    <div class="key-metric">
                                        <div class="key-metric-value"><%= correctAnswers %></div>
                                        <div class="key-metric-label">Correct</div>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="key-metric">
                                        <div class="key-metric-value"><%= incorrectAnswers %></div>
                                        <div class="key-metric-label">Incorrect</div>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="key-metric">
                                        <div class="key-metric-value"><%= unansweredQuestions %></div>
                                        <div class="key-metric-label">Unanswered</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Performance Metrics -->
                    <div class="col-md-6 mb-4">
                        <div class="performance-card">
                            <h4 class="mb-3">Performance Metrics</h4>
                            
                            <div class="performance-metric">
                                <div class="metric-icon accuracy-icon">
                                    <i class="fas fa-bullseye"></i>
                                </div>
                                <div class="metric-details">
                                    <div class="metric-title">Accuracy Rate</div>
                                    <div class="metric-value">
                                        <%= String.format("%.1f", accuracyRate) %>% of your answers were correct
                                    </div>
                                </div>
                            </div>
                            
                            <div class="performance-metric">
                                <div class="metric-icon completion-icon">
                                    <i class="fas fa-tasks"></i>
                                </div>
                                <div class="metric-details">
                                    <div class="metric-title">Completion Rate</div>
                                    <div class="metric-value">
                                        <%= String.format("%.1f", completionRate) %>% of questions attempted
                                    </div>
                                </div>
                            </div>
                            
                            <div class="performance-metric">
                                <div class="metric-icon time-icon">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="metric-details">
                                    <div class="metric-title">Time Efficiency</div>
                                    <div class="metric-value">
                                        <%= timeEfficiency %> - Avg <%= String.format("%.1f", (double)timeTakenSeconds / Math.max(1, totalQuestions)) %> seconds per question
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Insights and Recommendations -->
                    <div class="col-12 mb-4">
                        <div class="insight-card">
                            <h4 class="insight-title">Insights & Recommendations</h4>
                            <ul class="insight-list">
                                <li class="insight-item strength">
                                    <strong>Strength:</strong> <%= strength %>
                                </li>
                                <li class="insight-item improvement">
                                    <strong>Area for improvement:</strong> <%= improvement %>
                                </li>
                                <% if (unansweredQuestions > 0) { %>
                                <li class="insight-item">
                                    <strong>Tip:</strong> You left <%= unansweredQuestions %> questions unanswered. Remember to answer all questions, even if you're unsure, to maximize your score potential.
                                </li>
                                <% } %>
                                <% if (timeTakenSeconds > 0 && totalQuestions > 0) { %>
                                <li class="insight-item">
                                    <strong>Study Tip:</strong> Focus on strengthening topics where you struggled most to improve your overall performance.
                                </li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Questions Review -->
        <div class="row">
            <div class="col-12">
                <h3 class="section-title mb-4">Question Review</h3>
                
                <div class="accordion" id="questionReviewAccordion">
                    <% 
                    // Display each question with answers
                    for (int i = 0; i < questions.size(); i++) {
                        JsonObject question = questions.get(i);
                        String questionId = question.has("questionId") ? question.get("questionId").getAsString() : "";
                        String questionText = question.has("questionText") ? question.get("questionText").getAsString() : "";
                        int points = question.has("points") ? question.get("points").getAsInt() : 0;
                        
                        // Find matching answer
                        JsonObject answerObj = answerMap.get(questionId);
                        boolean isCorrect = answerObj != null && answerObj.has("isCorrect") ? 
                            answerObj.get("isCorrect").getAsBoolean() : false;
                        String studentAnswer = answerObj != null && answerObj.has("answer") ? 
                            answerObj.get("answer").getAsString() : "";
                        String correctAnswer = answerObj != null && answerObj.has("correctAnswer") ? 
                            answerObj.get("correctAnswer").getAsString() : "";
                    %>
                        <div class="accordion-item mb-3">
                            <h2 class="accordion-header" id="heading<%= i %>">
                                <button class="accordion-button <%= i == 0 ? "" : "collapsed" %>" type="button" 
                                        data-bs-toggle="collapse" data-bs-target="#collapse<%= i %>" 
                                        aria-expanded="<%= i == 0 ? "true" : "false" %>" aria-controls="collapse<%= i %>">
                                    <div class="d-flex justify-content-between w-100 align-items-center pe-3">
                                        <div>
                                            <span class="review-status-icon <%= isCorrect ? "icon-correct" : "icon-incorrect" %>">
                                                <i class="fas <%= isCorrect ? "fa-check" : "fa-times" %>"></i>
                                            </span>
                                            Question <%= i + 1 %>
                                        </div>
                                        <div class="text-muted small"><%= points %> Marks</div>
                                    </div>
                                </button>
                            </h2>
                            <div id="collapse<%= i %>" class="accordion-collapse collapse <%= i == 0 ? "show" : "" %>" 
                                 aria-labelledby="heading<%= i %>" data-bs-parent="#questionReviewAccordion">
                                <div class="accordion-body">
                                    <div class="review-content">
                                        <p><%= questionText %></p>
                                    </div>
                                    
                                    <div class="review-answer-label">Your Answer:</div>
                                    <div class="review-answer <%= isCorrect ? "correct" : "incorrect" %>">
                                        <%= studentAnswer.isEmpty() ? "<em>No answer provided</em>" : studentAnswer %>
                                    </div>
                                    
                                    <% if (!isCorrect) { %>
                                        <div class="review-answer-label">Correct Answer:</div>
                                        <div class="review-answer correct-answer">
                                            <%= correctAnswer %>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/exams" class="btn btn-primary btn-home">
                <i class="fas fa-home me-2"></i> Back to Exams
            </a>
            <a href="${pageContext.request.contextPath}/student_dashboard.jsp" class="btn btn-dark btn-home">
                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Chart.js Initialization -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animate score counter
            animateScore();
            
            // Initialize charts
            initializeCharts();
            
            // Enhance accordion items on hover
            enhanceAccordion();
        });
        
        function animateScore() {
            const scoreDisplay = document.getElementById('scoreDisplay');
            const targetScore = <%= score %>;
            let currentScore = 0;
            const duration = 1500; // ms
            const interval = 20; // ms
            const steps = duration / interval;
            const increment = targetScore / steps;
            
            const counter = setInterval(() => {
                currentScore += increment;
                
                if (currentScore >= targetScore) {
                    currentScore = targetScore;
                    clearInterval(counter);
                }
                
                scoreDisplay.textContent = Math.round(currentScore) + '%';
            }, interval);
        }
        
        function initializeCharts() {
            // Answer distribution chart
            const ctxDist = document.getElementById('answerDistributionChart').getContext('2d');
            
            new Chart(ctxDist, {
                type: 'doughnut',
                data: {
                    labels: ['Correct', 'Incorrect', 'Unanswered'],
                    datasets: [{
                        data: [<%= correctAnswers %>, <%= incorrectAnswers %>, <%= unansweredQuestions %>],
                        backgroundColor: [
                            '#28a745',  // success-color
                            '#dc3545',  // danger-color
                            '#e9ecef'   // light gray
                        ],
                        borderWidth: 1,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                font: {
                                    family: 'Nunito'
                                }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const total = <%= totalQuestions %>;
                                    const value = context.raw;
                                    const percentage = Math.round((value / total) * 100);
                                    return `${context.label}: ${value} (${percentage}%)`;
                                }
                            }
                        }
                    },
                    animation: {
                        animateRotate: true,
                        animateScale: true,
                        duration: 1500,
                        easing: 'easeOutCubic'
                    }
                }
            });
        }
        
        function enhanceAccordion() {
            const accordionItems = document.querySelectorAll('.accordion-item');
            
            accordionItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    if (!this.querySelector('.accordion-button').classList.contains('collapsed')) {
                        return; // Don't apply effect to open items
                    }
                    this.style.transform = 'translateY(-3px)';
                    this.style.boxShadow = '0 8px 15px rgba(0, 0, 0, 0.1)';
                });
                
                item.addEventListener('mouseleave', function() {
                    if (!this.querySelector('.accordion-button').classList.contains('collapsed')) {
                        return; // Don't apply effect to open items
                    }
                    this.style.transform = '';
                    this.style.boxShadow = '';
                });
            });
        }
    </script>
</body>
</html>